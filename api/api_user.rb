get "/api/v2/:apitoken/users/:key" do
  user = nil
  if params[:input_type] == "id"
    user = User.where(_id: params[:key]).first
  elsif params[:input_type] == "handle"
    user = User.where(handle: params[:key]).first
  end    
  if user
    user.to_json(:except => :password_hash)
  else
    error 404, { :error => "User #{:key} not found." }.to_json
  end
end
