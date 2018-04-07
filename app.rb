require 'byebug'
require 'mongoid'
require 'mongo'
require 'sinatra'
require 'sinatra/cookies'
require 'sinatra/flash'
require 'redis'
#require 'sinatra/sessionshelper'
require_relative './models/user'
require_relative './models/tweet'
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
require_relative './controllers/helpers.rb'
require_relative './controllers/search.rb'
require_relative './controllers/profile.rb'
require_relative './spec/test_interface.rb'
require_relative './spec/create_tweet_loadtest.rb'
require_relative './spec/follow_loadtest.rb'

enable :sessions

if ENV['MONGOID_ENV'] == 'production'
  Mongoid.load!("config/mongoid.yml", :production)
else
  Mongoid::Config.connect_to('nanotwitter-dev') 
  $redis = Redis.new(url: ENV["REDIS_URL"]) 
end

configure :production do
  require 'newrelic_rpm'
end

# sets root as the parent-directory of the current file
set :root, File.join(File.dirname(__FILE__), '')
# sets the view directory correctly
set :views, Proc.new { File.join(root, "views") }

set :public_folder, Proc.new { File.join(root, "public") }

get '/' do
  if is_authenticated?
    if session[:user_id] == nil
      session.clear
      cookies.clear
      redirect '/'
    end

    @tweets = $redis.lrange($globalTL,0, -1).reverse
    # @cur_user = get_user_from_redis
		@cur_user = get_user_from_mongo
    @targeted_user = @cur_user
    @targeted_id = @targeted_user._id
  else 
    @tweets = $redis.lrange($globalTL, 0, -1).reverse
  end
  # code added by Shuai at Mar 23
  @info = Hash.new
  @info[:login_user] = @cur_user
  @info[:target_user] = @targeted_user
  @info[:target_tweets] = @tweets
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
  session.clear
  cookies.clear
end
