require 'snowflakes/cli/global'

RSpec.describe 'sf console' do
  before do
    `createdb dummy_test > /dev/null`
  end

  after do
    `dropdb dummy_test > /dev/null`
  end

  it 'starts a console in development env by default' do
    with_command(:console) do |output|
      expect(output).to include 'dummy[development] booted'
      expect(output).to include 'dummy[development]>'
    end
  end

  it 'starts a console in provided env' do
    with_command(:console, e: 'production') do |output|
      expect(output).to include 'dummy[production] booted'
      expect(output).to include 'dummy[production]>'
    end
  end

  it 'starts a console in provided env via RACK_ENV' do
    ENV['RACK_ENV'] = 'test'

    with_command(:console) do |output|
      expect(output).to include 'dummy[test] booted'
      expect(output).to include 'dummy[test]>'
    end

    ENV.delete('RACK_ENV')
  end

  it 'starts a console for a specific sub-app' do
    with_command(:console, a: 'web') do |output|
      expect(output).to include 'web[development] booted'
      expect(output).to include 'web[development]>'
    end
  end

  it 'starts a console for a specific sub-system' do
    with_command(:console, s: 'mail') do |output|
      expect(output).to include 'mail[development] booted'
      expect(output).to include 'mail[development]>'
    end
  end
end
