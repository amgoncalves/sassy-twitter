get '/timeline' do
  @ids = User.pluck(:id)
  if is_authenticated?
    @tweets = $redis.lrange(session[:user]._id.to_s, 0, 50)
    @users = User.all
    @cur_user = User.where(_id: session[:user]._id).first
    @targeted_user = session[:user]
    @targeted_id = @targeted_user._id
    @ntweets = @targeted_user[:tweets].length
    if @ntweets > 0
      @targeted_tweets = Tweet.in(_id: @targeted_user[:tweets])
      @targeted_tweets = @targeted_tweets.reverse
    end

    @nfollowed = @targeted_user[:followed].length
    if @nfollowed > 0
      @targeted_followed = User.in(_id: @targeted_user[:followed])
    end

    @nfollowing = @targeted_user[:following].length
    if @nfollowing > 0
      @targeted_following = User.in(_id: @targeted_user[:following])
    end
    
  end
  erb :hometimeline, :locals => { :title => 'Home Timeline!' }
end
