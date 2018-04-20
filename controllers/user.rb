get "/user/:targeted_id" do
  if !is_authenticated?
    redirect "/"
  end
  
  targeted_id = BSON::ObjectId.from_string(params[:targeted_id])
  query_res = User.where(_id: targeted_id)
  target_exist = query_res.exists?
  @info = Hash.new

  if target_exist
    login_user = get_user_from_redis
    target_user = query_res.first
    isfollowing = login_user.follow?(target_user)
    target_tweets = Array.new

    if target_user.ntweets > 0
      target_tweets = Tweet.in(_id: target_user[:tweets])
      target_tweets = target_tweets.reverse
    end

    @info[:login_user] = login_user
    @info[:target_user] = target_user
    @info[:isfollowing] = isfollowing
    @info[:target_tweets] = target_tweets
    @tweets = @info[:target_tweets]
    set_user_globals

    erb :user, :locals => { :title => "#{target_user.handle}" }
  end
end

# Not used, for testing:
get '/users' do
  authenticate!
  @users = User.all
  erb :users, :locals => { :title => 'All Users' }
end

# get the user page for test user
get '/user/testuser/' do

	if $redis.exists("testuser")
		user_hash = JSON.parse($redis.get("testuser"))
		redis_login_user = User.new(user_hash)
	else
		redis_login_user = User.where(handle: "testuser").first._id.to_s
	end

	login_user_id = redis_login_user._id
	targeted_id = redis_login_user._id

  query_res = User.where(_id: targeted_id)
  target_exist = query_res.exists?

  if target_exist
    # login_user = get_user_from_redis
		login_user = redis_login_user

    target_user = query_res.first
    isfollowing = login_user.follow?(target_user)
    target_tweets = Array.new

    if target_user.ntweets > 0
      target_tweets = Tweet.in(_id: target_user[:tweets])
      target_tweets = target_tweets.reverse
    end
	end
end
