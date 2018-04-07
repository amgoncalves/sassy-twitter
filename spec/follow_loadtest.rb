post '/loadtest/follow' do
	login_id = BSON::ObjectId.from_string(params[:login_id])
	db_login_user = User.where(_id: target_id).first

	$redis.set($currentUser, db_login_user.to_json)

	target_id = BSON::ObjectId.from_string(params[:targeted_id])
	target_user = User.where(_id: target_id).first


	db_login_user.toggle_following(target_id)
	target_user.toggle_followed(login_id)

  tweets = target_user.tweets
  tweets.each do |tweet_id|
    $redis.rpush(login_user._id.to_s, tweet_id)
  end

	isfollowing = db_login_user.follow?(target_user)

	@info = Hash.new
	@info[:login_user] = db_login_user
	@info[:target_user] = target_user
	@info[:isfollowing] = isfollowing
	@info[:target_tweets] = tweets

	erb :user, :locals => { :title -> "#{target_user.handle}"}

end
