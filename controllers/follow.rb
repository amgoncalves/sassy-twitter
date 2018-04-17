post $prefix + "/:apitoken/follow" do
  if !is_authenticated?
    redirect $prefix + "/"
  end
  
  target_id = BSON::ObjectId.from_string(params[:targeted_id])
  query_res = User.where(_id: target_id)
  
  if query_res.exists?
    target_user = query_res.first
    login_user = get_user_from_redis
    login_id = login_user._id
    login_user.toggle_following(target_id)

    save_user_to_redis(login_user)

    db_login_user = get_user_from_mongo
    db_login_user.toggle_following(target_id)

    target_user.toggle_followed(login_id)

    if db_login_user.follow?(target_user)
      # add all tweets of that user to current user timeline
      tweets = target_user.tweets
      tweets.each do |tweet_id|
        $redis.rpush(login_id.to_s, tweet_id)
        if $redis.llen(login_id.to_s) > 100
          $redis.rpop(login_id.to_s)
        end
      end
      #store in mongodb
      # new_tweets = $redis.lrange(login_id.to_s, 0, -1).reverse
      # login_user.update_tweets(new_tweets)
    else
      # delete all tweets of that user to current user timeline
      tweets = target_user.tweets
      tweets.each do |tweet_id|
        $redis.lrem(login_id.to_s, 0, tweet_id.to_s)
      end
      # store in mongodb
      # new_tweets = $redis.lrange(login_id.to_s, 0, -1).reverse
      # login_user.update_tweets(new_tweets)
    end
  end
end
