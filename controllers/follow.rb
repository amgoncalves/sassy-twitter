post '/follow' do
  targeted_id = BSON::ObjectId.from_string(params[:targeted_id])
	# login_user = get_user_from_session
	target_user = User.where(_id: targeted_id).first
	# login_user.toggle_following(target_user._id)
	# login_user.toggle_following(targeted_id)

	db_login_user = get_user_from_mongo
	db_login_user.toggle_following(targeted_id)

	target_user.toggle_followed(db_login_user._id)


	# db_login_user = User.where(_id: login_user._id).first
	# db_target_user = User.where(_id: target_user._id).first

	# db_login_user.update_followings(login_user)
	# db_target_user.update_followeds(target_user)

  # add all tweets of that user to current user timeline
  tweets = target_user.tweets
  tweets.each do |tweet_id|
    $redis.rpush(login_user._id.to_s, tweet_id)
  end

  redirect back
end
