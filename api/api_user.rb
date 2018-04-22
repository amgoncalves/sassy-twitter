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

def get_user(type, key)
  user = nil
  if type == "id"
    user = User.where(_id: key).first
  elsif type == "handle"
    user = User.where(handle: key).first
  end
  return user
end
