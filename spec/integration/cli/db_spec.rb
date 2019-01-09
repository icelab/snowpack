RSpec.describe 'exe/run db' do
  describe 'create' do
    after do
      `dropdb dummy_test > /dev/null`
    end

    it 'creates the database' do
      with_command('db create') do |output|
        expect(output).to include 'database dummy_test created'
      end
    end
  end

  describe 'drop' do
    before do
      `createdb dummy_test > /dev/null`
    end

    it 'drops the database' do
      with_command('db drop') do |output|
        expect(output).to include 'database dummy_test dropped'
      end
    end
  end

  describe 'structure dump' do
    before do
      `createdb dummy_test > /dev/null`
    end

    after do
      `dropdb dummy_test > /dev/null`
    end

    it 'dumps the database to {root}/db/structure.sql' do
      with_command('db structure dump') do |output|
        expect(output).to include 'dummy_test structure dumped to'
        expect(output).to include 'db/structure.sql'
      end
    end
  end

  describe 'create_migration' do
    before do
      `createdb dummy_test > /dev/null`
      FileUtils.rm(Dir["#{SPEC_ROOT}/dummy/db/migrate/*.rb"])
    end

    after do
      `dropdb dummy_test > /dev/null`
    end

    it 'creates a new migration' do
      with_command('db create_migration -n add_users') do |output|
        expect(output).to match %r{migration add_users_(\d+) created}
      end
    end
  end

  describe 'migrate' do
    before do
      `createdb dummy_test > /dev/null`

      FileUtils.cp(
        "#{SPEC_ROOT}/fixtures/migrations/20170425120106_add_users.rb",
        "#{SPEC_ROOT}/dummy/db/migrate/",
      )
    end

    after do
      `dropdb dummy_test > /dev/null`
    end

    it 'migrates db and dumps structure in development' do
      with_command('db reset') do |output|
        expect(output).to include 'migrations executed'
        expect(output).to include 'dummy_test structure dumped to'
      end
    end

    it 'migrates db and does not dump structure in non-development' do
      with_command('db migrate -e test') do |output|
        expect(output).to include 'migrations executed'
        expect(output).to_not include 'dummy_test structure dumped to'
      end

      with_command('db migrate -e test', env: {"RACK_ENV" => "test"}) do |output|
        expect(output).to include 'migrations executed'
        expect(output).to_not include 'dummy_test structure dumped to'
      end
    end
  end

  describe 'reset' do
    before do
      `createdb dummy_test > /dev/null`

      FileUtils.cp(
        "#{SPEC_ROOT}/fixtures/migrations/20170425120106_add_users.rb",
        "#{SPEC_ROOT}/dummy/db/migrate/",
      )
    end

    after do
      `dropdb dummy_test > /dev/null`
    end

    it 'drops, creates and migrates the database' do
      with_command('db reset') do |output|
        expect(output).to include 'database dummy_test dropped'
        expect(output).to include 'database dummy_test created'
        expect(output).to include 'migrations executed'
        expect(output).to include 'dummy_test structure dumped to'
      end
    end
  end

  describe 'sample_data' do
    before(:each) do
      `createdb dummy_test > /dev/null`
    end

    after(:each) do
      `dropdb dummy_test > /dev/null`
    end

    context 'when there is sample data' do
      before do
        FileUtils.touch("#{SPEC_ROOT}/dummy/db/sample_data.rb")
      end

      it 'loads sample data from {root}/db/sample_data.rb' do
        with_command('db sample_data') do |output|
          expect(output).to include 'db sample data loaded'
        end
      end
    end

    context 'when there is no sample data' do
      it 'does not load sample data' do
        with_command('db sample_data') do |output|
          expect(output).to include 'app has no db sample data'
        end
      end
    end
  end
end
