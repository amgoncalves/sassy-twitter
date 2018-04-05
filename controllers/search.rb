post '/search' do
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
  # get_targeted_user
  @info = Hash.new
  @info[:target_user] = get_user_from_session
  erb :results, :locals => { :title => 'Search Results' }
end

get '/search/hashtag' do
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
  # @tweet_results = Tweet.search(params[:query]) unless params[:query].blank?

  # get_targeted_user
  @info = Hash.new
  @info[:target_user] = get_user_from_session
  erb :results, :locals => { :title => 'Search Results' }
end
