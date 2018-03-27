get '/edit_profile' do
  erb :edit_profile, :locals=>{:title=>'Edit profile'}
end

post '/edit_profile/submit' do
	params[:profile][:dob] = Date.strptime(params[:profile][:dob],"%Y-%m-%d")
  @profile = Profile.new(params[:profile][:bio], 
			 params[:profile][:dob],
			 params[:profile][:date_joined],
			 params[:profile][:location],
			 params[:profile][:name])
  user_id = session[:user]._id
  user = User.where(_id: user_id).first
  user.update_profile(@profile)
  redirect "/user/#{user_id}"
end
