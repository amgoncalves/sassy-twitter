post '/follow' do
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

		# add all tweets of that user to current user timeline
		tweets = target_user.tweets
		loginuser_redis_key = login_id.to_s + "loginuser"
		tweets.each do |tweet_id|
			$redis.rpush(loginuser_redis_key, tweet_id)
			if $redis.llen(loginuser_redis_key) > 50
				$redis.rpop(loginuser_redis_key)
			end
		end

		# response['Cache-Control'] =  "public, max-age=0, must-revalidate"
		# redirect back
		# erb :user, :locals => { :title => "#{target_user.handle}"}
	end
end
