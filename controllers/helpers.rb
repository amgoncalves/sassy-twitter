=begin
get '/posted' do
  user = get_user_from_session
  posted_ids = user.tweets
  if posted_ids.length > 50
    posted_ids = posted_ids[-50..-1]
  end
  if posted_ids.length > 0
    @posted_tweets = Tweet.in(_id: posted_ids)
  end
  erb :posted
end
=end
