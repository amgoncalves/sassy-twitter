# require 'byebug'
require 'json'
require 'mongoid'
require 'mongo'
require 'sinatra'
require 'sinatra/cookies'
require 'sinatra/json'
require 'sinatra/flash'
require 'sinatra/multi_route'
require 'redis'
require 'sidekiq'
require 'sidekiq/api'
require 'rack-timeout'
# require 'sinatra/cache'
#require 'sinatra/sessionshelper'
require_relative './models/user'
require_relative './models/userd'
require_relative './models/tweet'
require_relative './models/tweetd'
require_relative './models/reply'
require_relative './models/hashtag'
require_relative './config/initializers/redis.rb'
require_relative './config/vars/global_var.rb'
require_relative './controllers/session.rb'
require_relative './controllers/login.rb'
require_relative './controllers/logout.rb'
require_relative './controllers/signup.rb'
require_relative './controllers/edit_profile.rb'
require_relative './controllers/user.rb'
require_relative './controllers/follow.rb'
require_relative './controllers/retweet.rb'
require_relative './controllers/like.rb'
require_relative './controllers/reply.rb'
require_relative './controllers/tweet.rb'
require_relative './controllers/timeline.rb'
require_relative './controllers/followings.rb'
require_relative './controllers/followeds.rb'
require_relative './controllers/search.rb'
require_relative './spec/test_interface.rb'
require_relative './spec/create_tweet_loadtest.rb'
require_relative './spec/demo_mongodb.rb'
require_relative './spec/follow_loadtest.rb'
require_relative './spec/demo_redis.rb'
require_relative './spec/reply_loadtest.rb'
require_relative './spec/load_test_search.rb'
require_relative './helper/user_related.rb'
require_relative './api/api_user.rb'
require_relative './api/api_tweet.rb'
require_relative './api/api_search.rb'

use Rack::Timeout, service_timeout: 5, wait_timeout: false
enable :sessions

if ENV['MONGOID_ENV'] == 'production'
  Mongoid.load!("config/mongoid.yml", :production)
else
  Mongoid::Config.connect_to('nanotwitter-dev') 
end

configure :production do
	require 'newrelic_rpm'
end

configure do
	$redis = Redis.new(:url => ENV["REDIS_URL"], :timeout => 1)
end

# Sets level for Mongo messages.  Set to DEBUG to see all messages.
Mongo::Logger.logger.level = Logger::FATAL

# sets root as the parent-directory of the current file
set :root, File.join(File.dirname(__FILE__), '')
# sets the view directory correctly
set :views, Proc.new { File.join(root, "views") }

set :public_folder, Proc.new { File.join(root, "public") }

get "/" do
  if is_authenticated?
    if session[:user_id] == nil
      session.clear
      cookies.clear
      redirect "/"
    end

    @tweets = $redis.lrange($globalTL,0, 50).reverse

    # if session contains user information extract user from redis
    # otherwise from mongodb
    if session[:user_id] != nil 
      @cur_user = get_user_from_redis
    else
      @cur_user = get_user_from_mongo
    end

    @targeted_user = @cur_user
    @targeted_id = @targeted_user._id

    @info = Hash.new
    @info[:login_user] = @cur_user
    @info[:target_user] = @targeted_user
    @info[:target_tweets] = @tweets
  else
    @tweets = $redis.lrange($globalTL, 0, 50).reverse
  end
  erb :index, :locals => { :title => 'Welcome!' }
end

get '/reset/redis' do
  $redis.flushall
end

get '/reset/all' do  
  # delete everything in mongo db
  Mongoid.purge!
  # delete everything in redis
  $redis.flushall
  # clean session and cookie
  Sidekiq::Queue.new.clear
  session.clear
  cookies.clear
end
