post '/loadtest/follow' do
	target_id = BSON::ObjectId.from_string(params[:targeted_id])
	target_user = User.where(_id: target_id).first

	login_id = BSON::ObjectId.from_string(params[:login_id])
	db_login_user = User.where(_id: target_id).first

	db_login_user.toggle_following(target_id)
	target_user.toggle_followed(login_id)

end
