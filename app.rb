require 'mongoid'
require 'mongo'
require 'sinatra'
require 'sinatra/flash'
require_relative './models/user'
require_relative './models/tweet'
require_relative './models/reply'
require 'byebug'

Mongoid.load!('./config/mongoid.yml')

enable :sessions

helpers do
  def redirect_to_original_request
    user = session[:user]
    flash[:notice] = 'Welcome back, #{user.name}.'
    original_request = session[:original_request]
    session[:original_request] = nil
    redirect original_request
  end

  def is_authenticated?
    return !!session[:user]
  end

  def auth_user(email, password)
    user = User.where(email: email).first
    return user if user && user.password == password
    return nil
  end
  
  def authenticate!
    unless session[:user]
      session[:original_request] = request.path_info
      redirect '/login'
    end
  end  
end

get '/' do
	@ids = User.pluck(:id)
  erb :index, :locals => { :title => 'Welcome!' }
end

get '/login/?' do
  erb :login, :locals => { :title => 'Login' }
end

post '/login/?' do
  if user = auth_user(params[:email], params[:password])  
    session[:user] = user
    redirect '/users'
  else
    flash[:notice] = 'User login failed.  Did you enter the correct username and password?'
    redirect '/login'
  end
end

post '/logout' do
  session[:user] = nil
  flash[:notice] = 'You have been signed out.  Goodbye!'
  redirect '/'
end

get '/signup' do
  erb :signup, :locals => { :title => 'Signup' }
end

post '/signup/submit' do
  # Build the user's profile
  today = DateTime.now
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
		@targeted_liked = Array.new

		@isfollowing = @cur_user.follow?(@targeted_id)
		@ntweets = @targeted_user[:tweets].length
		if @ntweets > 0
			@targeted_tweets = Tweet.in(_id: @targeted_user[:tweets])
		end

		@nfollowed = @targeted_user[:followed].length
		if @nfollowed > 0
			@targeted_followed = User.in(_id: @targeted_user[:followed])
		end

		@nfollowing = @targeted_user[:following].length
		if @nfollowing > 0
			@targeted_following = User.in(_id: @targeted_user[:following])
		end

		erb :user, :locals => { :title => 'User Profile' }
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

		# erb :user, :locals => { :title => 'User Profile' }
		erb :followings, :locals => { :title => 'User Profile' }
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
		erb :followeds, :locals => { :title => 'User Profile' }
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
  tweet = Tweet.new(params[:tweet])
  if tweet.save
	  user_id = session[:user]._id
		user = User.where(_id: user_id).first
		user.add_tweet(tweet._id)
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
  params[:retweet][:original_tweet_id] = params[:tweet_id]
  retweet = Tweet.new(params[:retweet])

  if retweet.save
    redirect '/tweets'
  else
    flash[:warning] = 'Create tweet failed'
  end

end
