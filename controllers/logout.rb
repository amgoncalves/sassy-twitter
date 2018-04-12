post $prefix + "/:handle/logout" do
	# redis_login_user = get_user_from_redis
	# db_login_user = User.where(_id: redis_login_user._id).first
	# db_login_user.update_user(redis_login_user)
	del_user_from_redis
  session.clear
  cookies.clear
  flash[:notice] = 'You have been signed out.  Goodbye!'
  @apitoken = ""
  redirect $prefix + "/"
end
