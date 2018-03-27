get '/user/followeds/' do
  targeted_id = BSON::ObjectId.from_string(params[:targeted_id])
	query_res = User.where(_id: targeted_id)
	target_exist = query_res.exists?
	@info = Hash.new

  if target_exist
		login_user = session[:user]
		target_user = query_res.first
		target_followeds = Array.new
		isfollowing = login_user.follow?(target_user)
		if target_user.nfolloweds > 0 
			target_followeds = User.in(_id: target_user[:followeds])
		end
		@info[:login_user] = login_user
		@info[:target_user] = target_user
		@info[:isfollowing] = isfollowing
		@info[:target_followeds] = target_followeds
    erb :followeds, :locals => {:title => 'Followeds' }
	end
end
