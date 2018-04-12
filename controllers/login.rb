get $prefix + "/login/?" do
  if is_authenticated?
    flash[:notice] = 'You are already logged in.'
    redirect $prefix + "/"
  end
  erb :login, :locals => { :title => 'Login' }
end

post $prefix + "/login/?" do
  if user = auth_user(params[:email], params[:password])
    session[:user_id] = user._id
    add_cookie(user) unless params[:remember] == "off"
    # $redis.set($currentUser, user.to_json) # add user to redis 
		save_user_to_redis(user)
    flash[:notice] = "Welcome back, #{user.handle}!"
    apitoken = "/#{user.handle}"
    redirect $prefix + apitoken + "/"
  else
    flash[:notice] = 'User login failed.  Did you enter the correct username and password?'
    redirect $prefix + "/login"
  end
end
