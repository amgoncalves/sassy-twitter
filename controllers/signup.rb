get '/signup' do
  erb :signup, :locals => { :title => 'Signup' }
end

post '/signup/submit' do
  # Build the user's profile
  today = Date.today
	dob = Date.jd(0)
  # today = Date.today
  # @profile = Profile.new("", dob, today, "", "")
	profile_hash = {:bio => "", :dob => dob, :date_joined => today, :location => "", :name => ""}
	@profile = Profile.new(profile_hash)
  params[:user][:profile] = @profile

  # Build the user's account
  @user = User.new(params[:user])
  if @user.save
    redirect '/login'
  else
    flash[:notice] = 'Signup failed.'
  end
end
