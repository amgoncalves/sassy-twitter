get '/timeline' do
  @ids = User.pluck(:id)
  if is_authenticated?
    tweet_ids = $redis.lrange(session[:user_id].to_s, 0, 50)
    @tweets = Tweet.in(_id: tweet_ids)
    @tweets = @tweets.reverse
    # @targeted_user = get_user_from_session
    @targeted_user = get_user_from_redis
    @targeted_id = @targeted_user._id

    @ntweets = @targeted_user.ntweets
    @nfollowed = @targeted_user.nfolloweds
    @nfollowing = @targeted_user.nfollowings
    if @nfollowing > 0
      @targeted_following = User.in(_id: @targeted_user[:followings])
    end

		# code added by Shuai at Mar 23
		@info = Hash.new
		# @info[:login_user] = @cur_user
		@info[:login_user] = get_user_from_redis()
		@cur_user = @info[:login_user]
		@info[:target_user] = @targeted_user
    
  end
  erb :timeline, :locals => { :title => 'Home Timeline!' }
end
