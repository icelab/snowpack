require 'snowflakes/cli/global'

RSpec.describe 'sf console' do
  it 'starts a console in development env by default' do
    with_command(:console) do |output|
      expect(output).to include 'dummy[development] booted'
      expect(output).to include 'dummy[development]> '
    end
  end

  it 'starts a console in provided env' do
    with_command(:console, e: 'production') do |output|
      expect(output).to include 'dummy[production] booted'
      expect(output).to include 'dummy[production]> '
    end
  end
end
