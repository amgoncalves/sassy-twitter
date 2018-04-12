post '/loadtest/search' do

  # search for tweents containin 1 term
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
