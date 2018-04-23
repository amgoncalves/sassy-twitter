class TweetMongoWorker 
  require_relative './user.rb'
  include Sidekiq::Worker

  def perform(login_user_id, tweet_id, redis_login_user)
    login_user_id = BSON::ObjectId.from_string(login_user_id)
    user_id = BSON::ObjectId.from_string(tweet_id)
    db_login_user = User.where(_id: login_user_id).first
    db_login_user.add_tweet(tweet_id)
    db_login_user

    # update redis
    redis_login_user.add_tweet(tweet_id)
    save_user_to_redis(redis_login_user)
  end
end

post "/tweet/new" do
  if !is_authenticated?
    redirect "/"
  end

  @hashtag_list = Array.new

  # get the current login user
  redis_login_user = get_user_from_redis

  params[:tweet][:author_id] = redis_login_user._id
  params[:tweet][:author_handle] = redis_login_user.handle
  params[:tweet][:content] = generateHashtagTweet(params[:tweet][:content])
  params[:tweet][:content] = generateMentionTweet(params[:tweet][:content])
  tweet = Tweet.new(params[:tweet])
  if tweet.save

    tweet_id = tweet._id
    login_user_id = redis_login_user._id

    # update db
    # db_login_user = User.where(_id: login_user_id).first
    # db_login_user.add_tweet(tweet_id)
    #
    TweetMongoWorker.perform_async(login_user_id.to_s, tweet_id.to_s)
    # update redis
    redis_login_user.add_tweet(tweet_id)
    save_user_to_redis(redis_login_user)

    # spread this tweet to all followers
    # followers = db_login_user.followeds
		followers = redis_login_user.followeds
    followers.each do |follower|
      $redis.rpush(follower.to_s, tweet_id)
      if $redis.llen(follower.to_s) > 50
        $redis.rpop(follower.to_s)
      end
    end

    # save this tweet in global timeline
    $redis.rpush($globalTL, tweet.to_json)
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
    redirect back
  else
    flash[:warning] = 'Create tweet failed'
    redirect back
  end
end

get '/tweets' do
  @tweets = Tweet.all
  erb :tweets
end

get "/tweet/:tweet_id" do  
  present = Tweet.where(_id: params[:tweet_id]).exists?

  if present
    @tweet = Tweet.where(_id: params[:tweet_id]).first
    @replys = Array.new

    if @tweet[:replys].length > 0
      @replys = Reply.in(_id: @tweet[:replys])
    end

    if @tweet[:original_tweet_id] != nil
      @ot = Tweet.find(@tweet[:original_tweet_id])
    end
    
    erb :tweet
  else
    flash[:warning] = 'Can not find tweet!'
    redirect back
  end
end

get "/tweet/:tweet_id" do
  if !is_authenticated?
    redirect "/"
  end
  
  present = Tweet.where(_id: params[:tweet_id]).exists?

  if present
    @tweet = Tweet.where(_id: params[:tweet_id]).first
    @replys = Array.new

    if @tweet[:replys].length > 0
      @replys = Reply.in(_id: @tweet[:replys])
    end

    if @tweet[:original_tweet_id] != nil
      @ot = Tweet.find(@tweet[:original_tweet_id])
    end
    
    erb :tweet
  else
    flash[:warning] = 'Can not find tweet!'
    redirect back
  end
end

post '/user/testuser/tweet' do
  @hashtag_list = Array.new
  @apitoken = "/"

  redis_login_user = $redis.get("testuser")
  if redis_login_user != nil
    user_hash = JSON.parse($redis.get("testuser"))
    profile_hash = user_hash["profile"]
    profile = Profile.new(profile_hash)
    user_hash["profile"] = profile
    redis_login_user = User.new(user_hash)
  else
    redis_login_user = User.where(handle: "testuser").first
  end

  t = Hash.new
  t[:author_id] = redis_login_user._id
  t[:author_handle] = "testuser"
  if params[:tweet] == nil
    t[:content] = "test tweet by testuser"
  else 
    t[:content] = params[:tweet]
  end
  # t[:content] = generateHashtagTweet(t[:content])
  # t[:content] = generateMentionTweet(t[:content])
  tweet = Tweet.new(t)
  if tweet.save
    tweet_id = tweet._id
    login_user_id = redis_login_user._id

    # update db
    # db_login_user = User.where(_id: login_user_id).first
    # db_login_user.add_tweet(tweet_id)
    TweetMongoWorker.perform_async(login_user_id.to_s, tweet_id.to_s, redis_login_user)
    
    # # update redis
    # redis_login_user.add_tweet(tweet_id)
    # save_user_to_redis(redis_login_user)

    # save this tweet in global timeline
    globalTL_len = $redis.rpush($globalTL, tweet.to_json)
    if globalTL_len > 50
      $redis.rpop($globalTL)
    end

    # spread this tweet to all followers
    # followers = db_login_user.followeds
    followers = redis_login_user.followeds
    followers.each do |follower|
      personalTL_len = $redis.rpush(follower.to_s, tweet_id)
      if personalTL_len > 50
        $redis.rpop(follower.to_s)
      end
    end

    # store the hashtag
    # @hashtag_list.each do |hashtag_name| 
    #   if Hashtag.exists? && Hashtag.where(hashtag_name: hashtag_name).exists?
    #     hashtag = Hashtag.where(hashtag_name: hashtag_name).first
    #     hashtag.add_tweet(tweet_id) 
    #   else
    #     tweets = Set.new
    #     tweets.add(tweet_id)
    #     Hashtag.where(hashtag_name: hashtag_name, tweets: tweets).create
    #   end
    # end
  else
    flash[:warning] = 'Create tweet failed'
    # redirect back
  end
end


def generateHashtagTweet(content)
  content.gsub!(/#\S+/) { |match|
    hashtag_name = match[1..-1]
    @hashtag_list.push(hashtag_name)
    match = "<a href=/search/hashtag?query=" + hashtag_name + ">" + match + "</a>"
  }
  return content
end

def generateMentionTweet(content)
  map = Hash.new
  content.gsub(/@\S+/) { |match|
    user_handle = match[1..-1]
    if User.where(handle: user_handle).exists?
      user = User.where(handle: user_handle).first
      map[match] = user._id.to_s
    end
  }

  map.keys.each do |match|
    user_link = "<a href=/user/" + map[match] + ">" + match + "</a>"
    content.gsub!(match, user_link)
  end

  return content
  
end

