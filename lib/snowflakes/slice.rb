require "pathname"
require_relative "../snowflakes"

module Snowflakes
  class Slice < Dry::System::Container
    use :env, inferrer: -> { ENV.fetch('RACK_ENV', 'development').to_sym }

    def self.inherited(klass)
      super

      if klass.superclass == Snowflakes::Slice
        raise "Snowflakes.application not configured yet" unless Snowflakes.application?

        app = Snowflakes.application

        klass.instance_variable_set :@application, app

        klass.register :inflector, app[:inflector]
        klass.register :logger, app[:logger]
        klass.register :rack_monitor, app[:rack_monitor] # do we need this?

        klass.config.env = app.env
        klass.config.name = klass.slice_name.to_sym
        klass.config.root = Pathname(File.join(Dir.pwd, "slices", klass.slice_name))
        klass.config.auto_register = [File.join("lib", klass.slice_namespace_path)]
        klass.config.default_namespace = klass.slice_namespace_path

        klass.import core: app

        klass.after :configure do
          klass.load_paths! "lib"
        end
      end
    end

    def self.import_slice(*slices)
      @slice_imports ||= []
      @slice_imports += slices
      @slice_imports.uniq!
      self
    end

    def self.application
      @application
    end

    def self.boot!
      finalize!
    end

    def self.finalize!
      super do
        Array(@slice_imports).each do |slice|
          import slice => application.slices.fetch(slice)
        end
      end
    end

    def self.inflector
      self[:inflector]
    end

    private

    MODULE_DELIMITER = "::"

    def self.slice_namespace
      inflector.constantize(name.split(MODULE_DELIMITER)[0..-2].join(MODULE_DELIMITER))
    end

    def self.slice_namespace_path
      inflector.underscore(slice_namespace.to_s)
    end

    def self.slice_name
      inflector.underscore(slice_namespace.to_s.split(MODULE_DELIMITER).last)
    end
  end
end
