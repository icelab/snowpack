# frozen_string_literal: true

require "erb"
require "hanami/utils/files"
require "pathname"
# require_relative "../ext/hanami/cli/file_helper"

module Snowflakes
  class Generator
    attr_reader :templates_dir
    attr_reader :templates
    attr_reader :files
    attr_reader :file_helper

    def initialize(templates_dir:)
      @templates_dir = templates_dir
      @templates = Dir[File.join(templates_dir, "**/{*,.*}")].select(&File.method(:file?)).map(&method(:Pathname))
      @files = Hanami::Utils::Files
      # @file_helper = Hanami::CLI::FileHelper.new(templates_dir: templates_dir)
    end

    def call(output_dir, **env)
      templates.each do |template|
        output_file_path = render_file_path(template.relative_path_from(templates_dir).to_s, env)

        if File.extname(template) == ".tt"
          result = render(template.to_s, env)

          files.write \
            File.join(output_dir, output_file_path.sub(%r{#{File.extname(template)}$}, "")),
            result
        else
          files.cp template, File.join(output_dir, output_file_path)
        end
      end
    end

    private

    def render(template, env)
      ERB.new(File.read(template), nil, _trim_mode = "-").result_with_hash(env)
    end

    FILE_PATH_VAR_DELIMITER = "__"
    FILE_PATH_VAR_REGEXP = /#{FILE_PATH_VAR_DELIMITER}\S+#{FILE_PATH_VAR_DELIMITER}/

    def render_file_path(path, env)
      path.gsub(FILE_PATH_VAR_REGEXP) { |match|
        var_name = match.gsub(FILE_PATH_VAR_DELIMITER, "")
        env.fetch(var_name.to_sym).to_s
      }
    end
  end
end
