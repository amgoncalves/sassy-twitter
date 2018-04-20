get "/api/v2/:apitoken/user/:handle" do
  user = User.where(handle: params[:handle]).first
  if user
    user.to_json(:except => :password_hash)
  else
    error 404, {:error => "user not found"}.to_json
  end
end
