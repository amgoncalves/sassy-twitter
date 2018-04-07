get '/demo/reset/mongodb' do
  Mongoid::Config.connect_to('nanotwitter-demo')
  Mongoid.purge!
end

get '/demo/reset/redis' do
  $redis.flushall
end

post '/demo/mongodb/user/create' do
  Mongoid::Config.connect_to('nanotwitter-demo')
  starttime = Time.now
  i = 0
  while i < 1000 do
    today = Date.today.strftime("%B %Y")
    profile_hash = {:bio => "", :dob => "", :date_joined => today, :location => "", :name => ""}
    profile = Profile.new(profile_hash)
    uhash = Hash.new
    uhash[:id] = i.to_s
    uhash[:handle] = "test#{i}"
    uhash[:email] = "test#{i}@test"
    uhash[:password] = "password#{i}"
    uhash[:profile] = profile
    
    user = Userd.new(uhash)
    user.save
    
    i = i +1
  end
  endtime = Time.now
  erb "created 1000 users process time: #{endtime - starttime} seconds",
  :locals => { :title => 'Create 1000 Users MongoDB' }
end

post '/demo/mongodb/tweet/create' do
  Mongoid::Config.connect_to('nanotwitter-demo')
  starttime = Time.now

  j = 0
  while j < 100 do
    i = 0
    while i < 10 do 
      thash = Hash.new
      author_id = j.to_s
      thash[:userd_id] = author_id
      thash[:author_handle] = "test#{author_id}"
      thash[:content] = "test tweet #{i} by author #{author_id}"

      tweet = Tweetd.new(thash)

      if tweet.save
        puts i
      else
        puts "save failed"
      end
      i = i + 1
    end
    j = j + 1
  end

  endtime = Time.now
  erb "created 1000 tweets process time: #{endtime - starttime} seconds", 
  :locals => { :title => 'Create 1000 Tweets MongoDB' }
end
# post '/demo/redis/user/create'
# end

post '/demo/mongodb/user' do
  Mongoid::Config.connect_to('nanotwitter-demo')
  starttime = Time.now
  i = 0
  while i < 1000 do
    user_id = rand(1000).to_s
    user = Userd.where(handle: "test#{user_id}").first
    i = i +1
  end
  endtime = Time.now
  erb "Retrieved 1000 users process time: #{endtime - starttime} seconds",
  :locals => { :title => 'Read 1000 Users MongoDB' }
end

# post '/demo/redis/user/:user_id'
# end

post '/demo/mongodb/user/delete' do
  Mongoid::Config.connect_to('nanotwitter-demo')
  starttime = Time.now
  i = 0
  while i < 100
    user_id = i.to_s
    Userd.where(_id: user_id).first.delete
    i = i + 1
  end
  endtime = Time.now
  erb "Deleted 100 users with 1000 tweets process time: #{endtime - starttime} seconds",
  :locals => { :title => 'Delete 100 Users MongoDB' }
end

# post '/demo/redis/user/delete'
# end

post '/demo/mongodb/tweet/delete' do
  Mongoid::Config.connect_to('nanotwitter-demo')
  starttime = Time.now
  i = 0
  while i < 100
    userd_id = i.to_s
    Tweetd.where(userd_id: userd_id).delete
    i = i + 1
  end
  endtime = Time.now
  erb "Deleted 1000 tweets process time: #{endtime - starttime} seconds",
  :locals => { :title => 'Delete 1000 tweets MongoDB' }
end

# post '/demo/redis/tweet/delete' do
# end

post '/demo/mongodb/user/update' do
  Mongoid::Config.connect_to('nanotwitter-demo')
  # modify 1000 user's password
  starttime = Time.now
  i = 0
  while i < 1000
    user_id = i.to_s
    Userd.where(_id: user_id).update(password: "test#{i}")
    i = i + 1
  end
  endtime = Time.now
  erb "Updated 1000 users process time: #{endtime - starttime} seconds",
  :locals => { :title => 'Update 1000 Users MongoDB' }
end

# post '/demo/redis/user/update' do
# end