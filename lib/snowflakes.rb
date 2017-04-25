require "snowflakes/version"
require "pathname"

module Snowflakes
  SF_EXE_PATH = Pathname(__FILE__).dirname.join('../exe/sf').freeze

  def self.cli_exec_file
    SF_EXE_PATH
  end
end
