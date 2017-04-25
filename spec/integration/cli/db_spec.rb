RSpec.describe 'exe/run db' do
  describe 'create' do
    before do
      `dropdb dummy_test &> /dev/null`
    end

    it 'creates the database' do
      with_command('db create') do |output|
        expect(output).to include 'database dummy_test created'
      end
    end
  end

  describe 'drop' do
    before do
      `createdb dummy_test &> /dev/null`
    end

    it 'drops the database' do
      with_command('db drop') do |output|
        expect(output).to include 'database dummy_test dropped'
      end
    end
  end

  describe 'create_migration' do
    before do
      `createdb dummy_test &> /dev/null`
      FileUtils.rm(Dir["#{SPEC_ROOT}/dummy/db/migrate/*.rb"])
    end

    it 'creates a new migration' do
      with_command('db create_migration -n add_users') do |output|
        expect(output).to match /migration add_users_(\d+) created/
      end
    end
  end

  describe 'reset' do
    before do
      `createdb dummy_test &> /dev/null`
      FileUtils.cp("#{SPEC_ROOT}/fixtures/migrations/20170425120106_add_users.rb", "#{SPEC_ROOT}/dummy/db/migrate")
    end

    it 'drops, creates and migrates the database' do
      with_command('db reset') do |output|
        expect(output).to include 'database dummy_test dropped'
        expect(output).to include 'database dummy_test created'
        expect(output).to include 'migrations executed'
      end
    end
  end
end
