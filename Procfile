web: rackup -s puma -p $PORT
worker: bundle exec sidekiq -t 25 -r ./app.rb
