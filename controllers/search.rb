post '/search' do
  @hide_tweets = false
  @hide_users = false
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
  get_targeted_user
  erb :results, :locals => { :title => 'Search Results' }
end
