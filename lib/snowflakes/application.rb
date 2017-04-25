require 'snowflakes/console/context'

module Snowflakes
  class Application
    attr_reader :config, :root, :name, :env, :container, :subapps

    def initialize(config, env = nil)
      @config = config
      @root = config.root
      @name = config.name || config.root.split.last.to_s
      @env = env || config.env
    end

    def context
      Console::Context.new(container, subapps)
    end

    def boot(component = nil)
      if component
        boot_component(component)
      else
        require "#{config.system_path % { root: root, name: name }}/boot"
        load_sub_apps
      end
    end

    def boot_component(name)
      container.boot(name)
    end

    def has_db_seed?
      File.exist?(db_seed_file)
    end

    def load_db_seed
      load("#{root}/db/seed.rb")
    end

    def precompiled_assets_path
      "#{root}/public/assets"
    end

    def route_files
      Dir["#{root}/apps/**/web/routes/**/*.rb"].join(" ")
    end

    def routes_json_file
      "#{root}/config/routes.json"
    end

    def container
      @container ||=
        begin
          require_container
          constantize(name).const_get(:Container)
        end
    end

    private

    def db_seed_file
      "#{root}/db/seed.rb"
    end

    def load_sub_apps
      @subapps ||= Dir["#{root}/apps/*"].map do |path|
        constantize(Pathname(path).basename.to_s)
      end
    end

    def constantize(name)
      Inflecto.constantize(Inflecto.camelize(name))
    end

    def require_container
      require "#{config.system_path}/%{name}/container" % { root: root, name: name }
    end
  end
end
