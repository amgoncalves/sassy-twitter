def redirect_to_original_request
  user = get_user_from_mongo
  flash[:notice] = 'Welcome back, #{user.handle}!'
  original_request = session[:original_request]
  session[:original_request] = nil
  redirect original_request
end

def is_authenticated?
  return session[:user_id] != nil
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

def save_user_to_redis(user)
	loginuser_redis_key = session[:user_id].to_s + "loginuser"
	# $redis.set($currentUser, user.to_json)
	$redis.set(loginuser_redis_key, user.to_json)

	# $redis.hmset($currentUser, 
	# keys = user.attributes.keys
	# byebug
	# keys.each do |field|
	# 	if field == "profile"
	# 	else 
	# 		$redis.hset($currentUser, field, user.attributes[field].to_json)
	# 	end
	# byebug
	# $redis.mapped_hmset($currentUser, user.attributes)
	# end

end

def get_user_from_redis
	loginuser_redis_key = session[:user_id].to_s + "loginuser"
	# user_hash = JSON.parse($redis.get($currentUser))
	user_hash = JSON.parse($redis.get(loginuser_redis_key))
	profile_hash = user_hash["profile"]
	profile = Profile.new(profile_hash)
	user_hash["profile"] = profile
	user = User.new(user_hash)
	
	# user_hash = $redis.hgetall($currentUser)
	# user = User.new(user_hash)
	# profile_hash = user[:profile]
	# user.profile = Profile.new(profile_hash)
	return user
end

def del_user_from_redis
	loginuser_redis_key = session[:user_id].to_s + "loginuser"
	$redis.del(loginuser_redis_key)
end

def get_user_from_cookie
  return User.where(_id: cookies[:user_id]).first
end

def get_user_from_mongo
	return User.where(_id: session[:user_id]).first
end
