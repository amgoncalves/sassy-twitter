get $prefix + "/signup" do
  erb :signup, :locals => { :title => 'Signup' }
end

post $prefix + "/signup/submit" do
  # Build the user's profile
  # today = Date.today.to_s
	today = Date.today.strftime("%B %Y")
	# dob = Date.jd(0).to_s
	dob = "";
  # today = Date.today
  # @profile = Profile.new("", dob, today, "", "")
	profile_hash = {:bio => "", :dob => dob, :date_joined => today, :location => "", :name => ""}
	@profile = Profile.new(profile_hash)
  params[:user][:profile] = @profile

  # Build the user's account
  @user = User.new(params[:user])
  if @user.save
    redirect $prefix + "/login"
  else
    flash[:notice] = 'Signup failed, please try again!'
    redirect $prefix + "/signup"
  end
end
