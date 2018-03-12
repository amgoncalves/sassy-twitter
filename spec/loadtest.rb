# coding: utf-8
require 'mongoid'
require 'mongo'
require 'sinatra'
require 'sinatra/flash'
require 'erb'
require 'time'
require 'csv'
require_relative '../models/user'
require_relative '../models/tweet'
require_relative '../models/reply'
require 'byebug'

Mongoid::Config.connect_to('nanotwitter-loadtest')

# set :session_secret, 'secret'
# enable :sessions
use Rack::Session::Cookie, :key => 'rack.session',
                           :path => '/',
                           :secret => 'secret'

# delete everything and recreate test uesr
post '/test/reset/all' do
  # delete everything
  Mongoid.purge!
  #create test user
  user = User.create(handle: "testuser", 
    email: "testuser@sample.com", 
    password: "password")
  # store TestUser in session
  session[:testuser] = user
end

# delete and recreate TestUser
post '/test/reset/testuser' do
  user = session[:testuser]
  # remove the following relationship of followed users
  user.followed.each do |followed_id|
    followed_user = User.findById(followed_id)
    followed_user.release_following(user._id)
  end

  # remove the followed relationship of following users
  user.following.each do |following_id|
    following_user = User.findById(following_id)
    following_user.release_followed(user_id)
  end

  # remove all liked relationship from liked tweets
  user.liked.each do |liked_id|
    liked_tweet = Tweet.findById(liked_id)
    liked_tweet.delete_like(user_id)
  end

  # remove all tweets of this user
  Tweet.in(_id: user.tweets).delete
  # delete TestUser
  User.where(_id: user._id).delete

  # recreate new TestUser
  user = User.create(handle: "testuser", 
    email: "testuser@sample.com", 
    password: "password")
  # renew TestUser in session
  session[:testuser] = user

end

# One page “report” of collections status
get '/test/status' do
  # How many users and follows
  user_num = 0
  follow_num = 0
  if User.exists?
    user_num = User.count
    # extract follow relationship from each user
    User.each do |user|
      follow_num += user.following.length
    end
  end
  # How many tweets
  tweet_num = 0
  if Tweet.exists? 
    tweet_num = Tweet.count
  end

  erb "User Number: #{user_num}<br>
        Follow Number: #{follow_num}<br>
        Tweet Number: #{tweet_num}"
end

# display version number of this build
get '/test/version' do
  erb "Sorry! Version related function not impelemented yet."
end

# reset the database by deleting all users, tweets and follows
# recreate TestUser
# load n tweets from seed data if tweets parameter exists
# otherwise load all tweets from seed data
post '/test/reset/standard' do
  starttime = Time.now

  # reset database and delete everything
  Mongoid.purge!
  # Recreate TestUser
  user = User.create(handle: "testuser", 
    email: "testuser@sample.com", 
    password: "password")
  session[:testuser] = user

  # load all users
  # CSV.foreach('../seeds/users.csv') do |row|
  if session[:map] == nil
    session[:map] = Hash.new
  end
  if session[:user] == nil
    session[:user] = Array.new
  end
  user_text = File.read('../seeds/users.csv')
  user_csv = CSV.parse(user_text, :headers => false)
  user_csv.each do |row|
    if row.size == 2
      id = row[0]
      handle = row[1]
      new_user = User.create(handle: handle,
        email: "testuser#{id}@sample.com",
        password: "password")
      session[:map][id] = new_user._id
      session[:user].push(new_user._id)
    end
  end

  # load tweets from seeds
  n = 100175
  i = 0
  if params.has_key?("tweets")
    n = params[:tweets].to_i
  end

  # CSV.foreach('../seeds/tweets.csv') do |row|
  tweets_text = File.read('../seeds/tweets.csv')
  tweets_csv = CSV.parse(tweets_text, :headers => false)
  tweets_csv.each do |row|
    if i >= n then break end
    if row.size == 3
      # obtain the author
      author_id = session[:map][row[0]]
      author = User.where(_id: author_id).first
      # create new tweet
      content = row[1]
      time_created = Time.parse(row[2])
      tweet = Tweet.create(author_id: author_id,
        content: content,
        time_created: time_created)
      # add tweet under user
      author.add_tweet(tweet._id)
    end
    i = i + 1
  end

  endtime = Time.now
  erb "process time: #{endtime - starttime} seconds"
end

# create u (integer) fake Users using faker. Defaults to 1
post '/test/users/create' do
  starttime = Time.now
  user_count = 1
  tweets_count = 0

  if params.has_key(count)
    user_count = params[:count] 
  end

  if params.has_key(tweets) 
    tweets_count = params[:tweets] 
  end

  # for i users, each user create j tweets
  i = 0
  while i < user_count.to_i do
    user = User.create(handle: "testuser#{i}", 
      email: "testuser#{i}@sample.com",
      password: "password#{i}")
    j = 0
    while j < tweets_count.to_i do
      tweet = Tweet.create(content: "no.#{j} tweet")
      tweet.author_id = user._id
      user.add_tweet(tweet._id)
      j = j + 1
    end
    i = i + 1
  end
  endtime = Time.now

  erb "Created #{count} users<br>
  For each user created #{tweets} tweets<br><br>
  Total processing time: #{endtime - starttime} second"

end

# user u generates t(integer) new fake tweets
# if u=”testuser” then this refers to the TestUser
post "/test/user/:user/tweets" do
  # obtain the user
  user = nil
  if params[:user] == "testuser"
    user = session[:testuser]
  else
    user_id = session[:map][user.to_i]
    user = User.where(_id: user_id).first
  end

  # create t tweets for this user
  tweets_count = params[:count]
  i = 0
  while i < tweets_count.to_i do
    tweet = Tweet.create(content: "no.#{i} fake tweet")
    tweet.author_id = user._id
    user.add_tweet(tweet._id)
    i = i + 1
  end

end

# n (integer) randomly selected users follow user u (integer)
# if u=”testuser” then this refers to the TestUser
post "/test/user/:user/follow" do
  user = nil
  if params[:user] == "testuser"
    user = session[:testuser]
  else
    user_id = session[:map][user.to_i]
    user = User.where(_id: user_id).first
  end

  # select n randomly followeds of this user
  n = params[:count]
  followed_list = user.followed
  random_list = followed_list.sample(n.to_i)

  # show the result
  erb "For user<br>
        handle: #{user.handle}<br>
        #{random_list.join(",")}"
end

# n (integer) randomly selected users follow 
# ‘n’ (integer) different randomly seleted users.
post "/test/user/follow" do 
  n = params[:count].to_i
  users = params[:users]

  users.sample(n).each do |user_id|
    user = User.where(_id: user_id).first
    tmp_users = users
    tmp_users.delete(user_id)
    tmp_users.sample(n).each do |following_id|  
      following_user = User.where(_id: following_id).first
      user.toggle_following(following_id)
      following_user.toggle_followed(user_id)
    end
  end
end

