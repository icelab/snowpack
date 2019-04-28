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
    generator.(output_dir)

    expect(File.read(output_dir.join("hello.rb"))).to eq File.read(templates_dir.join("hello.rb"))
  end
end
