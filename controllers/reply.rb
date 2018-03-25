post '/reply' do
  # create reply
  params[:reply][:tweet_id] = params[:tweet_id]
  params[:reply][:replier_id] = session[:user]._id
  params[:reply][:replier_handle] = session[:user].handle
  reply = Reply.new(params[:reply])
  byebug

  if reply.save
    # update corresponding tweet
    tweet_id = params[:tweet_id]
    tweet = Tweet.where(_id: tweet_id).first

    # add reply id to replies
    tweet.add_reply(reply[:_id])

    redirect back
    
  else 
    puts "save failed"
    flash[:warning] = 'Create reply failed'
  end
end

