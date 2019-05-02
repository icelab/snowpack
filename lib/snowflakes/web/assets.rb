require "yaml"
require "down"

module Snowflakes
  module Web
    class Assets
      attr_reader :root
      attr_reader :precompiled
      attr_reader :server_url

      def initialize(root:, precompiled:, server_url: nil)
        @root = root
        @precompiled = precompiled
        @server_url = server_url
      end

      def [](asset)
        if precompiled
          asset_path_from_manifest(asset)
        else
          asset_path_on_server(asset)
        end
      end

      def read(asset)
        path = self[asset]

        if File.exist?("#{root}/public#{path}")
          File.read("#{root}/public#{path}")
        else
          Down.open(path).read
        end
      end

      private

      def asset_path_from_manifest(asset)
        if (hashed_asset = manifest[asset])
          "/assets/#{hashed_asset}"
        end
      end

      def asset_path_on_server(asset)
        "#{server_url}/assets/#{asset}"
      end

      def manifest
        @manifest ||= YAML.load_file(manifest_path)
      end

      def manifest_path
        "#{root}/public/assets/asset-manifest.json"
      end
    end
  end
end
