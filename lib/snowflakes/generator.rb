# frozen_string_literal: true

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

      # TODO: renderer
    end

    def call(output_dir, **env)
      templates.each do |template|
        files.cp template, File.join(output_dir, template.relative_path_from(templates_dir))
      end
    end
  end
end
