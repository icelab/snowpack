# frozen_string_literal: true

require "appsignal"
require "securerandom"

# Remove Appsignal's own Que integration hook, so the Snowflakes-hosted
# integration can be included manually.
Appsignal::Hooks.hooks.delete :que

module Snowflakes
  module Instrumentation
    module Appsignal
      module Que
        ErrorNotifier = -> error, _job {
          ::Appsignal::Transaction.current.set_error(error)
        }

        def self.included(base)
          base.class_eval do
            def _run_with_appsignal
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

              should_instrument = instrument?

              request = ::Appsignal::Transaction::GenericRequest.new(env)

              transaction = ::Appsignal::Transaction.create(
                SecureRandom.uuid,
                Appsignal::Transaction::BACKGROUND_JOB,
                request,
              )

              begin
                ::Appsignal.instrument("perform_job.que") { _run_without_appsignal }
              rescue Exception => error
                transaction.set_error(error)
                should_instrument = true
                raise error
              ensure
                if should_instrument
                  transaction.set_action "#{attrs[:job_class]}#run"
                  ::Appsignal::Transaction.complete_current!
                else
                  ::Appsignal::Transaction.clear_current_transaction!
                end
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
