get '/loadtest/search' do
  erb :search_form, :locals => { :title => 'Search Load Test'  }
end

post '/loadtest/search' do
  query = 'lorem'

  target_user = get_user_from_redis
  if target_user == nil
    redirect "/login"
  end

  @hide_tweets = false
  @hide_users = false
  @user_results = Array.new
  @tweet_results = Tweet.search(params[:query])
  
  @info = Hash.new
  @info[:target_user] = target_user
  @info[:login_user] = target_user

  erb :results, :locals => { :title => 'Search Results' }  
end
