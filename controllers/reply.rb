post '/reply' do
  # create reply
  params[:reply][:tweet_id] = params[:tweet_id]
  reply = Reply.new(params[:reply])

  if reply.save
    # update corresponding tweet
    tweet_id = params[:tweet_id]
    tweet = Tweet.where(_id: tweet_id).first

    # add reply id to replies
    tweet.add_reply(reply[:_id])

    redirect "/tweet/#{tweet_id}"
    
  else 
    puts "save failed"
    flash[:warning] = 'Create reply failed'
  end
end

