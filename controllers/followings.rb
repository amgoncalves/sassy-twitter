get $prefix + "/:apitoken/user/followings/" do
  targeted_id = BSON::ObjectId.from_string(params[:targeted_id])
	query_res = User.where(_id: targeted_id)
	target_exist = query_res.exists?
	@info = Hash.new

  if target_exist
		login_user = get_user_from_redis
		# login_user = get_user_from_mongo
		target_user = query_res.first
		target_followings = Array.new
		isfollowing = login_user.follow?(target_user)
		if target_user.nfollowings > 0 
			target_followings = User.in(_id: target_user[:followings])
		end
		@info[:login_user] = login_user
		@info[:target_user] = target_user
		@info[:isfollowing] = isfollowing
		@info[:target_followings] = target_followings
    @apitoken = "/" + login_user.APItoken
    erb :followings, :locals => { :title => 'Followings' }
	end
end
