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

enable :sessions

if ENV['MONGOID_ENV'] == 'production'
  Mongoid.load!("config/mongoid.yml", :production)
else
  Mongoid::Config.connect_to('nanotwitter-test') 
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
  @ids = User.pluck(:id)
  if is_authenticated?
    @tweets = Tweet.all.reverse # the cost of reverse
    @users = User.all # TODO: delete in future
    @cur_user = User.where(_id: session[:user]._id).first
    @targeted_user = session[:user]
    @targeted_id = @targeted_user._id
    @ntweets = @targeted_user[:tweets].length
    if @ntweets > 0
      @targeted_tweets = Tweet.in(_id: @targeted_user[:tweets])
      @targeted_tweets = @targeted_tweets.reverse
    end

    @nfollowed = @targeted_user[:followeds].length
    if @nfollowed > 0
      @targeted_followed = User.in(_id: @targeted_user[:followeds])
    end

    @nfollowing = @targeted_user[:followings].length
    if @nfollowing > 0
      @targeted_following = User.in(_id: @targeted_user[:followings])
    end
  else 
    @tweets = $redis.lrange($globalTL, 0, -1)

  end
	# code added by Shuai at Mar 23
	@info = Hash.new
	@info[:login_user] = @cur_user
	@info[:target_user] = @targeted_user
	@info[:target_tweets] = @targeted_tweets

  erb :index, :locals => { :title => 'Welcome!' }
end
