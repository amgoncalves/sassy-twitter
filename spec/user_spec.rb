require_relative './spec_helper.rb'

class UserTest < MiniTest::Unit::TestCase
	include Rack::Test::Methods

	def app
		Sinatra::Application
	end

	def setup
		DatabaseCleaner.strategy = :truncation
		DatabaseCleaner.clean

		params = {}
		params[:user] = { :handle => 'shuaiyu8',
						 :email => 'shuaiyu@brandeis.edu',
						 :password => '123456'}
		@targeted = User.new(params[:user])
		@targeted.save

		# post 'signup/submit', params
		post '/login?', params[:user]

		params[:user] = { :handle => 'sichen',
						 :email => 'sichen@brandeis.edu',
						 :password => "12345678"}
		today = Date.today.to_s
		@profile = Profile.new('student', today, today, 'waltham', 'Si Chen')
		params[:user][:profile] = @profile
		@targeted = User.new(params[:user])
		@targeted.save
		@id = @targeted._id
	end

	def test_user
		res = get "/user/#{@id.to_s}"
		assert res.ok?
		# handle of logged in user
		assert res.body.include?('shuaiyu8') 
		# handle of the targeted user
		assert res.body.include?('sichen')
		# bio of the targeted user
		assert res.body.include?('student')
		# name of the targeted user
		assert res.body.include?('Si Chen')
		# location of the targeted user
		assert res.body.include?('waltham')
		# date joined of the targeted user
		assert res.body.include?('Joined ' + @profile.date_joined.to_s)
	end
end
