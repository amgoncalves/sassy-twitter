get "/alltweets" do
  if is_authenticated?
    if session[:user_id] == nil
      session.clear
      cookies.clear
      redirect "/"
    end

    @tweets = $redis.lrange($globalTL,0, 50).reverse

    # if session contains user information extract user from redis
    # otherwise from mongodb
    loginuser_redis_key = session[:user_id].to_s + "loginuser"
    if $redis.exists(loginuser_redis_key)
      @cur_user = get_user_from_redis
    else
      @cur_user = get_user_from_mongo
    end

    @targeted_user = @cur_user
    @targeted_id = @targeted_user._id

    @info = Hash.new
    @info[:login_user] = @cur_user
    @info[:target_user] = @targeted_user
    @info[:target_tweets] = @tweets
  else
    @tweets = $redis.lrange($globalTL, 0, 50).reverse
  end
  erb :alltweets
end