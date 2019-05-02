require "bundler/setup"

begin
  require "rspec/core/rake_task"
  RSpec::Core::RakeTask.new :spec
  task default: [:spec]
rescue LoadError
end

Rake.add_rakelib "tasks"
