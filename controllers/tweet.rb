post '/tweet/new' do
  user_id = session[:user]._id
  params[:tweet][:author_id] = user_id
  params[:tweet][:author_handle] = session[:user].handle
  tweet = Tweet.new(params[:tweet])
  if tweet.save
    user = User.where(_id: user_id).first
    tweet_id = tweet._id
    user.add_tweet(tweet_id)

    # spread this tweet to all followers
    followers = user.followed
    followers.each do |follower|
      $redis.rpush(follower.to_s, tweet_id)
    end

    # save this tweet in global timeline
    $redis.rpush($globalTL, tweet_id)
    if $redis.llen($globalTL) > 50
      $redis.rpop($globalTL)
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

