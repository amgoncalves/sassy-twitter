web: rackup -s puma -p $PORT
web: rackup -s puma -p $PORT
# worker: bundle exec rake jobs:work
worker: bundle exec sidekiq -t 25 -r ./app.rb
worker: bundle exec sidekiq -t 25 -r ./app.rb
