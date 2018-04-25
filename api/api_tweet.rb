# Gets a single tweet if one exists with an id = params[:id]
# To get most recent tweets, set params[:id] = "recent"
get "/api/v1/:apitoken/tweets/:id" do
  return build_json_tweets($redis.lrange($globalTL, 0, 50)) unless params[:id] != "recent"
  tweet = Tweet.where(_id: params[:id]).first
  if tweet
    tweet.to_json
  else
    error 404, { :error => "Tweet #{:id} not found." }.to_json
  end
end

# Posts a new tweet
post "/api/v1/:apitoken/tweets/new" do
  user = get_user("handle", params[:apitoken])
  return nil unless user != nil

  @hashtag_list = Array.new
  
  # Build Tweet content
  params[:tweet][:author_id] = user._id
  params[:tweet][:author_handle] = user.handle
  params[:tweet][:content] = generateHashtagTweet(params[:tweet][:content])
  params[:tweet][:content] = generateMentionTweet(params[:tweet][:content])
  tweet = Tweet.new(params[:tweet])
  return nil unless tweet.save

  # Build worker
  tweet_id = tweet._id
  login_user_id = user._id
  TweetMongoWorker.perform_async(login_user_id.to_s, tweet_id.to_s)
  
  # update redis
  user.add_tweet(tweet_id)
  save_user_to_redis(user)

  # spread this tweet to all followers
  followers = user.followeds
  followers.each do |follower|
    $redis.lpush(follower.to_s, tweet_id)
    if $redis.llen(follower.to_s) > 50
      $redis.rpop(follower.to_s)
    end
  end

  # save this tweet in global timeline
  $redis.lpush($globalTL, tweet._id.to_s)
  if $redis.llen($globalTL) > 50
    $redis.rpop($globalTL)
  end

  # store the hashtag
  @hashtag_list.each do |hashtag_name| 
    if Hashtag.exists? && Hashtag.where(hashtag_name: hashtag_name).exists?
      hashtag = Hashtag.where(hashtag_name: hashtag_name).first
      hashtag.add_tweet(tweet_id) 
    else
      tweets = Set.new
      tweets.add(tweet_id)
      Hashtag.where(hashtag_name: hashtag_name, tweets: tweets).create
    end
  end

  if tweet
    tweet.to_json
  else
    error 404, { :error => "Tweet not created." }.to_json
  end
end

# Reply to a tweet with the id :tweet_id
post "/api/v1/:apitoken/tweets/:tweet_id/reply" do
  user = get_user("handle", params[:apitoken])

  return nil unless user != nil
  
  @hashtag_list = Array.new

  # create reply
  params[:reply][:tweet_id] = params[:tweet_id]
  params[:reply][:replier_id] = user._id
  params[:reply][:replier_handle] = user.handle
  params[:reply][:content] = generateHashtagTweet(params[:reply][:content])
  params[:reply][:content] = generateMentionTweet(params[:reply][:content])
  reply = Reply.new(params[:reply])
  return nil unless reply.save

  # update corresponding tweet
  tweet_id = params[:tweet_id]
  tweet = Tweet.where(_id: tweet_id).first

  # add reply id to replies
  tweet.add_reply(reply[:_id])

  # store the hashtag
  @hashtag_list.each do |hashtag_name| 
    if Hashtag.exists? && Hashtag.where(hashtag_name: hashtag_name).exists?
      hashtag = Hashtag.where(hashtag_name: hashtag_name).first
      hashtag.add_tweet(tweet_id) 
    else
      tweets = Set.new
      tweets.add(tweet_id)
      Hashtag.where(hashtag_name: hashtag_name, tweets: tweets).create
    end
  end
  
  if reply
    reply.to_json
  else
    error 404, { :error => "Reply not created." }.to_json
  end  
end

# Retweets a tweet with id params[:tweet_id]
post "/api/v1/:apitoken/tweets/:tweet_id/retweet" do
  user = get_user("handle", params[:apitoken])
  return nil unless user != nil
  
  @hashtag_list = Array.new

  # create retweet tweet
  author_id = user._id
  # author_handle = get_user_from_session.handle
  author_handle = user.handle
  original_tweet_id = BSON::ObjectId.from_string(params[:tweet_id])
  content = generateHashtagTweet(params[:retweet][:content])
  content = generateMentionTweet(params[:retweet][:content])
  retweet = Tweet.new(author_id: author_id, original_tweet_id: original_tweet_id, author_handle: author_handle, content: content)

  return nil unless retweet.save

  user.add_tweet(retweet._id)
  save_user_to_redis(user)

  # spread this tweet to all followers
  followers = user.followeds
  followers.each do |follower|
    $redis.lpush(follower.to_s, retweet._id)
    if $redis.llen(follower.to_s) > 50
      $redis.rpop(follower.to_s)
    end
  end

  # save this tweet in global timeline
  $redis.lpush($globalTL, tweet._id.to_s)
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
  
  if retweet
    retweet.to_json
  else
    error 404, { :error => "Retweet not created." }.to_json
  end    
end

# json formatter for returning multiple tweets from api calls
def build_json_tweets(tweet_ids)
  hash = Hash.new
  count = 1
  tweets = Tweet.in(_id: tweet_ids)
  tweets.each do |tweet|
    tweet = tweet.to_json unless tweet.class != Tweet    
    hash["#{count}"] = JSON.parse(tweet)
    count += 1
  end
  hash.to_json
end
