require "spec_helper"
require "snowpack/generator"

RSpec.describe Snowpack::Generator do
  subject(:generator) { described_class.new(templates_dir: templates_dir) }

  let(:templates_dir) { FIXTURES_PATH.join("generator") }
  let(:output_dir) { Pathname(Dir.mktmpdir) }

  after do
    FileUtils.remove_entry output_dir
  end

  it "generates files" do
    generator.(output_dir, application_module: "MyApp", application_path: "my_app")

    expect(File.read(output_dir.join("hello.rb"))).to eq File.read(templates_dir.join("hello.rb"))

    expect(File.read(output_dir.join("my_app/world.rb"))).to eq(<<~RB)
      module MyApp
        class World
        end
      end
    RB
  end
end
