# coding: utf-8
require 'byebug'
require 'mongoid'
require 'mongo'
require 'sinatra'
require 'sinatra/flash'
require 'erb'
require 'time'
require 'csv'
require 'sidekiq'
require 'sidekiq/api'
require 'rack-timeout'
require_relative '../models/user'
require_relative '../models/tweet'
require_relative '../models/reply'

class ResetStandard

  def self.perform(params)
    # Mongoid::Config.connect_to('nanotwitter-loadtest')
    starttime = Time.now
    
    # load all users
    user_text = File.read("seeds/users.csv")
    user_csv = CSV.parse(user_text, :headers => false)
    user_csv.each do |row|
      if row.size == 2
        id = row[0]
        handle = row[1]
        today = Date.today.strftime("%B %Y")
        seed_profile_hash = {
          :bio => "",
          :dob => "",
          :date_joined => today,
          :location => "",
          :name => ""
        }
        seed_profile = Profile.new(seed_profile_hash)
        new_user = User.create(
          testid: id,
          handle: handle,
          email: "#{handle}@sample.com",
          password: "password",
          profile: seed_profile)
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
        author = User.where(testid: author_id).first
        # create new tweet
        content = row[1]
        time_created = Time.parse(row[2])
        tweet = Tweet.create(author_id: author._id,
                             author_handle: author.handle,
                             content: content,
                             time_created: time_created)
        # add tweet under user
        author.add_tweet(tweet._id)

        # # save this tweet in global timeline
        # $redis.rpush($globalTL, tweet.to_json)
        # if $redis.llen($globalTL) > 50
        #   $redis.rpop($globalTL)
        # end
      end
      
      i = i + 1
    end
    
    endtime = Time.now
    puts endtime - starttime
    # erb "process time: #{endtime - starttime} seconds",
    # :locals => { :title => 'Test Interface' }
  end
end


# get the test home page for all test interface
get '/test' do
  # Mongoid::Config.connect_to('nanotwitter-loadtest')
  erb :test_interface, :locals => { :title => 'Test Interface' }
end

# delete everything and recreate test uesr
post '/test/reset/all' do
  # Mongoid::Config.connect_to('nanotwitter-loadtest')
  # delete everything
  # delete db
  Mongoid.purge!
  # delete redis
  $redis.flushall
  # clean session and cookie
  Sidekiq::Queue.new.clear
  session.clear
  cookies.clear

  #create test user
  today = Date.today.strftime("%B %Y")
  profile_hash = {
    :bio => "",
    :dob => "",
    :date_joined => today,
    :location => "",
    :name => ""
  }
  profile = Profile.new(profile_hash)
  user = User.create(
    handle: "testuser", 
    email: "testuser@sample.com", 
    password: "password",
    profile: profile)
  # store TestUser in session and redis
  session[:testuser] = user
  $redis.set("testuser", user.to_json)

  erb "All reset", :locals => { :title => 'Test Status' }
end

# delete and recreate TestUser
post '/test/reset/testuser' do
  # Mongoid::Config.connect_to('nanotwitter-loadtest')
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
  #create test user
  today = Date.today.strftime("%B %Y")
  profile_hash = {
    :bio => "",
    :dob => "",
    :date_joined => today,
    :location => "",
    :name => ""
  }
  profile = Profile.new(profile_hash)
  user = User.create(
    handle: "testuser", 
    email: "testuser@sample.com", 
    password: "password",
    profile: profile)
  # renew TestUser in session
  session[:testuser] = user
  $redis.set("testuser", user.to_json)

end

# One page “report” of collections status
get '/test/status' do
  # Mongoid::Config.connect_to('nanotwitter-loadtest')
  # How many users and follows
  user_num = 0
  follow_num = 0
  if User.exists?
    user_num = User.count
    # extract follow relationship from each user
    User.each do |user|
      follow_num += user.nfollowings
    end
  end
  # How many tweets
  tweet_num = 0
  if Tweet.exists? 
    tweet_num = Tweet.count
  end

  if session[:testuser] != nil
    testuser = session[:testuser]
    testuser_id = testuser._id
  # elsif $redis.exists("testuser")
  #   user_hash = JSON.parse($redis.get("testuser"))
  #   profile_hash = user_hash["profile"]
  #   profile = Profile.new(profile_hash)
  #   user_hash["profile"] = profile
  #   testuser = User.new(user_hash)
  #   testuser_id = testuser._id
  elsif User.where(handle: "testuser").exists?
    testuser = User.where(handle: "testuser").first
    testuser_id = testuser._id
  else
    testuser_id = "There not exists testuser!"
  end

  erb "User Number: #{user_num} <br>
        Follow Number: #{follow_num} <br>
        Tweet Number: #{tweet_num} <br><br>
        Testuser id: #{testuser_id}",
      :locals => { :title => 'Test Status' }
end

# display version number of this build
get '/test/version' do
  # Mongoid::Config.connect_to('nanotwitter-loadtest')
  erb "version: 1.0", :locals => { :title => 'Test Version' }
end

# reset the database by deleting all users, tweets and follows
# recreate TestUser
# load n tweets from seed data if tweets parameter exists
# otherwise load all tweets from seed data
post '/test/reset/standard' do

  # clean all data storage and state
  Mongoid.purge!
  $redis.flushall
  Sidekiq::Queue.new.clear
  session.clear
  cookies.clear

  # Recreate TestUser
  #create test user
  today = Date.today.strftime("%B %Y")
  profile_hash = {
    :bio => "",
    :dob => "",
    :date_joined => today,
    :location => "",
    :name => ""
  }
  profile = Profile.new(profile_hash)
  user = User.create(
    handle: "testuser", 
    email: "testuser@sample.com", 
    password: "password",
    profile: profile)
  session[:testuser] = user
  $redis.set("testuser", user.to_json)

  Thread.new do
    ResetStandard.perform(params)
  end

  erb "This operation takes about 60 seconds, please wait and check status page <br>", :locals => { :title => 'Test Interface' }
  
end

# create u (integer) fake Users using faker. Defaults to 1
post '/test/users/create' do
  # Mongoid::Config.connect_to('nanotwitter-loadtest')
  starttime = Time.now

  user_count = 1
  tweets_count = 0

  if params[:count] != nil
    user_count = params[:count].to_i 
  end

  if params[:tweets] != nil
    tweets_count = params[:tweets].to_i 
  end

  Thread.new do
    # for i users, each user create j tweets
    i = 0
    while i < user_count do
      today = Date.today.strftime("%B %Y")
      profile_hash = {
        :bio => "",
        :dob => "",
        :date_joined => today,
        :location => "",
        :name => ""
      }
      profile = Profile.new(profile_hash)
      user = User.create(
        handle: "testuser#{i}", 
        email: "testuser#{i}@sample.com",
        password: "password#{i}",
        profile: profile)
      j = 0
      while j < tweets_count do
        tweet = Tweet.create(
          content: "no.#{j} tweet",
          author_id: user._id,
          author_handle: user.handle)
        user.add_tweet(tweet._id)
        # save this tweet in global timeline
        $redis.rpush($globalTL, tweet.to_json)
        if $redis.llen($globalTL) > 50
          $redis.rpop($globalTL)
        end

        # spread this tweet to all followers
        # followers = db_login_user.followeds
        followers = user.followeds
        followers.each do |follower|
          $redis.rpush(follower.to_s, tweet_id)
          if $redis.llen(follower.to_s) > 50
            $redis.rpop(follower.to_s)
          end
        end
        j = j + 1
      end
      i = i + 1
    end
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
  # Mongoid::Config.connect_to('nanotwitter-loadtest')
  # initialize variables
  user = nil
  tweets_count = 0
  # botain user from database
  # TODO: store the testuser with id of testuser into db too
  if params[:user] == "testuser"
    if session[:testuser] != nil
      user = session[:testuser]
    else
      user = User.where(handle: "testuser").first
    end
  elsif User.where(_id: params[:user]).exists?
    user = User.where(_id: params[:user]).first
  end
  # get tweets creating number 
  if params[:count] != nil
    tweets_count = params[:count].to_i
  end

  # create t tweets for this user
  if user != nil 
    Thread.new do
      i = 0
      while i < tweets_count.to_i do
        tweet = Tweet.create(content: "no.#{i} fake tweet", author_id: user._id, author_handle: user.handle)
        user.add_tweet(tweet._id)
        # save this tweet in global timeline
        $redis.rpush($globalTL, tweet.to_json)
        if $redis.llen($globalTL) > 50
          $redis.rpop($globalTL)
        end

        # spread this tweet to all followers
        # followers = db_login_user.followeds
        followers = user.followeds
        followers.each do |follower|
          $redis.rpush(follower.to_s, tweet_id)
          if $redis.llen(follower.to_s) > 50
            $redis.rpop(follower.to_s)
          end
        end
        i = i + 1
      end
    end
  else
    erb "User #{params[:user]} doen't exist in database",
        :locals => { :title => 'Test Interface' }
  end

end

# n (integer) randomly selected users follow 
# ‘n’ (integer) different randomly seleted users.
post '/test/user/follow' do
  # Mongoid::Config.connect_to('nanotwitter-loadtest')
  if User.count < 2
    erb "Run post '/test/reset/standard' first!", :locals => { :title => 'Test Interface' }
  else
    n = 1 # default 1
    if params[:count] != nil
      n = params[:count].to_i
    end
    
    output = ""

    users = User.all
    users.sample(n).each do |user|
      tmp_users = User.all
      # tmp_users.delete(user_id)
      tmp_users.sample(n).each do |following_user| 
        user.toggle_following(following_user._id)
        following_user.toggle_followed(user._id)
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
  # Mongoid::Config.connect_to('nanotwitter-loadtest')
  # initialize variables
  user = nil
  n = 0
  # botain user from database
  if params[:user] == "testuser"
    if session[:testuser] != nil
      user = session[:testuser]
    else
      user = User.where(handle: "testuser").first
    end
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
      Thread.new do
        users = User.all
        # if params[:user] != "testuser"
        #   users.delete(params[:user].to_i)
        # end
        tweets = user.tweets
        users.sample(n).each do |follower_user|
          user.toggle_followed(follower_user._id)
          follower_user.toggle_following(user._id)

          tweets.each do |tweet_id|
            $redis.rpush(follower_user._id.to_s, tweet_id)
            if $redis.llen(follower_user._id.to_s) > 100
              $redis.rpop(follower_user._id.to_s)
            end
          end

        end

        $redis.set("testuser", user.to_json)
      end
      # show the result
      erb " This operation takes about 60 seconds, please wait and check status page <br>
        For user<br>
        handle: #{user.handle}<br>
        #{user.followeds.to_a.to_s}", :locals => { :title => 'Test Interface' }
    end
  else
    erb "User #{params[:user]} doen't exist in database", :locals => { :title => 'Test Interface' }
  end
end

post "/test/standard" do
  #byebug
  starttime = Time.now

  user_count = 1
  tweets_count = 0
  follow_count = 0
  
  user = nil

  user_count = params[:u].to_i unless params[:u] == nil
  tweets_count = params[:t].to_i unless params[:t] == nil
  follow_count = params[:f].to_i unless params[:f] == nil


  Thread.new do
    # for i users, each user create j tweets
    i = 0
    while i < user_count do
      today = Date.today.strftime("%B %Y")
      profile_hash = {
        :bio => "",
        :dob => "",
        :date_joined => today,
        :location => "",
        :name => ""
      }
      profile = Profile.new(profile_hash)
      user = User.create(
        handle: "testuser#{i}", 
        email: "testuser#{i}@sample.com",
        password: "password#{i}",
        profile: profile)
      j = 0
      while j < tweets_count do
        tweet = Tweet.create(
          content: "no.#{j} tweet",
          author_id: user._id,
          author_handle: user.handle)
        user.add_tweet(tweet._id)
        # save this tweet in global timeline
        $redis.rpush($globalTL, tweet.to_json)
        if $redis.llen($globalTL) > 50
          $redis.rpop($globalTL)
        end

        # spread this tweet to all followers
        # followers = db_login_user.followeds
        followers = user.followeds
        followers.each do |follower|
          $redis.rpush(follower.to_s, tweet_id)
          if $redis.llen(follower.to_s) > 50
            $redis.rpop(follower.to_s)
          end
        end
        j = j + 1
      end
      i = i + 1
    end
  end

  Thread.new do

    i = 0

    # Create followers
    while i < follow_count do
      rand_follower = Random.rand(user_count)
      rand_following = nil
      loop do 
        rand_following = Random.rand(user_count)
        break if rand_following != rand_follower
      end
      
      # get a random user
      user_follower = get_user("handle", "testuser#{rand_follower}")
      user_following = get_user("handle", "testuser#{rand_following}")
      
      puts "numer = #{rand_follower}, numing = #{rand_following}"
      puts "Follower = #{user_follower}, Following = #{user_following}"
      
      # select n random users to follow user u
      if user_follower != nil && user_following != nil
        user_following.toggle_followed(user_follower._id)
        user_follower.toggle_following(user_following._id)
      end
      i = i + 1
    end
  end

  endtime = Time.now

  erb "Created #{user_count} users <br>
  For each user created #{tweets_count} tweets <br><br>
  For each user created #{follow_count} follows <br><br>
  Total processing time: #{endtime - starttime} second",
      :locals => { :title => 'Test Interface' }

end
