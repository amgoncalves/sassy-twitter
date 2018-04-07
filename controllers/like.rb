get '/like' do
  # update corresponding tweet
  tweet_id = params[:tweet_id]
  # cur_user = get_user_from_session
  cur_user = get_user_from_redis
  user_id = cur_user._id

  tweet = Tweet.where(_id: tweet_id).first
  tweet.add_like(user_id)
  if cur_user.like?(tweet_id)
    byebug
  else
    cur_user.like(tweet_id)
  end

  redirect back

end

get '/unlike' do
  # update corresponding tweet
  tweet_id = params[:tweet_id]
  # cur_user = get_user_from_session
  cur_user = get_user_from_redis
  user_id = cur_user._id

  tweet = Tweet.where(_id: tweet_id).first
  tweet.delete_like(user_id.to_s)
  if cur_user.like?(tweet_id) == false
    byebug
  else
    cur_user.unlike(tweet_id)
  end

  redirect back

end


