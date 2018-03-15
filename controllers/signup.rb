get '/signup' do
  erb :signup, :locals => { :title => 'Signup' }
end

post '/signup/submit' do
  # Build the user's profile
  today = Date.today.to_s
  # today = Date.today
  @profile = Profile.new("", "", today, "", "")
  params[:user][:profile] = @profile

  # Build the user's account
  @user = User.new(params[:user])
  if @user.save
    redirect '/login'
  else
    flash[:notice] = 'Signup failed.'
  end
end
