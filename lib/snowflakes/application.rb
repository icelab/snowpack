# frozen_string_literal: true

require "dry/inflector"
require "dry/monitor" # from dry-web
require "dry/system/container"
require "dry/system/components"
require "pathname"
require_relative "../snowflakes"

Dry::Monitor.load_extensions :rack # from dry-web

module Snowflakes
  class Application < Dry::System::Container
    setting :inflector, Dry::Inflector.new, reader: true
    setting :slices_dir, "slices"

    # From dry-web
    setting :logger_class, Dry::Monitor::Logger

    use :env, inferrer: -> { ENV.fetch('RACK_ENV', 'development').to_sym }
    use :logging
    use :notifications
    use :monitoring

    @_mutex = Mutex.new

    def self.inherited(klass)
      super

      # From dry-web
      klass.after(:configure) do
        register_inflector
        register_rack_monitor
      end

      klass.load_paths! "lib"

      @_mutex.synchronize do
        Snowflakes.application = klass
      end
    end

    def self.slices
      @slices ||= load_slices
    end

    def self.load_slices
      @slices ||= Dir[File.join(config.root, config.slices_dir, "*")]
        .map(&method(:load_slice))
        .to_h
    end

    # We can't call this `.boot` because it is the name used for registering
    # bootable components. (It would be good to change that)
    def self.boot!
      return self if booted?

      finalize! freeze: false

      load_slices
      slices.values.each(&:boot!)

      @booted = true

      freeze
      self
    end

    def self.booted?
      @booted.equal?(true)
    end

    private

    def self.load_slice(base_path)
      base_path = Pathname(base_path)
      full_defn_path = Dir["#{base_path}/system/**/slice.rb"].first

      require full_defn_path

      const_path = Pathname(full_defn_path)
        .relative_path_from(base_path.join("system")).to_s
        .yield_self { |path| path.sub(/#{File.extname(path)}$/, "") }

      const = inflector.constantize(inflector.camelize(const_path))

      [File.basename(base_path).to_sym, const]
    end

    def self.register_inflector
      return self if key?(:inflector)
      register :inflector, inflector
    end

    def self.register_rack_monitor
      return self if key?(:rack_monitor)
      register(:rack_monitor, Dry::Monitor::Rack::Middleware.new(self[:notifications]))
      self
    end
  end
end
