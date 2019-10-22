# frozen_string_literal: true

require "appsignal"
require_relative "appsignal_ext"

# Remove Appsignal's own Sidekiq integration hook, so the Snowpack-hosted
# integration can be included manually.
Appsignal::Hooks.hooks.delete :sidekiq

module Snowpack
  module Instrumentation
    module Appsignal
      module Sidekiq
        def self.install
          ::Appsignal::Minutely.probes.register :sidekiq, ::Appsignal::Hooks::SidekiqProbe

          ::Sidekiq.configure_server do |config|
            config.server_middleware do |chain|
              chain.add Plugin
            end
          end
        end

        class Plugin < ::Appsignal::Hooks::SidekiqPlugin
          # Copy over original method, add transaction.discard! behavior
          def call(worker, item, _queue)
            job_status = nil
            transaction = ::Appsignal::Transaction.create(
              SecureRandom.uuid,
              ::Appsignal::Transaction::BACKGROUND_JOB,
              ::Appsignal::Transaction::GenericRequest.new(
                :queue_start => item["enqueued_at"]
              )
            )

            # Add this behavior
            transaction.discard! unless worker.instrument?

            ::Appsignal.instrument "perform_job.sidekiq" do
              begin
                yield
              rescue Exception => exception # rubocop:disable Lint/RescueException
                job_status = :failed
                transaction.set_error(exception)
                raise exception
              end
            end
          ensure
            if transaction
              transaction.set_action_if_nil(formatted_action_name(item))
              transaction.params = filtered_arguments(item)
              formatted_metadata(item).each do |key, value|
                transaction.set_metadata key, value
              end
              transaction.set_http_or_background_queue_start
              ::Appsignal::Transaction.complete_current!
              queue = item["queue"] || "unknown"
              if job_status
                increment_counter "queue_job_count", 1,
                  :queue => queue,
                  :status => job_status
              end
              increment_counter "queue_job_count", 1,
                :queue => queue,
                :status => :processed
            end
          end
        end
      end
    end
  end
end
