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

enable :sessions

if ENV['MONGOID_ENV'] == 'production'
  Mongoid.load!("config/mongoid.yml", :production)
else
  Mongoid::Config.connect_to('nanotwitter-test') 
  $redis = Redis.new(url: ENV["REDIS_URL"]) 
end

# sets root as the parent-directory of the current file
set :root, File.join(File.dirname(__FILE__), '')
# sets the view directory correctly
set :views, Proc.new { File.join(root, "views") }

set :public_folder, Proc.new { File.join(root, "public") }

def redirect_to_original_request
  user = session[:user]
  flash[:notice] = 'Welcome back, #{user.handle}!'
  original_request = session[:original_request]
  session[:original_request] = nil
  redirect original_request
end

def is_authenticated?
  if session[:user] != nil
    @cur_user = User.where(_id: session[:user]._id).first
  elsif cookies[:user] != nil
    @cur_user = User.where(_id: cookies[:user]).first
    session[:user] = @cur_user
    return true
  end
  return !!session[:user]
end

def auth_user(email, password)
  user = User.where(email: email).first
  return user if user && user.password == password
  return nil
end

def add_cookie(user)
  cookies[:user] = user._id
end

def authenticate!
  unless session[:user]
    session[:original_request] = request.path_info
    redirect '/login'
  end
end

def get_handle(id)
  usr = User.where(_id: id).first
  user.handle
end

get '/' do
  @ids = User.pluck(:id)
  if is_authenticated?
    @tweets = Tweet.all.reverse
    @users = User.all
    @cur_user = User.where(_id: session[:user]._id).first
    @targeted_user = session[:user]
    @targeted_id = @targeted_user._id
    @ntweets = @targeted_user[:tweets].length
    if @ntweets > 0
      @targeted_tweets = Tweet.in(_id: @targeted_user[:tweets])
      @targeted_tweets = @targeted_tweets.reverse
    end

    @nfollowed = @targeted_user[:followed].length
    if @nfollowed > 0
      @targeted_followed = User.in(_id: @targeted_user[:followed])
    end

    @nfollowing = @targeted_user[:following].length
    if @nfollowing > 0
      @targeted_following = User.in(_id: @targeted_user[:following])
    end
    
  end
  erb :index, :locals => { :title => 'Welcome!' }
end

get '/timeline' do
  @ids = User.pluck(:id)
  if is_authenticated?
    @tweets = $redis.lrange(session[:user]._id.to_s, 0, 50)
    @users = User.all
    @cur_user = User.where(_id: session[:user]._id).first
    @targeted_user = session[:user]
    @targeted_id = @targeted_user._id
    @ntweets = @targeted_user[:tweets].length
    if @ntweets > 0
      @targeted_tweets = Tweet.in(_id: @targeted_user[:tweets])
      @targeted_tweets = @targeted_tweets.reverse
    end

    @nfollowed = @targeted_user[:followed].length
    if @nfollowed > 0
      @targeted_followed = User.in(_id: @targeted_user[:followed])
    end

    @nfollowing = @targeted_user[:following].length
    if @nfollowing > 0
      @targeted_following = User.in(_id: @targeted_user[:following])
    end
    
  end
  erb :hometimeline, :locals => { :title => 'Home Timeline!' }
end

get '/login/?' do
  if is_authenticated?
    flash[:notice] = 'You are already logged in.'
    redirect '/'
  end
  erb :login, :locals => { :title => 'Login' }
end

post '/login/?' do
  if user = auth_user(params[:email], params[:password])
    session[:user] = user
    add_cookie(user) unless params[:remember] == "off"    
    flash[:notice] = "Welcome back, #{user.handle}!"
    redirect '/'
  else
    flash[:notice] = 'User login failed.  Did you enter the correct username and password?'
    redirect '/login'
  end
end

post '/logout' do
  session.clear
  cookies.clear
  flash[:notice] = 'You have been signed out.  Goodbye!'
  redirect '/'
end

get '/signup' do
  erb :signup, :locals => { :title => 'Signup' }
end

post '/signup/submit' do
  # Build the user's profile
  # today = Date.today.to_s
  today = Date.today
  @profile = Profile.new("", "", today, "", "")
  params[:user][:profile] = @profile

  # Build the user's account
  @user = User.new(params[:user])
  if @user.save
    redirect '/login'
  else
    flash[:notice] = 'Signup failed.'
  end
end

get '/edit_profile' do
  erb :edit_profile, :locals => {:title => "Edit Profile" }
end

post '/edit_profile/submit' do
  params[:profile][:date_joined] = Date.today.to_s
  @profile = Profile.new(params[:profile][:bio], 
			 params[:profile][:dob],
			 params[:profile][:date_joined],
			 params[:profile][:location],
			 params[:profile][:name])
  user_id = session[:user]._id
  user = User.where(_id: user_id).first
  user.update_profile(@profile)
  redirect "/user/#{user_id}"
end

get '/user/:targeted_id' do
  @targeted_id = BSON::ObjectId.from_string(params[:targeted_id])
  present = User.where(_id: @targeted_id).exists?

  if present
    cur_user_id = session[:user]._id
    @cur_user = User.where(_id: cur_user_id).first
    @targeted_user = User.where(_id: @targeted_id).first
    @targeted_tweets = Array.new
    @targeted_followed = Array.new
    @targeted_following = Array.new
    # @targeted_liked = Array.new

    @isfollowing = @cur_user.follow?(@targeted_id)
    @ntweets = @targeted_user[:tweets].length
    if @ntweets > 0
      @targeted_tweets = Tweet.in(_id: @targeted_user[:tweets])
      @targeted_tweets = @targeted_tweets.reverse
    end

    @nfollowed = @targeted_user[:followed].length
    if @nfollowed > 0
      @targeted_followed = User.in(_id: @targeted_user[:followed])
    end

    @nfollowing = @targeted_user[:following].length
    if @nfollowing > 0
      @targeted_following = User.in(_id: @targeted_user[:following])
    end

    erb :user, :locals => { :title => '#{@targeted_user.handle}' }
    # erb :followeds, :locals => { :title => 'User Profile' }
  end
end

post '/follow' do
  @targeted_id= BSON::ObjectId.from_string(params[:targeted_id])
  user_id = session[:user]._id
  user = User.where(_id: user_id).first
  user.toggle_following(@targeted_id)
  targeted_user = User.where(_id: @targeted_id).first
  targeted_user.toggle_followed(user_id)

  # add all tweets of that user to current user timeline
  tweets = targeted_user.tweets
  tweets.each do |tweet_id|
    $redis.rpush(user_id.to_s, Tweet.where(_id: tweet_id).first.to_json)
  end

  # redirect "/user/#{@targeted_id}"
  redirect back
end

get '/user/followings/' do
  # get '/user/followings/' do
  @targeted_id = BSON::ObjectId.from_string(params[:targeted_id])
  present = User.where(_id: @targeted_id).exists?

  if present
    cur_user_id = session[:user]._id
    @cur_user = User.where(_id: cur_user_id).first
    @targeted_user = User.where(_id: @targeted_id).first
    # @targeted_tweets = Array.new
    # @targeted_followed = Array.new
    @targeted_following = Array.new
    # @targeted_liked = Array.new

    @isfollowing = @cur_user.follow?(@targeted_id)
    @ntweets = @targeted_user[:tweets].length
    # if @ntweets > 0
    # 	@targeted_tweets = Tweet.in(_id: @targeted_user[:tweets])
    # end

    @nfollowed = @targeted_user[:followed].length
    # if @nfollowed > 0
    # 	@targeted_followed = User.in(_id: @targeted_user[:followed])
    # end

    @nfollowing = @targeted_user[:following].length
    if @nfollowing > 0
      @targeted_following = User.in(_id: @targeted_user[:following])
    end

    # get all the user info about each following
    @targeted_following_info


    # erb :user, :locals => { :title => 'User Profile' }
    erb :followings, :layout => false, :locals => { :title => 'User Profile' }
  end
end

get '/user/followeds/' do
  @targeted_id = BSON::ObjectId.from_string(params[:targeted_id])
  present = User.where(_id: @targeted_id).exists?

  if present
    cur_user_id = session[:user]._id
    @cur_user = User.where(_id: cur_user_id).first
    @targeted_user = User.where(_id: @targeted_id).first
    # @targeted_tweets = Array.new
    @targeted_followed = Array.new
    # @targeted_following = Array.new
    # @targeted_liked = Array.new

    @isfollowing = @cur_user.follow?(@targeted_id)
    @ntweets = @targeted_user[:tweets].length
    # if @ntweets > 0
    # 	@targeted_tweets = Tweet.in(_id: @targeted_user[:tweets])
    # end

    @nfollowed = @targeted_user[:followed].length
    if @nfollowed > 0
      @targeted_followed = User.in(_id: @targeted_user[:followed])
    end

    @nfollowing = @targeted_user[:following].length
    # if @nfollowing > 0
    # 	@targeted_following = User.in(_id: @targeted_user[:following])
    # end

    # erb :user, :locals => { :title => 'User Profile' }
    erb :followeds, :layout => false, :locals => { :title => 'User Profile' }
  end
end

get '/posted' do
  user_id = session[:user]._id
  user = User.where(_id: user_id).first
  posted_ids = user.tweets
  if posted_ids.length > 50
    posted_ids = posted_ids[-50..-1]
  end
  if posted_ids.length > 0
    @posted_tweets = Tweet.in(_id: posted_ids)
  end
  erb :posted
end


get '/users' do
  authenticate!
  @name = session[:user]
  @users = User.all
  erb :users, :locals => { :title => 'All Users' }
end

get '/tweet/test' do
  erb :tweettest, :locals => { :title => 'Test Tweet' }
end

post '/tweet/new' do
  user_id = session[:user]._id
  params[:tweet][:author_id] = user_id
  params[:tweet][:author_handle] = session[:user].handle
  tweet = Tweet.new(params[:tweet])
  if tweet.save
    user = User.where(_id: user_id).first
    user.add_tweet(tweet._id)

    # spread this tweet to all followers
    followers = user.followed
    followers.each do |follower|
      $redis.rpush(follower.to_s, tweet.to_json)
    end

    redirect '/tweets'
  else
    flash[:warning] = 'Create tweet failed'
  end
end

get '/tweets' do
  @tweets = Tweet.all
  erb :tweets, :locals => { :title => 'Tweets' }
end

get '/tweet/:tweet_id' do
  present = Tweet.where(_id: params[:tweet_id]).exists?

  if present
    @tweet = Tweet.where(_id: params[:tweet_id]).first
    @replys = Array.new

    if @tweet[:replys].length > 0
      @replys = Reply.in(_id: @tweet[:replys])
    end
    erb :tweet, :locals => { :title => "Tweet #{params[:tweet_id]}" }
  else
    flash[:warning] = 'Can not find tweet!'
  end
end

post '/reply' do
  # create reply
  params[:reply][:tweet_id] = params[:tweet_id]
  reply = Reply.new(params[:reply])

  if reply.save
    # update corresponding tweet
    tweet_id = params[:tweet_id]
    tweet = Tweet.where(_id: tweet_id).first

    # add reply id to replies
    tweet.add_reply(reply[:_id])

    redirect "/tweet/#{tweet_id}"
    
  else 
    puts "save failed"
    flash[:warning] = 'Create reply failed'
  end
end

post '/like' do
  # update corresponding tweet
  tweet_id = params[:tweet_id]
  tweet = Tweet.where(_id: tweet_id).first

  # session[:user]._id
  # add user id into likedby
  tweet.add_like("temp")
  
  redirect "/tweet/#{tweet_id}"

end

post '/retweet' do
  # create retweet tweet
  user_id = session[:user]._id
  params[:retweet][:author_id] = user_id
  params[:retweet][:original_tweet_id] = params[:tweet_id]
  params[:retweet][:author_handle] = session[:user].handle
  retweet = Tweet.new(params[:retweet])

  if retweet.save
    user = User.where(_id: user_id).first
    user.add_tweet(retweet._id)
    redirect '/tweets'
  else
    flash[:warning] = 'Create tweet failed'
  end
end

