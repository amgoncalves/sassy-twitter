require_relative './spec_helper.rb'

class FollowPageTest < MiniTest::Unit::TestCase
	include Rack::Test::Methods

	def app
		Sinatra::Application
	end

	def setup
		DatabaseCleaner.strategy = :truncation
		DatabaseCleaner.clean

		@params = {}
		@params[:user] = { :handle => 'shuaiyu8',
						 :email => "shuaiyu@brandeis.edu",
						 :password => '123456'}
		@day_before_yesterday = Date.yesterday - 1
		@day_before_yesterday = @day_before_yesterday
		@dob = @day_before_yesterday.strftime("%B %d, %Y")
		@date_joined = @day_before_yesterday.strftime("%B %Y")
		# @profile = Profile.new('engineer', @day_before_yesterday, @day_before_yesterday, 'new york', 'Shuai Yu')
		shuai_profile = {:bio => "engineer", :dob => @dob, :date_joined => @date_joined, :location => 'new york', :name=> 'Shuai Yu'}
		@params[:user][:profile] = Profile.new(shuai_profile)
		@targeted = User.new(@params[:user])
		@targeted.save
		@id_shuai = @targeted._id

		# log in as shuai, follow other users
		post '/api/v1/login?', @params[:user]

		@params[:user] = { :handle => 'alyssa',
										:email => 'alyssa@brandeis.edu',
										:password => '123456'}
		@yesterday = Date.yesterday
		@dob = @yesterday.strftime("%B %d, %Y")
		@date_joined = @yesterday.strftime("%B %Y")
		alyssa_profile = {:bio => 'girl', :dob => @dob, :date_joined => @date_joined, :location => 'boston', :name => 'Alyssa Goncalves'}
		# @profile = Profile.new('girl', @yesterday, @yesterday, 'boston', 'Alyssa Goncalves')
		@profile = Profile.new(alyssa_profile)
		@params[:user][:profile] = @profile
		@targeted = User.new(@params[:user])
		@targeted.save
		@id_alyssa = @targeted._id
		@params[:targeted_id] = @id_alyssa.to_s
		# log in as shuaiyu8
		# follow alyssa
		post '/api/v1/shuaiyu8/follow', @params

		@params[:user] = { :handle => 'sichen',
						 :email => 'sichen@brandeis.edu',
						 :password => '12345678'}
		@today = Date.today
		@dob = @today.strftime("%B %d, %Y")
		@date_joined = @today.strftime("%B %Y")
		si_profile = {:bio => 'student', :dob => @dob, :date_joined => @date_joined, :location => 'waltham', :name => 'Si Chen'}
		@profile = Profile.new(si_profile)
		# @profile = Profile.new('student', @today, @today, 'waltham', 'Si Chen')
		@params[:user][:profile] = @profile
		@targeted = User.new(@params[:user])
		@targeted.save
		@id_si = @targeted._id
		@params[:targeted_id] = @id_si.to_s
		# log in as shuaiyu8
		# follow si
		post '/api/v1/shuaiyu8/follow', @params

		post '/api/v1/shuaiyu8/logout'
		# login as user 'sichen'
		post '/api/v1/login?', @params[:user]
		@params[:targeted_id] = @id_shuai.to_s
		# sichen follows shuai
		post '/api/v1/sichen/follow', @params
	end

	def test_user
		# logged in as sichen, visit shuai's user page
		res = get "/api/v1/sichen/user/#{@id_shuai.to_s}"
		assert res.ok?
		# handle of logged in user
		assert res.body.include?('sichen') 
		# handle of the targeted user
		assert res.body.include?('shuaiyu8')
		# bio of the targeted user
		assert res.body.include?('engineer')
		# name of the targeted user
		assert res.body.include?('Shuai Yu')
		# location of the targeted user
		assert res.body.include?('new york')
		# date joined of the targeted user
		# assert res.body.include?('Joined ' + @day_before_yesterday.strftime("%B %Y"))
		# assert res.body.include?('Joined ' + @day_before_yesterday)
		assert res.body.include?('Joined ' + @date_joined)
	end

	def test_following
		@params[:targeted_id] = @id_shuai.to_s
		res = get "/api/v1/sichen/user/followings/", @params
		assert res.ok?
		#handle of logged in user
		assert res.body.include?('sichen')
		#handle of targetted user
		assert res.body.include?('shuaiyu8')

		# in redis
		#handle of following 1
		assert res.body.include?('alyssa')
		#handle of following 2
		assert res.body.include?('sichen')
	end

	def test_followed
		@params[:targeted_id] = @id_shuai.to_s
		res = get "/api/v1/sichen/user/followeds/", @params
		assert res.ok?
		#handle of logged in user
		assert res.body.include?('sichen')
		#handle of targeted user
		assert res.body.include?('shuaiyu8')
		#handle of follower 1, name
		assert res.body.include?('Si Chen')
		#handle of no follower 2, 
		assert !res.body.include?('alyssa')
	end
end
