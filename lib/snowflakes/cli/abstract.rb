require 'thor'
require 'pathname'
require 'inflecto'
require 'snowflakes/application'
require 'snowflakes/config'

module Snowflakes
  module CLI
    class Abstract < Thor
      def self.with_env(*args, &block)
        desc(*args)
        method_option :env, aliases: ['-e'], desc: 'Application environment'
        block.call
      end

      private

      def run(name, *args)
        require "snowflakes/commands/#{name}"
        ENV['RACK_ENV'] = options['env'] if options.key?('env')
        Commands.const_get(Inflecto.camelize(name)).run(application, *args)
      end

      def application
        Application.new(config, options['env'])
      end

      def config
        Snowflakes.config
      end
    end
  end
end
