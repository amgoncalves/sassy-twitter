get '/login/?' do
  if is_authenticated?
    flash[:notice] = 'You are already logged in.'
    redirect "/"
  end
  erb :login, :locals => { :title => 'Login' }
end

post '/login/?' do
  if user = auth_user(params[:email], params[:password])
    session[:user_id] = user._id
    add_cookie(user) unless params[:remember] == 'off'
    save_user_to_redis(user)
    flash[:notice] = "Welcome back, #{user.handle}!"
    redirect '/'
  else
    flash[:danger] = 'Login failed.  Did you remember the correct username and password?'
    redirect '/login'
  end
end
