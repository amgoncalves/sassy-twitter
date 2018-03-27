post '/follow' do
  targeted_id = BSON::ObjectId.from_string(params[:targeted_id])
	login_user = session[:user]
	target_user = User.where(_id: targeted_id).first
	login_user.toggle_following(target_user._id)
	target_user.toggle_followed(login_user._id)

  # add all tweets of that user to current user timeline
  tweets = target_user.tweets
  tweets.each do |tweet_id|
    $redis.rpush(login_user._id.to_s, Tweet.where(_id: tweet_id).first.to_json)
  end

  redirect back
end
