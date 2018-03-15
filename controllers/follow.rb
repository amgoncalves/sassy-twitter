post '/follow' do
  @targeted_id= BSON::ObjectId.from_string(params[:targeted_id])
  user_id = session[:user]._id
  user = User.where(_id: user_id).first
  user.toggle_following(@targeted_id)
  targeted_user = User.where(_id: @targeted_id).first
  targeted_user.toggle_followed(user_id)

  # add all tweets of that user to current user timeline
  tweets = targeted_user.tweets
  tweets.each do |tweet_id|
    $redis.rpush(user_id.to_s, Tweet.where(_id: tweet_id).first.to_json)
  end

  # redirect "/user/#{@targeted_id}"
  redirect back
end
