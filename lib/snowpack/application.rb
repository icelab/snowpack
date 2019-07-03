# frozen_string_literal: true

require "dry/inflector"
require "dry/monitor" # from dry-web
require "dry/system/container"
require "dry/system/components"
require "pathname"
require_relative "../snowpack"

Dry::Monitor.load_extensions :rack # from dry-web

module Snowpack
  class Application < Dry::System::Container
    setting :inflector, Dry::Inflector.new, reader: true
    setting :slices_dir, "slices"

    use :env, inferrer: -> { ENV.fetch("RACK_ENV", "development").to_sym }
    use :logging
    use :notifications
    use :monitoring

    @_mutex = Mutex.new

    def self.inherited(klass)
      super

      klass.after :configure do
        register_inflector
        load_paths! "lib"
      end

      @_mutex.synchronize do
        Snowpack.application = klass
      end
    end

    def self.slices
      @slices ||= load_slices
    end

    def self.load_slices
      @slices ||= slice_paths
        .map(&method(:load_slice))
        .compact
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

    MODULE_DELIMITER = "::"

    def self.module
      inflector.constantize(name.split(MODULE_DELIMITER)[0..-2].join(MODULE_DELIMITER))
    end

    private

    def self.slice_paths
      Dir[File.join(config.root, config.slices_dir, "*")]
    end

    def self.load_slice(base_path)
      base_path = Pathname(base_path)
      full_defn_path = Dir["#{base_path}/system/**/slice.rb"].first

      return unless full_defn_path

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
  end
end
