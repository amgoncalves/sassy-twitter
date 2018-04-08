get '/like' do
  # update corresponding tweet
  tweet_id = params[:tweet_id]
  # cur_user = get_user_from_session
  cur_user = get_user_from_redis
  user_id = cur_user._id

  tweet = Tweet.where(_id: tweet_id).first
  tweet.add_like(user_id)
  if cur_user.like?(tweet_id)
    flash[:notice] = 'Not available like operation!'
  else
    cur_user.like(tweet_id)
    save_user_to_redis(cur_user)
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
    flash[:notice] = 'Not available unlike operation!'
  else
    cur_user.unlike(tweet_id)
    save_user_to_redis(cur_user)
  end

  redirect back

end


