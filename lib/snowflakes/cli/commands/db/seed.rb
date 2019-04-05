# frozen_string_literal: true

require "hanami/cli"
require "snowflakes/cli/command"
require_relative "structure/dump"

module Snowflakes
  class CLI < Hanami::CLI
    module Commands
      module DB
        class Seed < Command
          desc "Load database seeds"

          def call(**)
            if has_file?
              measure "Database seeds loaded" do
                application.boot
                load file_path
              end
            else
              out.puts "=> no database seeds available"
            end
          end

          private

          def file_path
            File.join(application.root, "db/seed.rb")
          end

          def has_file?
            File.exist?(seeds_path)
          end
        end
      end
    end

    register "db seed", Commands::DB::Seed
  end
end
