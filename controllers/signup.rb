get '/signup' do
  erb :signup, :locals => { :title => 'Signup' }
end

post '/signup/submit' do
  byebug
  today = Date.today.strftime("%B %Y")
  profile_hash = {
    :bio => "",
    :dob => "",
    :date_joined => today,
    :location => "",
    :name => ""
  }
  @profile = Profile.new(profile_hash)
  params[:user][:profile] = @profile

  # Build the user's account
  @user = User.new(params[:user])
  if @user.save
    redirect '/login'
  else
    flash[:notice] = 'Signup failed, please try again!'
    redirect '/signup'
  end
end
