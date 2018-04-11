get "/make/test_user" do
  params[:user][:handle] = "testuser"
  params[:user][:email] = "testuser@sample.com"
  params[:user][:password] = "password"
  query = params.map{|key, value| "#{key}=#{value}"}.join("&")
  redirect to ("/signup/submit?#{query}")
end
