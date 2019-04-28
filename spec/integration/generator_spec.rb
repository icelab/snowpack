require "spec_helper"
require "snowflakes/generator"

RSpec.describe Snowflakes::Generator do
  subject(:generator) { described_class.new(templates_dir: templates_dir) }

  let(:templates_dir) { FIXTURES_PATH.join("generator") }
  let(:output_dir) { Pathname(Dir.mktmpdir) }

  after do
    FileUtils.remove_entry output_dir
  end

  it "generates files" do
    generator.(output_dir, application_name: "MyApp")

    expect(File.read(output_dir.join("hello.rb"))).to eq File.read(templates_dir.join("hello.rb"))

    expect(File.read(output_dir.join("world.rb"))).to eq(<<~RB)
      module MyApp
        class World
        end
      end
    RB
  end
end
