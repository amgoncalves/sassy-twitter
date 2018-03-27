get '/user/:targeted_id' do
  targeted_id = BSON::ObjectId.from_string(params[:targeted_id])
	query_res = User.where(_id: targeted_id)
	target_exist = query_res.exists?
	@info = Hash.new

  if target_exist
		login_user = session[:user]
		target_user = query_res.first
		isfollowing = login_user.follow?(target_user)
		target_tweets = Array.new

		if target_user.ntweets > 0
			target_tweets = Tweet.in(_id: target_user[:tweets])
			target_tweets = target_tweets.reverse
		end
		@info[:login_user] = login_user
		@info[:target_user] = target_user
		@info[:isfollowing] = isfollowing
		@info[:target_tweets] = target_tweets
    erb :user, :locals => { :title => '#{@targeted_user.handle}' }
  end
end
