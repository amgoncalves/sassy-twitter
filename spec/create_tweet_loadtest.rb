post '/loadtest/user/create/:count' do
  i = 0
  while i < params[:count].to_i do
    if User.where(handle: "test#{i}").exists?
      User.where(handle: "test#{i}").delete
    end

    profile_hash = {:bio => "", :dob => Date.jd(0), :date_joined => Date.today, :location => "", :name => ""}
    profile = Profile.new(profile_hash)
    uhash = Hash.new
    uhash[:id] = i.to_s
    uhash[:handle] = "test#{i}"
    uhash[:email] = "test#{i}@test"
    uhash[:password] = "password#{i}"
    uhash[:profile] = profile
    
    user = User.new(uhash)
    user.save

    loginuser_redis_key = i.to_s + "loginuser"
    $redis.set(loginuser_redis_key, user.to_json)
    
    i = i + 1
  end
end

post '/loadtest/user/delete' do
  if User.where(handle: "test0406").exists?
    flash[:notice] = 'Delete failed.'
  else
    flash[:notice] = 'Delete Successfully.'
  end
end

post '/loadtest/tweet/new' do
  @hashtag_list = Array.new
  user_id = rand(100).to_s

  # get the current login user
  loginuser_redis_key = user_id + "loginuser"
  user_hash = JSON.parse($redis.get(loginuser_redis_key))
  profile_hash = user_hash["profile"]
  profile = Profile.new(profile_hash)
  user_hash["profile"] = profile
  redis_login_user = User.new(user_hash)

  t = Hash.new
  t[:author_id] = user_id
  t[:author_handle] = "test#{user_id}"
  if params[:tweet] == nil
    t[:content] = "test tweet"
  else 
    t[:content] = params[:tweet]
  end
  t[:content] = generateHashtagTweet(t[:content])
  t[:content] = generateMentionTweet(t[:content])
  tweet = Tweet.new(t)
  if tweet.save
    tweet_id = tweet._id
    login_user_id = redis_login_user._id

    # update db
    db_login_user = User.where(_id: login_user_id).first
    db_login_user.add_tweet(tweet_id)
    
    # update redis
    redis_login_user.add_tweet(tweet_id)
    save_user_to_redis(redis_login_user)

    # spread this tweet to all followers
    followers = db_login_user.followeds
    followers.each do |follower|
      $redis.rpush(follower.to_s, tweet_id)
      if $redis.llen(follower.to_s) > 50
        $redis.rpop(follower.to_s)
      end
    end

    # save this tweet in global timeline
    $redis.rpush($globalTL, tweet.to_json)
    if $redis.llen($globalTL) > 50
      $redis.rpop($globalTL)
    end

    # store the hashtag
    @hashtag_list.each do |hashtag_name| 
      if Hashtag.exists? && Hashtag.where(hashtag_name: hashtag_name).exists?
        hashtag = Hashtag.where(hashtag_name: hashtag_name).first
        hashtag.add_tweet(tweet_id) 
      else
        tweets = Set.new
        tweets.add(tweet_id)
        Hashtag.where(hashtag_name: hashtag_name, tweets: tweets).create
      end
    end
  else
    flash[:warning] = 'Create tweet failed'
  end
end
