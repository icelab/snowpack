begin
  require "rspec/core/rake_task"
  require "snowflakes/test/suite"

  require Snowflakes::Test::Suite.root.join("support/suite")
  suite = Snowflakes::Test::Suite.current.new

  desc "Run all specs"
  RSpec::Core::RakeTask.new :spec do |t|
    opts = []

    if suite.ci?
      opts << "--format RspecJunitFormatter"
      opts << "--out /tmp/test-results/rspec.xml"
      opts << "--format progress"
    end

    opts << "--pattern #{suite.file_group.join(' ')}"

    t.rspec_opts = opts.join(" ")
  end

  namespace :spec do
    suite.groups.each do |group|
      desc "Run #{group} specs"
      RSpec::Core::RakeTask.new(group) do |t|
        t.rspec_opts = "--pattern #{suite.chdir(group).files.join(' ')}"
      end
    end

    desc 'Verify coverage'
    task :verify_coverage do
      if suite.current_coverage.to_i < suite.coverage_threshold
        puts "Coverage too low. Current: #{suite.current_coverage}%; Expected min: #{suite.coverage_threshold}%"
        exit 1
      end
    end
  end

  task default: [:spec]
rescue LoadError; end
