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
		params[:user] = { :handle => "shuaiyu8",
						 :email => "shuaiyu@brandeis.edu",
						 :password => "123456"}
		# today = DateTime.now
		# @profile = Profile.new("student", today, today, "waltham", "Shuai Yu")
		# params[:user][:profile] = @profile
		# @user = User.new(params[:user])
		# @user.save

		post 'signup/submit', params
		post '/login?', params[:user]


		params[:user] = { :handle => "sichen",
						 :email => "sichen@brandeis.edu",
						 :password => "12345678"}
		today = DateTime.now
		@profile = Profile.new("student", today, today, "waltham", "Si Chen")
		params[:user][:profile] = @profile
		@targeted = User.new(params[:user])
		@targeted.save
		@id = @targeted._id
	end

	def test_id_correct
		res = get "/user/#{@id.to_s}"
		assert last_response.ok?
		assert_includes(res, "Followings", "Error")
		byebug
		# attributes = JSON.parse(last_response.body)
		# assert_equal "Hello, word", last_response.body

	end


end
