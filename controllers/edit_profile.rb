get '/edit_profile' do
  erb :edit_profile, :locals=>{:title=>'Edit profile'}
end

post '/edit_profile/submit' do
	# params[:profile][:dob] = Date.strptime(params[:profile][:dob],"%Y-%m-%d").to_s
	dob_date = Date.strptime(params[:profile][:dob],"%Y-%m-%d")
	params[:profile][:dob] = dob_date.strftime("%B %d, %Y")
  user_id = session[:user_id]
  # user = User.where(_id: user_id).first
	
	user_hash = JSON.parse($redis.get($currentUser))
	params[:profile][:date_joined] = user_hash["profile"]["date_joined"]
	@profile = Profile.new(params[:profile])
	User.where(_id: user_id).update(profile: @profile)

	user_hash["profile"] = @profile
	$redis.set($currentUser, user_hash.to_json)

  # user.update_profile(@profile)

  redirect "/user/#{user_id}"
end
