require 'sinatra'
require 'sinatra/flash'

helpers do
  def redirect_to_original_request
    user = session[:user]
    flash[:notice] = 'Welcome back, #{user.name}.'
    original_request = session[:original_request]
    session[:original_request] = nil
    redirect original_request
  end

  def is_authenticated?
    return !!session[:user_id]
  end
end

get '/' do
  erb :index, :locals => { :title => 'Welcome!' }
end

get '/login/?' do
  erb :login, :locals => { :title => 'Login' }
end

post '/login/?' do
  if user = User.authenticate(params)
    session[:user] = user
    redirect_to_original_request
  else
    flash[:notice] = 'User login failed.  Did you enter the correct username and password?'
    redirect '/login'
  end
end

get '/logout' do
  session[:user] = nil
  flash[:notice] = 'You have been signed out.  Goodbye!'
  redirect '/'
end

get '/signup/?' do
  
end
