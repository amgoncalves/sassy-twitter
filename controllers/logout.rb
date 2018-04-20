post "/logout" do
  del_user_from_redis
  session.clear
  cookies.clear
  flash[:notice] = 'You have been signed out.  Goodbye!'
  redirect "/"
end
