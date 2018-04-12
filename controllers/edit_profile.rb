get $prefix + "/:apitoken/edit_profile" do
  @apitoken = "/" + params[:apitoken]
  erb :edit_profile, :locals=>{:title=>'Edit profile'}
end

post $prefix + "/:apitoken/edit_profile/submit" do
	# params[:profile][:dob] = Date.strptime(params[:profile][:dob],"%Y-%m-%d").to_s
  
  loginuser_redis_key = session[:user_id].to_s + "loginuser"

  if params[:profile][:dob] == ""
    params[:profile][:dob] = ""
  else
    dob_date = Date.strptime(params[:profile][:dob],"%Y-%m-%d")
    params[:profile][:dob] = dob_date.strftime("%B %d, %Y")
  end

  user_id = session[:user_id]
  # user = User.where(_id: user_id).first
	
	user_hash = JSON.parse($redis.get(loginuser_redis_key))
	params[:profile][:date_joined] = user_hash["profile"]["date_joined"]
	@profile = Profile.new(params[:profile])
	User.where(_id: user_id).update(profile: @profile)

	user_hash["profile"] = @profile
	$redis.set(loginuser_redis_key, user_hash.to_json)

  # user.update_profile(@profile)

  @apitoken = "/" + params[:apitoken]
  redirect $prefix + @apitoken + "/user/#{user_id}"
end
