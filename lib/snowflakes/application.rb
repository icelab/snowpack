require 'snowflakes/console/context'

module Snowflakes
  class Application
    attr_reader :config, :root, :name, :env, :container, :subapps, :system_path

    def initialize(config)
      @config = config
      @env = config.env
      @root = config.root
      @name = config.system
      @system_path = "#{root}/#{config.system_dir}"
      @env = env || config.env
    end

    def context
      Console::Context.new(container, subapps)
    end

    def boot(component = nil)
      if component
        boot_component(component)
      else
        boot_file_path = Dir["#{system_path}/**/*.rb"].detect { |f| f.include?('boot.rb') }

        if boot_file_path
          require boot_file_path
          load_sub_apps
        else
          raise "Couldn't find boot.rb for #{name} system"
        end
      end
    end

    def boot_component(name)
      container.init(name)
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

    def sub_system?
      config.sub_system
    end

    def db_seed_file
      "#{root}/db/seed.rb"
    end

    def load_sub_apps
      @subapps ||=
        begin
          if sub_system?
            []
          else
            sub_app_names.map do |path|
              constantize(Pathname(path).basename.to_s)
            end
          end
        end
    end

    def sub_app_names
      Dir["#{root}/apps/*"].map { |path| Pathname(path).basename }
    end

    def constantize(name)
      Inflecto.constantize(Inflecto.camelize(name))
    end

    def require_sub_app_containers
      sub_app_names.each do |name|
        require_container(root.join("apps/#{name}/system").realpath)
      end
    end

    def require_container(path = system_path)
      path = Dir["#{path}/**/*.rb"].detect { |f| f.include?('container.rb') }

      if path
        require path.gsub('.rb', '')
      else
        raise "Failed to find container.rb in #{root}/#{system_path}"
      end
    end
  end
end
