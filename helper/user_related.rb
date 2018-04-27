def get_user_from_redis
	loginuser_redis_key = session[:user_id].to_s + "loginuser"
  
	user_hash = JSON.parse($redis.get(loginuser_redis_key))
	profile_hash = user_hash["profile"]
	profile = Profile.new(profile_hash)
	user_hash["profile"] = profile
	user = User.new(user_hash)

	return user
end

def save_user_to_redis(user)
	loginuser_redis_key = session[:user_id].to_s + "loginuser"
	$redis.set(loginuser_redis_key, user.to_json)
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
