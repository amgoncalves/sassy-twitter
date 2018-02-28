require 'mongoid'
require 'mongo'
require 'sinatra'
require 'sinatra/flash'
require_relative './models/user'

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
