get '/demo/reset/redis' do
	$redis.flushall
end

post '/demo/redis/user/create' do
	starttime = Time.now
	i = 0
	while i < 1000 do
		today = Date.today.strftime("%B %Y")
		profile_hash = {:bio => "", :dob => "", :date_joined => today, :location => "", :name => ""}
		profile = Profile.new(profile_hash)
		user_hash = Hash.new
		user_hash[:id] = "user" + i.to_s
		user_hash[:handle] = "test_redis#{i}"
		user_hash[:email] = "test_redis#{i}@redis.com"
		user_hash[:password] = "pwd#{i}"
		user_hash[:profile] = profile

		user = User.new(user_hash)

		# add user to redis
		$redis.set("user" + i.to_s, user.to_json)
		
		i = i + 1
	end

	endtime = Time.now
	erb "created 1000 users process time: #{endtime - starttime} second",
	:locals => {:title => 'create 1000 users redis' }
end

post '/demo/redis/tweet/create' do
	starttime = Time.now

	j = 0
	while j < 100 do
		i = 0
		author_hash = JSON.parse($redis.get("user" + j.to_s))
		author = User.new(author_hash)
		while i < 10 do
			tweet_hash = Hash.new
			author_id = j.to_s
			tweet_hash[:userd_id] = author_id
			tweet_hash[:author_handle] = "test_redis#{author_id}"
			tweet_hash[:content] = "test tweet (redis) #{i} by author #{author_id}"

			tweet = Tweetd.new(tweet_hash)
			tweet_key_in_redis = "user" + author_id + "tweet" + i.to_s
			$redis.set(tweet_key_in_redis, tweet.to_json)
			author.add_tweet(tweet._id)
			i = i + 1
		end 
		$redis.set("user" + j.to_s, author.to_json)
		j = j + 1
	end

	endtime = Time.now
	erb "created 1000 tweets process time: #{endtime - starttime} seconds",
	:locals => { :title => 'Create 1000 Tweets MongoDB' }
end

post '/demo/redis/user' do
	starttime = Time.now
	i = 0
	while i < 1000 do
		user_id = rand(1000).to_s
		user_hash = JSON.parse($redis.get("user" + user_id))
		user = User.new(user_hash)
		i = i + 1
	end
	endtime = Time.now
	erb "Retrieved 1000 users process time: #{endtime - starttime} seconds", 
	:locals => { :title => 'Read 1000 Users Redis'}
end

post '/demo/redis/user/delete' do
	starttime = Time.now
	i = 0
	while i < 100
		user_key = "user" + i.to_s
		user_hash = JSON.parse($redis.get(user_key))
		user = User.new(user_hash)
		user.tweets.each do |tweet_id|
			$redis.del(tweet_id)
		end
		$redis.del(user_key)
		i = i + 1
	end
	endtime = Time.now
	erb "Deleted 100 users with 1000 tweets process time: #{endtime - starttime} seconds",
	:locals => { :title => 'Delete 100 Users Redis' }
end

post '/demo/redis/tweet/delete' do
	starttime = Time.now

	j = 0
	while j < 100 do
	 i = 0
	 while i < 10 do
		 tweet_key_in_redis = "user" + j.to_s + "tweet" + i.to_s
		 $redis.del(tweet_key_in_redis)
		 i = i + 1
	 end
	 j = j + 1
	end
	endtime = Time.now
	erb "Deleted 1000 tweets process time: #{endtime - starttime} seconds",
	:locals => { :title => 'Delete 1000 tweets Redis' }
end

post '/demo/redis/user/update' do
	# modifiy 1000 user's password
	starttime = Time.now
	i = 0
	while i < 1000
		user_key = "user" + i.to_s
		$redis.hset(user_key, "password", "newpwd#{i}")
		i = i + 1
	end
	endtime = Time.now
	erb "Updated 1000 users process time: #{endtime - starttime} seconds",
	:locals => { :title => 'Update 1000 users redis' }
end
