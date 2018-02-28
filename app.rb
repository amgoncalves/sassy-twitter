require 'mongoid'
require 'mongo'
require 'sinatra'
require 'sinatra/flash'
require_relative './models/user'
require_relative './models/tweet'
require_relative './models/reply'

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
  params[:user][:Profile] = @profile

  # Build the user's account
  @user = User.new(params[:user])
  if @user.save
    redirect '/login'
  else
    flash[:notice] = 'Signup failed.'
  end
end

get '/users' do
  authenticate!
  @users = User.all
  erb :users, :locals => { :title => 'All Users' }
end

get '/tweet/test' do
  erb :tweettest, :locals => { :title => 'Test Tweet' }
end

post '/tweet/new' do
  tweet = Tweet.new(params[:tweet])
  if tweet.save
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


