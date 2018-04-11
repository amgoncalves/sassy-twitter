require 'rake/testtask'
require 'date'

Rake::TestTask.new do |t|
  t.pattern = 'spec/*_spec.rb'
end

namespace :jobs do
  desc "Some work in job"
  task :work do
    puts "Hello, world! #{DateTime.now}"
  end
end
