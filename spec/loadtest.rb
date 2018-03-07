require 'mongoid'
require 'mongo'
require 'sinatra'
require 'erb'
require_relative '../models/user'
require_relative '../models/tweet'
require_relative '../models/reply'

Mongoid::Config.connect_to('nanotwitter-test')

# delete everything and recreate test uesr
post '/test/reset/all' do
  # delete everything
  Mongoid.purge!
  #create test user
  User.where(handle: "testuser", 
    email: "testuser@sample.com", 
    password: "password").create
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

# create u (integer) fake Users using faker. Defaults to 1
post '/test/users/create' do
  starttime = Time.now
  count = params[:count]
  tweets = params[:tweets]

  i = 0
  while i < count.to_i do
    user = User.where(handle: "testuser#{i}", 
      email: "testuser#{i}@sample.com",
      password: "password#{i}").create

    j = 0
    while j < tweets.to_i do
      tweet = Tweet.where(content: "no.#{j} tweet").create
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



