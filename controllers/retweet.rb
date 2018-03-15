post '/retweet' do
  # create retweet tweet
  user_id = session[:user]._id
  params[:retweet][:author_id] = user_id
  params[:retweet][:original_tweet_id] = params[:tweet_id]
  params[:retweet][:author_handle] = session[:user].handle
  retweet = Tweet.new(params[:retweet])

  if retweet.save
    user = User.where(_id: user_id).first
    user.add_tweet(retweet._id)
    redirect '/tweets'
  else
    flash[:warning] = 'Create tweet failed'
  end
end

