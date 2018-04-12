require './app'

configure do
  uri = URI.parse(ENV["REDISCLOUD_URL"])
  $redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)

end

$stdout.sync = true

run Sinatra::Application
