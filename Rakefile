require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

desc "Open an irb session preloaded with this library"
task :console do
  sh "irb -rubygems -I lib -I"
end
