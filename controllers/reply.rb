post '/reply' do
  @hashtag_list = Array.new

  # create reply
  params[:reply][:tweet_id] = params[:tweet_id]
  params[:reply][:replier_id] = session[:user_id]
  params[:reply][:replier_handle] = session[:user].handle
  params[:reply][:content] = generateHashtagTweet(params[:reply][:content])
  params[:reply][:content] = generateMentionTweet(params[:reply][:content])
  reply = Reply.new(params[:reply])
  byebug

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

    redirect "/tweet/#{tweet_id}"
    
  else 
    puts "save failed"
    flash[:warning] = 'Create reply failed'
  end
end

get '/reply' do
  @t = Tweet.find(params[:tweet_id])
  erb :reply, :locals => { :title => 'Reply' }
end

