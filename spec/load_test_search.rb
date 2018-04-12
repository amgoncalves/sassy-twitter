get '/loadtest/search' do
  @apitoken = "/mcurie" # alyssa's test user
  erb :search_form, :locals => { :title => 'Search Load Test'  }
end

post '/loadtest/search' do
  query = 'lorem'

  target_user = get_user_from_redis
  if target_user == nil
    redirect $prefix + "/login"
  end

  @hide_tweets = false
  @hide_users = false
  @user_results = Array.new
  @tweet_results = Tweet.search(params[:query])
  
  @info = Hash.new
  @apitoken = "/" + params[:handle]
  @info[:target_user] = target_user
  @info[:login_user] = target_user

  erb :results, :locals => { :title => 'Search Results' }  
end
