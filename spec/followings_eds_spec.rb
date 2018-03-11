require_relative './spec_helper.rb'

class UserAPITest < MiniTest::Unit::TestCase
	include Rack::Test::Methods

	def app
		Sinatra::Application
	end

	def setup
		DatabaseCleaner.strategy = :truncation
		DatabaseCleaner.clean

		params = {}
		params[:user] = { :handle => 'shuaiyu8',
						 :email => "shuaiyu@brandeis.edu",
						 :password => '123456'}
		@day_before_yesterday = Date.yesterday - 1
		@day_before_yesterday = @day_before_yesterday.to_s
		@profile = Profile.new('engineer', @day_before_yesterday, @day_before_yesterday, 'new york', 'Shuai Yu')
		params[:user][:profile] = @profile
		@targeted = User.new(params[:user])
		@targeted.save
		@id_shuai = @targeted._id

		# log in as shuai, follow other users
		post '/login?', params[:user]

		params[:user] = { :handle => 'alyssa',
										:email => 'alyssa@brandeis.edu',
										:password => '123456'}
		@yesterday = Date.yesterday.to_s
		@profile = Profile.new('girl', @yesterday, @yesterday, 'boston', 'Alyssa Goncalves')
		params[:user][:profile] = @profile
		@targeted = User.new(params[:user])
		@targeted.save
		@id_alyssa = @targeted._id
		params[:targeted_id] = @id_alyssa.to_s
		# follow alyssa
		post 'follow', params

		params[:user] = { :handle => 'sichen',
						 :email => 'sichen@brandeis.edu',
						 :password => '12345678'}
		@today = Date.today.to_s
		@profile = Profile.new('student', @today, @today, 'waltham', 'Si Chen')
		params[:user][:profile] = @profile
		@targeted = User.new(params[:user])
		@targeted.save
		@id_si = @targeted._id
		params[:targeted_id] = @id_si.to_s
		# follow si
		post '/follow', params

		post '/logout'
		# login as user 'sichen'
		post '/login?', params[:user]
		params[:targeted_id] = @id_shuai.to_s
		# sichen follows shuai
		post '/follow', params
	end

	def test_user
		# logged in as sichen, visit shuai's user page
		res = get "/user/#{@id_shuai.to_s}"
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
		assert res.body.include?('At new york')
		# date joined of the targeted user
		assert res.body.include?('Joined on ' + @day_before_yesterday)
	end

	def test_following
		params = {}
		params[:targeted_id] = @id_shuai.to_s
		res = get "/user/followings/", params
		assert res.ok?
		#handle of logged in user
		assert res.body.include?('sichen')
		#handle of targetted user
		assert res.body.include?('shuaiyu8')
		#handle of following 1
		assert res.body.include?('alyssa')
		#handle of following 2
		assert res.body.include?('sichen')
	end

	def test_followed
		params = {}
		params[:targeted_id] = @id_shuai.to_s
		res = get "/user/followeds/", params
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
