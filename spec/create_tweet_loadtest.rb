post '/loadtest/user/create' do
  if User.where(handle: "test0406").exists?
    User.where(handle: "test0406").delete
  end

  # Build the user's profile
  @profile = Profile.new("", Date.jd(0), Date.today, "", "")
  testuser = Hash.new
  testuser[:profile] = @profile
  testuser[:handle] = "test0406"
  testuser[:email] = "test0406@test"
  testuser[:password_hash] = "test0406"
  testuser[:APItoken] = "test0406"

  # Build the user's account
  @user = User.new(testuser)
  if @user.save
    $testUserID = @user._id
    flash[:notice] = 'Signup Successfully.'
  else
    flash[:notice] = 'Signup failed.'
  end
end

post '/loadtest/user/create/:count' do
  i = 0
  while i < params[:count].to_i do
    if User.where(handle: "test#{i}").exists?
      User.where(handle: "test#{i}").delete
    end

    user = User.create(handle: "test#{i}", 
      email: "test#{i}@test",
      password: "password#{i}")
    
    i = i +1
  end
end

post '/loadtest/user/delete' do
  if User.where(handle: "test0406").exists?
    flash[:notice] = 'Delete failed.'
  else
    flash[:notice] = 'Delete Successfully.'
  end
end

post '/loadtest/tweet/new' do
  @hashtag_list = Array.new
  user_id = rand(100).to_s
  t = Hash.new
  t[:author_id] = user_id
  t[:author_handle] = "test#{user_id}"
  if params[:tweet] == nil
    t[:content] = "test tweet"
  else 
    t[:content] = params[:tweet]
  end
  t[:content] = generateHashtagTweet(t[:content])
  t[:content] = generateMentionTweet(t[:content])
  @tweet = Tweet.new(t)
  if @tweet.save
    user = User.where(handle: "test#{user_id}").first
    tweet_id = @tweet._id
    user.add_tweet(tweet_id)

    # spread this tweet to all followers
    followers = user.followeds
    followers.each do |follower|
      $redis.rpush(follower.to_s, tweet_id)
    end

    # save this tweet in global timeline
    $redis.rpush($globalTL, @tweet.to_json)
    if $redis.llen($globalTL) > 50
      $redis.rpop($globalTL)
    end

    # store the hashtag
    @hashtag_list.each do |hashtag_name| 
      if Hashtag.exists? && Hashtag.where(hashtag_name: hashtag_name).exists?
        hashtag = Hashtag.where(hashtag_name: hashtag_name).first
        hashtag.add_tweet(tweet_id) 
      else
        tweets = Set.new
        tweets.add(tweet_id)
        Hashtag.where(hashtag_name: hashtag_name, tweets: tweets).create
      end
    end
    # flash[:warning] = 'Create tweet successully'
    erb :tweet, :locals => { :title => 'Tweet Detail' }
  else
    flash[:warning] = 'Create tweet failed'
  end
end