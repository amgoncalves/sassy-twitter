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
#require 'byebug'

# get the test home page for all test interface
get '/test' do
  Mongoid::Config.connect_to('nanotwitter-loadtest')
  erb :test_interface, :locals => { :title => 'Test Interface' }
end

# delete everything and recreate test uesr
post '/test/reset/all' do
  Mongoid::Config.connect_to('nanotwitter-loadtest')
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
  Mongoid::Config.connect_to('nanotwitter-loadtest')
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
  Mongoid::Config.connect_to('nanotwitter-loadtest')
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

  erb "User Number: #{user_num} <br>
        Follow Number: #{follow_num} <br>
        Tweet Number: #{tweet_num}",
        :locals => { :title => 'Test Interface' }
end

# display version number of this build
get '/test/version' do
  Mongoid::Config.connect_to('nanotwitter-loadtest')
  erb "version: 0.5", :locals => { :title => 'Test Interface' }
end

# reset the database by deleting all users, tweets and follows
# recreate TestUser
# load n tweets from seed data if tweets parameter exists
# otherwise load all tweets from seed data
post '/test/reset/standard' do
  Mongoid::Config.connect_to('nanotwitter-loadtest')
  starttime = Time.now

  # reset database and delete everything
  Mongoid.purge!
  # Recreate TestUser
  user = User.create(handle: "testuser", 
    email: "testuser@sample.com", 
    password: "password")
  session[:testuser] = user

  if session[:map] == nil
    session[:map] = Hash.new
  end

  # load all users
  user_text = File.read("seeds/users.csv")
  user_csv = CSV.parse(user_text, :headers => false)
  user_csv.each do |row|
    if row.size == 2
      id = row[0]
      handle = row[1]
      new_user = User.create(id: id,
        handle: handle,
        email: "#{handle}@sample.com",
        password: "password")
    end
  end

  # load tweets from seeds
  n = 100175
  i = 0
  if params.has_key?("tweets")
    n = params[:tweets].to_i
  end

  # CSV.foreach('../seeds/tweets.csv') do |row|
  tweets_text = File.read("seeds/tweets.csv")
  tweets_csv = CSV.parse(tweets_text, :headers => false)
  tweets_csv.each do |row|
    if i >= n then break end
    if row.size == 3
      # obtain the author
      author_id = row[0]
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
  erb "process time: #{endtime - starttime} seconds",
  :locals => { :title => 'Test Interface' }
end

# create u (integer) fake Users using faker. Defaults to 1
post '/test/users/create' do
  Mongoid::Config.connect_to('nanotwitter-loadtest')
  starttime = Time.now

  user_count = 1
  tweets_count = 0

  if params[:count] != nil
    user_count = params[:count] 
  end

  if params[:tweets] != nil
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
      tweet = Tweet.create(content: "no.#{j} tweet",
        author_id: user._id)
      user.add_tweet(tweet._id)
      j = j + 1
    end
    i = i + 1
  end
  endtime = Time.now

  erb "Created #{user_count} users <br>
  For each user created #{tweets_count} tweets <br><br>
  Total processing time: #{endtime - starttime} second",
  :locals => { :title => 'Test Interface' }

end

# user u generates t(integer) new fake tweets
# if u=”testuser” then this refers to the TestUser
post "/test/user/:user/tweets" do
  Mongoid::Config.connect_to('nanotwitter-loadtest')
  # initialize variables
  user = nil
  tweets_count = 0
  # botain user from database
  if params[:user] == "testuser"
    user = session[:testuser]
  elsif User.where(_id: params[:user]).exists?
    user = User.where(_id: params[:user]).first
  end
  # get tweets creating number 
  if params[:count] != nil
    tweets_count = params[:count].to_i
  end
  # create t tweets for this user
  if user != nil 
    i = 0
    while i < tweets_count.to_i do
      tweet = Tweet.create(content: "no.#{i} fake tweet", author_id: user._id)
      user.add_tweet(tweet._id)
      i = i + 1
    end
  else
    erb "User #{params[:user]} doen't exist in database",
    :locals => { :title => 'Test Interface' }
  end

end

# n (integer) randomly selected users follow 
# ‘n’ (integer) different randomly seleted users.
post '/test/user/follow' do
  Mongoid::Config.connect_to('nanotwitter-loadtest')
  if User.count < 2
    erb "Run post '/test/reset/standard' first!"
  else
    n = 1 # default 1
    if params[:count] != nil
      n = params[:count].to_i
    end
    
    output = ""

    users = (1..1000).to_a
    users.sample(n).each do |user_id|
      user = User.where(_id: user_id.to_s).first
      tmp_users = (1..1000).to_a
      tmp_users.delete(user_id)
      tmp_users.sample(n).each do |following_id| 
        following_user = User.where(_id: following_id.to_s).first
        user.toggle_following(following_id)
        following_user.toggle_followed(user_id)
      end

      output += "For user<br>
      handle: #{user.handle}<br>
      #{user.following.to_a.to_s}<br><br>"
    end
    # show the result
    erb output, :locals => { :title => 'Test Interface' }
  end
end

# n (integer) randomly selected users follow user u (integer)
# if u=”testuser” then this refers to the TestUser
post "/test/user/:user/follow" do
  Mongoid::Config.connect_to('nanotwitter-loadtest')
  # initialize variables
  user = nil
  n = 0
  # botain user from database
  if params[:user] == "testuser"
    user = session[:testuser]
  elsif User.where(_id: params[:user]).exists?
    user = User.where(_id: params[:user]).first
  end
  # get randomly selecting number
  if params[:count] != nil
    n = params[:count].to_i
  end
  # select n randomly users to follow user u
  if user != nil
    # select n randomly followeds of this user
    user_num = User.count
    if User.count < 2
      erb "Run post '/test/reset/standard' first!", :locals => { :title => 'Test Interface' }
    else
      users = (1..1000).to_a
      if params[:user] != "testuser"
        users.delete(params[:users].to_i)
      end
  
      users.sample(n).each do |user_id|
        tmp_user = User.where(id: user_id.to_s).first
        user.toggle_followed(tmp_user._id)
        tmp_user.toggle_following(user._id)
      end
      # show the result
      erb "For user<br>
        handle: #{user.handle}<br>
        #{user.followed.to_a.to_s}"
    end
  else
    erb "User #{params[:user]} doen't exist in database", :locals => { :title => 'Test Interface' }
  end
end


