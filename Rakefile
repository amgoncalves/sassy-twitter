require 'rake/testtask'
require 'date'

Rake::TestTask.new do |t|
  t.pattern = 'spec/*_spec.rb'
end

namespace :jobs do
  desc "Some work in job"
  task :work do
    while true
      puts "Hello, world! #{DateTime.now}"
      sleep 5
    end
  end
end
