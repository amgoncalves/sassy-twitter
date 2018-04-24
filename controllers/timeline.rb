get "/timeline" do
  if !is_authenticated?
    redirect "/"
  end

  if session[:user_id] == nil
    redirect "/"
  else
    loginuser_redis_key = session[:user_id].to_s + "loginuser"
    if $redis.exists(loginuser_redis_key)
      @cur_user = get_user_from_redis
    else
      @cur_user = get_user_from_mongo
    end
  end

  # tweet_ids = $redis.lrange(session[:user_id].to_s, 0, 50)
  timeline = PersonalTL.where(user_id: session[:user_id].to_s).first
  if timeline != nil
    tweet_ids = timeline.tweets
  else
    tweet_ids = Array.new
  end
  @tweets = Tweet.in(_id: tweet_ids)
  @tweets = @tweets.reverse
 
  @targeted_user = @cur_user
  @targeted_id = @targeted_user._id

  @ntweets = @targeted_user.ntweets
  @nfollowed = @targeted_user.nfolloweds
  @nfollowing = @targeted_user.nfollowings

  @info = Hash.new
  @info[:login_user] = @cur_user
  @info[:target_user] = @targeted_user
    
  erb :timeline
end
