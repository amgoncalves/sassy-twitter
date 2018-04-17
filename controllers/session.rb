def redirect_to_original_request
  user = get_user_from_mongo
  flash[:notice] = 'Welcome back, #{user.handle}!'
  original_request = session[:original_request]
  session[:original_request] = nil
  redirect original_request
end

def is_authenticated?
  return !!session[:user_id]
end

def set_user_globals
  if session[:user_id] != nil
    @cur_user = get_user_from_mongo
  elsif cookies[:user_id] != nil
    @cur_user = get_user_from_cookies
    session[:user_id] = @cur_user._id unless @cur_user == nil
  end  
end

def auth_user(email, password)
  user = User.where(email: email).first
  return user if user && user.password == password
  return nil
end

def add_cookie(user)
  if user == nil
    puts "No user was found."
    return
  end
  cookies[:user_id] = user._id
end

def authenticate!
  unless session[:user_id]
    session[:original_request] = request.path_info
    redirect '/login'
  end
end

def get_handle(id)
  usr = User.where(_id: id).first
  user.handle
end

