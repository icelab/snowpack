# frozen_string_literal: true

# use Snowflakes::Instrumentation::Rack::Appsignal, {
#   rate: 0.2,
#   filters: {
#     "/some/exact/route"   => 0.05,    # <- custom sample rate (5%) for specific URL
#     %r{/another/.+/route} => false,   # <- do not instrument this URL, n.b. match via Regexp
#   },
# }

require "appsignal"
require "rack"
require "securerandom"

module Snowflakes
  module Instrumentation
    module Appsignal
      class Rack
        attr_reader :app, :options

        def initialize(app, **options)
          @app = app
          @options = options
        end

        def call(env)
          if ::Appsignal.active?
            call_with_appsignal_monitoring(env)
          else
            app.call(env)
          end
        end

        private

        def call_with_appsignal_monitoring(env)
          request = ::Rack::Request.new(env)

          should_instrument = instrument?(request)

          transaction = ::Appsignal::Transaction.create(
            SecureRandom.uuid,
            ::Appsignal::Transaction::HTTP_REQUEST,
            request,
          )

          begin
            ::Appsignal.instrument "process_action.generic" do
              app.call(env)
            end
          rescue Exception => error
            transaction.set_error(error)
            should_instrument = true
            raise error
          ensure
            if env["appsignal.route"]
              transaction.set_action_if_nil(env["appsignal.route"])
            else
              transaction.set_action_if_nil("unknown")
            end

            transaction.set_metadata("path", request.path)
            transaction.set_metadata("method", request.request_method)

            if should_instrument
              transaction.set_http_or_background_queue_start
              ::Appsignal::Transaction.complete_current!
            else
              ::Appsignal::Transaction.clear_current_transaction!
            end
          end
        end

        def instrument?(request)
          rate = options.fetch(:rate, 1)

          options.fetch(:filters, {}).each do |filter_match, filter_rate|
            rate = filter_rate and break if request.path.match?(filter_match)
          end

          rate && rand <= rate
        end
      end
    end
  end
end
