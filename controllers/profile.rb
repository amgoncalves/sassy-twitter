def get_targeted_user
  @ids = User.pluck(:id)
  @tweets = Tweet.all.reverse # the cost of reverse  
  if is_authenticated?
    @users = User.all # TODO: delete in future
		@targeted_user = get_user_from_mongo
    @targeted_id = @targeted_user._id
    @cur_user = @targeted_user
    @ntweets = @targeted_user[:tweets].length
    if @ntweets > 0
      @targeted_tweets = Tweet.in(_id: @targeted_user[:tweets])
      @targeted_tweets = @targeted_tweets.reverse
    end

    @nfollowed = @targeted_user[:followeds].length
    if @nfollowed > 0
      @targeted_followed = User.in(_id: @targeted_user[:followeds])
    end

    @nfollowing = @targeted_user[:followings].length
    if @nfollowing > 0
      @targeted_following = User.in(_id: @targeted_user[:followings])
    end
  else
    gTLTweet_ids = $redis.lrange($globalTL, 0, -1)
    @tweets = Tweet.in(_id: gTLTweet_ids)
  end
end
