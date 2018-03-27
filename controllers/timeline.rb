get '/timeline' do
  @ids = User.pluck(:id)
  if is_authenticated?
    tweet_ids = $redis.lrange(session[:user]._id.to_s, 0, 50)
    @tweets = Tweet.in(_id: tweet_ids)
    @targeted_user = session[:user]
    @targeted_id = @targeted_user._id

    @users = User.all
    @ntweets = @targeted_user[:tweets].length
    @nfollowed = @targeted_user[:followed].length
    @nfollowing = @targeted_user[:following].length
    if @nfollowing > 0
      @targeted_following = User.in(_id: @targeted_user[:following])
    end

		# code added by Shuai at Mar 23
		@info = Hash.new
		@info[:login_user] = @cur_user
		@info[:target_user] = @targeted_user
    
  end
  erb :timeline, :locals => { :title => 'Home Timeline!' }
end
