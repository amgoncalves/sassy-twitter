post $prefix + "/:handle/reply" do
  if is_authenticated? == false || session[:user_id] == nil
    redirect $prefix + "/"
  end

  @hashtag_list = Array.new
  @apitoken = "/" + params[:handle]

  # create reply
  params[:reply][:tweet_id] = params[:tweet_id]
  params[:reply][:replier_id] = session[:user_id]
  params[:reply][:replier_handle] = get_user_from_redis[:handle]
  params[:reply][:content] = generateHashtagTweet(params[:reply][:content], @apitoken)
  params[:reply][:content] = generateMentionTweet(params[:reply][:content], @apitoken)
  reply = Reply.new(params[:reply])

  if reply.save
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
    
    redirect $prefix + @apitoken + "/tweet/#{tweet_id}"
    
  else 
    puts "save failed"
    flash[:warning] = 'Create reply failed'
  end
end

get $prefix + "/:handle/reply" do
  if is_authenticated? == false || session[:user_id] == nil
    redirect $prefix + "/"
  end
  
  @t = Tweet.find(params[:tweet_id])
  @apitoken = "/" + params[:handle]
  @cur_user = get_user_from_redis
  erb :reply, :locals => { :title => 'Reply' }
end

