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
      @templates = Dir[File.join(templates_dir, "**/*")].map(&method(:Pathname))
      @files = Hanami::Utils::Files
      # @file_helper = Hanami::CLI::FileHelper.new(templates_dir: templates_dir)
    end

    def call(output_dir, **env)
      templates.each do |template|
        if File.extname(template) == ".tt"
          result = render(template.to_s, env)

          files.write \
            File.join(output_dir, template.relative_path_from(templates_dir).sub(%r{#{File.extname(template)}$}, "")),
            result
        else
          files.cp template, File.join(output_dir, template.relative_path_from(templates_dir))
        end
      end
    end

    def render(template, env)
      ERB.new(File.read(template), nil, _trim_mode = "-").result_with_hash(env)
    end
  end
end
