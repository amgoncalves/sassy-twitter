post '/loadtest/reply/prepare' do
  # preapre 100 fake user
  i = 0
  while i < 100 do
    if User.where(_id: i.to_s).exists?
      User.where(_id: i.to_s).delete
    end

    if User.where(handle: "test#{i}").exists?
      User.where(handle: "test#{i}").delete
    end

    profile_hash = {:bio => "", :dob => Date.jd(0), :date_joined => Date.today, :location => "", :name => ""}
    profile = Profile.new(profile_hash)
    uhash = Hash.new
    uhash[:handle] = "test#{i}"
    uhash[:email] = "test#{i}@test"
    uhash[:password] = "password#{i}"
    uhash[:profile] = profile
    
    user = User.new(uhash)
    user.save
    
    i = i +1
  end

  # prepare 100 fake tweet
  i = 0
  while i < 100 do
    thash = Hash.new
    thash[:id] = i.to_s
    thash[:author_id] = i.to_s
    thash[:author_handle] = "test#{i}"
    thash[:content] = "test tweet #{i}"
    tweet = Tweet.new(thash)
    if tweet.save
      puts "tweet#{i} saved"
      user = User.where(handle: "test#{i}").first
      user.add_tweet(tweet._id)
    end
    i = i + 1
  end
end

post '/loadtest/reply' do 
  @hashtag_list = Array.new

  # create reply
  rhash = Hash.new
  replier_id = rand(100).to_s
  rhash[:tweet_id] = rand(100).to_s
  rhash[:replier_id] = replier_id
  rhash[:replier_handle] = "test#{replier_id}"
  if params[:reply] == nil
    rhash[:content] = "reply#{replier_id}"
  else
    rhash[:content] = params[:reply]
  end
  rhash[:content] = generateHashtagTweet(rhash[:content])
  rhash[:content] = generateMentionTweet(rhash[:content])
  reply = Reply.new(rhash)

  if reply.save
    # update corresponding tweet
    tweet_id = rhash[:tweet_id]
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