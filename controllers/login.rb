get '/login/?' do
  if is_authenticated?
    flash[:notice] = 'You are already logged in.'
    redirect '/'
  end
  erb :login, :locals => { :title => 'Login' }
end

post '/login/?' do
  if user = auth_user(params[:email], params[:password])
    session[:user_id] = user._id
    add_cookie(user) unless params[:remember] == "off"
    #$redis.set($currentUser, user.to_json) # add user to redis 
    flash[:notice] = "Welcome back, #{user.handle}!"
    redirect '/'
  else
    flash[:notice] = 'User login failed.  Did you enter the correct username and password?'
    redirect '/login'
  end
end
