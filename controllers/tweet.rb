post '/tweet/new' do
  @hashtag_list = Array.new

  user_id = session[:user_id]
  params[:tweet][:author_id] = user_id
  params[:tweet][:author_handle] = get_user_from_session.handle
  params[:tweet][:content] = generateHashtagTweet(params[:tweet][:content])
  params[:tweet][:content] = generateMentionTweet(params[:tweet][:content])
  tweet = Tweet.new(params[:tweet])
  if tweet.save
    user = User.where(_id: user_id).first
    tweet_id = tweet._id
    user.add_tweet(tweet_id)

    # spread this tweet to all followers
    followers = user.followeds
    followers.each do |follower|
      $redis.rpush(follower.to_s, tweet_id)
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
  end
end

get '/tweets' do
  @tweets = Tweet.all
  erb :tweets, :locals => { :title => 'Tweets' }
end

get '/tweet/:tweet_id' do
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
    
    erb :tweet, :locals => { :title => 'Tweet' }
  else
    flash[:warning] = 'Can not find tweet!'
  end
end

def generateHashtagTweet(content)
  content.gsub!(/#\S+/) { |match|
    hashtag_name = match[1..-1]
    @hashtag_list.push(hashtag_name)
    match = "<a href=\"\\search\\hashtag?query=" + hashtag_name + "\">" + match + "</a>"
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
    user_link = "<a href=\"\\user" + "\\\\" + map[match] + "\">" + match + "</a>"
    content.gsub!(match, user_link)
  end

  return content
  
end

