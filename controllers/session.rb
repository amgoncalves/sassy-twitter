def redirect_to_original_request
  user = session[:user]
  flash[:notice] = 'Welcome back, #{user.handle}!'
  original_request = session[:original_request]
  session[:original_request] = nil
  redirect original_request
end

def is_authenticated?
  if session[:user] != nil
    @cur_user = session[:user]
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
