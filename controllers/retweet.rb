post '/retweet' do
  # create retweet tweet
  author_id = session[:user]._id
  author_handle = session[:user].handle
  original_tweet_id = BSON::ObjectId.from_string(params[:tweet_id])
  content = params[:retweet][:content]
  retweet = Tweet.new(author_id: author_id, original_tweet_id: original_tweet_id, author_handle: author_handle, content: content)

  if retweet.save
    user = session[:user]
    user.add_tweet(retweet._id)
    redirect "/tweet/#{retweet._id}"
  else
    byebug
    flash[:warning] = 'Create tweet failed'
  end
end

get '/retweet' do
  @t = Tweet.find(params[:tweet_id])
  erb :retweet, :locals => { :title => 'Retweet' }
end


