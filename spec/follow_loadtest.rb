post '/loadtest/follow' do
	login_id = params[:login_id]
	login_query_res = User.where(_id: login_id)
	target_id = params[:targeted_id]
	target_query_res = User.where(_id: target_id)

	if login_query_res.exists? and target_query_res.exists? and login_id != target_id
		db_login_user = login_query_res.first
		target_user = target_query_res.first
		loginuser_redis_key = login_id.to_s + "loginuser"
		$redis.set(loginuser_redis_key, db_login_user.to_json)

		db_login_user.toggle_following(target_id)
		target_user.toggle_followed(login_id)

		tweets = target_user.tweets
		tweets.each do |tweet_id|
			$redis.lpush(db_login_user._id.to_s, tweet_id)
      if $redis.llen(db_login_user._id.to_s) > 50
        $redis.rpop(db_login_user._id.to_s)
      end
		end

		isfollowing = db_login_user.follow?(target_user)

		if target_user.ntweets > 0
			target_tweets = Tweet.in(_id: target_user[:tweets])
			target_tweets = target_tweets.reverse
		end

		erb "#{login_id} successfully follows #{target_id}", 
			:locals => {:title => 'a user follows another user in mongo'}
	end
end

post '/loadtest/user/make' do
	today = Date.today.strftime("%B %Y")
	profile_hash = {:bio => "", :dob => "", :date_joined => today, :location => "", :name => ""}
	profile = Profile.new(profile_hash)
	params[:profile] = profile
	user = User.new(params)
	user.save
	erb "created a new user", :locals => {:title => ' create a user in mongo'}
end
