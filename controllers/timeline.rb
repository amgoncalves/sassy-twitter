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
    
  end
  erb :timeline, :locals => { :title => 'Home Timeline!' }
end
