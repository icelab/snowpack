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
        method_option :system, aliases: ['-s'], desc: 'Name of the sub-system to load'
        method_option :app, aliases: ['-a'], desc: 'Name of the sub-app to load'
        block.call
      end

      private

      def run(name, *args)
        require "snowflakes/commands/#{name}"
        ENV['RACK_ENV'] ||= options['env'] if options.key?('env')
        Commands.const_get(Inflecto.camelize(name)).run(application, *args)
      end

      def application
        Application.new(config)
      end

      def config
        Snowflakes.configure(options.merge(env: env))
      end

      def development?
        options.key?('env') ? env == 'development' : true
      end

      def env
        options.fetch('env', ENV['RACK_ENV'] || 'development')
      end
    end
  end
end
