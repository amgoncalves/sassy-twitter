# Returns a user by key.  Key type (handle or id) is specified by param[:input_type].
get "/api/v1/:apitoken/users/:key" do
  user = get_user(params[:input_type], params[:key])
  if user
    user.to_json(:except => :password_hash)
  else
    error 404, { :error => "User #{:key} not found." }.to_json
  end
end

# Returns a users most recent tweets
get "/api/v1/:apitoken/users/:key/tweets" do
  user = get_user(params[:input_type], params[:key])
  tweets = Tweet.in(_id: user[:tweets])
  if tweets
    return build_json_tweets(tweets)
  else
    error 404, { :error => "User #{:id} has no tweets." }.to_json
  end  
end

# Returns a users followers
get "/api/v1/:apitoken/users/:key/followers" do
  user = get_user("id", params[:key])
  if user
    followers = Array.new
    follower_ids = user.followeds
    follower_ids.each do |id|
      followers.push(get_user("id", id))
    end
    return followers.to_json
  else
    error 404, { :error => "No followers found for user #{:key}." }.to_json
  end
end

# Returns users who are following user with id params[:key]
get "/api/v1/:apitoken/users/:key/following" do
  user = get_user("id", params[:key])
  if user
    following = Array.new
    following_ids = user.followings
    following_ids.each do |id|
      following.push(get_user("id", id))
    end
    return following.to_json
  else
    error 404, { :error => "No followers found for user #{:key}." }.to_json
  end
end

# User with valid apitoken will follow user with id = params[:key]
post "/api/v1/:apitoken/users/:key/follow" do
  user = get_user("handle", params[:apitoken])
  return nil unless user != nil

  target_id = BSON::ObjectId.from_string(params[:targeted_id])
  target_user = get_user("id", target_id)
  
  if user.follow?(target_user)
    puts "API_V1: User #{user.handle} already following user #{target_user.handle}."
  else
    user.toggle_following(target_id)
    save_user_to_redis(user)
  end

  if target_user.followed?(user)
    puts "API_V1: User #{target_user.handle} already followed by user #{user.handle}."
  else
    target_user.toggle_followed(user._id)
  end

  if user.follow?(target_user) && target_user.followed?(user)
    return { :success => "User #{user.handle} now following user #{target_user.handle}." }.to_json
  else
    error 404, { :error => "No followers found for user #{:key}." }.to_json
  end
end

# User with valid apitoken will unfollow user with id = params[:key]
post "/api/v1/:apitoken/users/:key/unfollow" do
  user = get_user("handle", params[:apitoken])
  return nil unless user != nil

  target_id = BSON::ObjectId.from_string(params[:targeted_id])
  target_user = get_user("id", target_id)
  
  if !user.follow?(target_user)
    puts "API_V1: User #{user.handle} not following user #{target_user.handle}."
  else
    user.toggle_following(target_id)
    save_user_to_redis(user)
  end

  if !target_user.followed?(user)
    puts "API_V1: User #{target_user.handle} not followed by user #{user.handle}."
  else
    target_user.toggle_followed(user._id)
  end

  if !user.follow?(target_user) && !target_user.followed?(user)
    return { :success => "User #{user.handle} unfollowed user #{target_user.handle}." }.to_json
  else
    error 404, { :error => "No followers found for user #{:key}." }.to_json
  end
end

# Fetches a user from the database using either id or handle.
def get_user(type, key)
  user = nil
  if type == "id"
    user = User.where(_id: key).first
  elsif type == "handle"
    user = User.where(handle: key).first
  end
  return user
end
