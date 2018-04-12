get '/signup' do
  erb :signup, :locals => { :title => 'Signup' }
end

post '/signup/submit' do
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
    flash[:danger] = "Signup failed: #{build_fail_msg(params)}"
    redirect '/signup'
  end
end

def build_fail_msg(params)
  msg = Array.new
  msg.push("email is blank") unless params[:email] != nil
  msg.push("handle is blank") unless params[:handle] != nil
  msg.push("password is blank") unless params[:password] != nil
  msg = msg.map { |s| " #{s}," }.join(' ')
  msg.truncate(msg.length - 1)
end
