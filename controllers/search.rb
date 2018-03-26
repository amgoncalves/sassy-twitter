post '/search' do
  @switch = false
  if params[:searchRadioOptions] == "user"
    @switch = true
    @user_results = User.search(params[:query]) unless params[:query].blank?
  elsif params[:searchRadioOptions] == "tweet"
    @tweet_results = Tweet.search(params[:query]) unless params[:query].blank?
  end
  get_targeted_user
  erb :results, :locals => { :title => 'Search Results' }
end
