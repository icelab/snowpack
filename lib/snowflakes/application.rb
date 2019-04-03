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

    # From dry-web
    setting :logger_class, Dry::Monitor::Logger
    setting :listeners, false

    use :env, inferrer: -> { ENV.fetch('RACK_ENV', 'development').to_sym }
    use :logging
    use :notifications
    use :monitoring

    @_mutex = Mutex.new

    def self.inherited(klass)
      super

      # From dry-web
      klass.after(:configure) do
        register_rack_monitor
      end

      @_mutex.synchronize do
        Snowflakes.application = klass
      end
    end

    def self.slices
      @slices ||= detect_slices
    end

    # ....
    def self.load_slices
      slices
    end

    def self.on_boot(&block)
      @_boot_block = block
    end

    def self.boot!
      @slices = detect_slices

      finalize!

      @_boot_block.() if @_boot_block
    end

    private

    def self.detect_slices
      Dir["#{config.root}/{apps,backend,slices}/*"].map(&method(:load_slice))
    end

    def self.load_slice(base_path)
      base_path = Pathname(base_path)
      full_defn_path = Dir["#{base_path}/system/**/container.rb"].first # TODO rename to "slice.rb"

      require full_defn_path

      const_path = Pathname(full_defn_path)
        .relative_path_from(base_path.join("system")).to_s
        .yield_self { |path| path.sub(/#{File.extname(path)}$/, "") }

      inflector.constantize(inflector.camelize(const_path))
    end

    # From dry-web

    def self.register_rack_monitor
      return self if key?(:rack_monitor)
      register(:rack_monitor, Dry::Monitor::Rack::Middleware.new(self[:notifications]))
      self
    end
  end
end
