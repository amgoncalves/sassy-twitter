post '/follow' do
  targeted_id = BSON::ObjectId.from_string(params[:targeted_id])
	login_user = get_user_from_session
	target_user = User.where(_id: targeted_id).first
	login_user.toggle_following(target_user._id)
	target_user.toggle_followed(login_user._id)

  # add all tweets of that user to current user timeline
  tweets = target_user.tweets
  tweets.each do |tweet_id|
    $redis.rpush(login_user._id.to_s, tweet_id)
  end

  redirect back
end
