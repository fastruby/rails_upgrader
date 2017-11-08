require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

task default: :spec

task :build do
  sh "gem build oca-epak.gemspec"
end

task release: :build do
  sh "git push origin master"
  sh "gem push rails_upgrader-#{RailsUpgrader::VERSION}.gem"
end
