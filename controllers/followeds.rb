get '/user/followeds/' do
  @targeted_id = BSON::ObjectId.from_string(params[:targeted_id])
  present = User.where(_id: @targeted_id).exists?

  if present
    cur_user_id = session[:user]._id
    @cur_user = User.where(_id: cur_user_id).first
    @targeted_user = User.where(_id: @targeted_id).first
    # @targeted_tweets = Array.new
    @targeted_followed = Array.new
    # @targeted_following = Array.new
    # @targeted_liked = Array.new

    @isfollowing = @cur_user.follow?(@targeted_id)
    @ntweets = @targeted_user[:tweets].length
    # if @ntweets > 0
    # 	@targeted_tweets = Tweet.in(_id: @targeted_user[:tweets])
    # end

    @nfollowed = @targeted_user[:followed].length
    if @nfollowed > 0
      @targeted_followed = User.in(_id: @targeted_user[:followed])
    end

    @nfollowing = @targeted_user[:following].length
    # if @nfollowing > 0
    # 	@targeted_following = User.in(_id: @targeted_user[:following])
    # end

    # erb :user, :locals => { :title => 'User Profile' }
    erb :followeds, :layout => false, :locals => { :title => 'User Profile' }
  end
end
