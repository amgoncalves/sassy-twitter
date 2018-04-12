post $prefix + "/:apitoken/follow" do
  target_id = BSON::ObjectId.from_string(params[:targeted_id])
	query_res = User.where(_id: target_id)
	
	if query_res.exists?
		# target_user = User.where(_id: target_id).first
		target_user = query_res.first
		login_user = get_user_from_redis
		login_id = login_user._id
		login_user.toggle_following(target_id)

		save_user_to_redis(login_user)

		db_login_user = get_user_from_mongo
		db_login_user.toggle_following(target_id)

		target_user.toggle_followed(login_id)

    if db_login_user.follow?(target_user)
      # delete all tweets of that user to current user timeline
      tweets = target_user.tweets
      old_tweets = $redis.lrange(login_user._id.to_s, 0, -1).reverse
      new_tweets = old_tweets - tweets
      login_user.update_tweets(new_tweets)
    else
		  # add all tweets of that user to current user timeline
		  tweets = target_user.tweets
		  tweets.each do |tweet_id|
		  	$redis.rpush(login_id.to_s, tweet_id)
		  	if $redis.llen(login_id.to_s) > 100
		  		$redis.rpop(login_id.to_s)
		  	end
		  end
    end

		# response['Cache-Control'] =  "public, max-age=0, must-revalidate"
		# redirect back
		# erb :user, :locals => { :title => "#{target_user.handle}"}
	end
end
