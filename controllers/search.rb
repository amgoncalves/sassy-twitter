post "/search" do
  if !is_authenticated?
    redirect "/"
  end

  target_user = get_user_from_redis
  if target_user == nil
    redirect "/login"
  end

  @hide_tweets = false
  @hide_users = false
  @user_results = Array.new
  @tweet_results = Array.new
  if params[:searchRadioOptions] == "user"
    @hide_tweets = true
    @user_results = User.search(params[:query]) unless params[:query].blank?
  elsif params[:searchRadioOptions] == "tweet"
    @hide_users = true
    @tweet_results = Tweet.search(params[:query]) unless params[:query].blank?
  else
    @user_results = User.search(params[:query]) unless params[:query].blank?
    @tweet_results = Tweet.search(params[:query]) unless params[:query].blank?
  end
  @info = Hash.new

  @info[:target_user] = target_user
  @info[:login_user] = target_user
  @cur_user = target_user

  erb :results
end

get "/search/hashtag" do
  if !is_authenticated?
    redirect "/"
  end
  
  @hide_tweets = false
  @hide_users = true
  @user_results = Array.new
  @tweet_results = Array.new
  hashtag_name = params[:query]

  if Hashtag.exists? && Hashtag.where(hashtag_name: hashtag_name) 
    hashtag = Hashtag.find_by(hashtag_name: hashtag_name)
    tweets = hashtag[:tweets]
    @tweet_results = Tweet.in(_id: tweets)
  end

  @info = Hash.new

  @info[:target_user] = get_user_from_redis
  @cur_user = @info[:target_user]
  @info[:login_user] = @info[:target_user]

  erb :results
end
