post '/follow' do
  target_id = BSON::ObjectId.from_string(params[:targeted_id])
	target_user = User.where(_id: target_id).first
	login_user = get_user_from_redis
	login_id = login_user._id
	login_user.toggle_following(target_id)

	save_user_to_redis(login_user)

	db_login_user = get_user_from_mongo
	db_login_user.toggle_following(target_id)

	target_user.toggle_followed(login_id)

  # add all tweets of that user to current user timeline
  tweets = target_user.tweets
  byebug
  tweets.each do |tweet_id|
    byebug
    $redis.rpush(login_id.to_s, tweet_id)
    if $redis.llen(login_id.to_s) > 50
      $redis.rpop(login_id.to_s)
    end
  end

  redirect back
end
