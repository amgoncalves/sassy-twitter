# Searches for users with given keywords in params[:query]
post "/api/v1/:apitoken/search/users" do
  results = User.search(params[:query])
  if results
    return results.to_json
  else
    error 404, { :error => "No users found for #{params[:query]}." }.to_json
  end
end

# Searches for tweets with given keywords in params[:query]
post "/api/v1/:apitoken/search/tweets" do
  results = Tweet.search(params[:query])
  if results
    return results.to_json
  else
    error 404, { :error => "No tweets found for #{params[:query]}." }.to_json
  end
end
