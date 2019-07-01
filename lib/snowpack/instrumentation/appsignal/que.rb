# frozen_string_literal: true

require "appsignal"
require_relative "appsignal_ext"
require "securerandom"

# Remove Appsignal's own Que integration hook, so the Snowpack-hosted
# integration can be included manually.
Appsignal::Hooks.hooks.delete :que

module Snowpack
  module Instrumentation
    module Appsignal
      module Que
        # Enable like so:
        #
        # Que.error_notifier = Snowpack::Instrumentation::Appsignal::Que::ErrorNotifier

        # Actually, why is this even necessry?
        ErrorNotifier = -> error, _job {
          ::Appsignal::Transaction.current.set_error(error)
        }

        def self.included(base)
          base.class_eval do
            def _run_with_appsignal(*args)
              env = {
                :metadata    => {
                  :id        => attrs[:job_id],
                  :queue     => attrs[:queue],
                  :run_at    => attrs[:run_at].to_s,
                  :priority  => attrs[:priority],
                  :attempts  => attrs[:error_count].to_i
                },
                :params => attrs[:args]
              }

              request = ::Appsignal::Transaction::GenericRequest.new(env)

              transaction = ::Appsignal::Transaction.create(
                SecureRandom.uuid,
                ::Appsignal::Transaction::BACKGROUND_JOB,
                request,
              )

              transaction.discard! unless instrument?

              begin
                ::Appsignal.instrument("perform_job.que") { _run_without_appsignal(*args) }
              rescue Exception => error
                transaction.set_error(error)
                raise error
              ensure
                transaction.set_action "#{attrs[:job_class]}#run"
                ::Appsignal::Transaction.complete_current!
              end
            end

            alias_method :_run_without_appsignal, :_run
            alias_method :_run, :_run_with_appsignal

            def instrument?
              true
            end
          end
        end
      end
    end
  end
end
