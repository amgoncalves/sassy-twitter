get '/posted' do
  user_id = session[:user]._id
  user = User.where(_id: user_id).first
  posted_ids = user.tweets
  if posted_ids.length > 50
    posted_ids = posted_ids[-50..-1]
  end
  if posted_ids.length > 0
    @posted_tweets = Tweet.in(_id: posted_ids)
  end
  erb :posted
end

get '/users' do
  authenticate!
  @name = session[:user]
  @users = User.all
  erb :users, :locals => { :title => 'All Users' }
end

