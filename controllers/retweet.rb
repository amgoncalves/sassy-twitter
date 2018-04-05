post '/retweet' do
  @hashtag_list = Array.new

  # create retweet tweet
  author_id = session[:user_id]
  author_handle = get_user_from_session.handle
  original_tweet_id = BSON::ObjectId.from_string(params[:tweet_id])
  content = generateHashtagTweet(params[:retweet][:content])
  content = generateMentionTweet(params[:retweet][:content])
  retweet = Tweet.new(author_id: author_id, original_tweet_id: original_tweet_id, author_handle: author_handle, content: content)

  if retweet.save
    user = get_user_from_session
    user.add_tweet(retweet._id)

    # spread this tweet to all followers
    followers = user.followeds
    followers.each do |follower|
      $redis.rpush(follower.to_s, retweet._id)
    end

    # save this tweet in global timeline
    $redis.rpush($globalTL, retweet.to_json)
    if $redis.llen($globalTL) > 50
      $redis.rpop($globalTL)
    end

    # store the hashtag
    @hashtag_list.each do |hashtag_name| 
      if Hashtag.exists? && Hashtag.where(hashtag_name: hashtag_name).exists?
        hashtag = Hashtag.where(hashtag_name: hashtag_name).first
        hashtag.add_tweet(retweet._id) 
      else
        tweets = Set.new
        tweets.add(retweet._id)
        Hashtag.where(hashtag_name: hashtag_name, tweets: tweets).create
      end
    end

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



