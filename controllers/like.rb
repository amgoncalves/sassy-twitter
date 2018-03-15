post '/like' do
  # update corresponding tweet
  tweet_id = params[:tweet_id]
  tweet = Tweet.where(_id: tweet_id).first

  # session[:user]._id
  # add user id into likedby
  tweet.add_like("temp")
  
  redirect "/tweet/#{tweet_id}"

end

