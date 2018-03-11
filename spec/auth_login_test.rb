require_relative './spec_helper.rb'

class AuthTest < MiniTest::Unit::TestCase
	include Rack::Test::Methods

	def app
		Sinatra::Application
	end

	def setup
		DatabaseCleaner.strategy = :truncation
		DatabaseCleaner.clean
	end

	def test_signup
		params = {}
		params[:user] = {:handle => 'shuaiyu8',
									 :email => 'shuaiyu@brandeis.edu',
									 :password => '123456'}
		post 'signup/submit', params
		@shuai = User.where(handle: 'shuaiyu8').first
		assert_equal(@shuai.handle, 'shuaiyu8', 'Wrong handle')
		assert_equal(@shuai.email, 'shuaiyu@brandeis.edu','Wrong email')
	end

	def test_login
		params = {}
		params[:user] = {:handle => 'shuaiyu8',
									 :email => 'shuaiyu@brandeis.edu',
									 :password => '123456'}
		@login_user = User.new(params[:user])
		@login_user.save

		params[:email] = 'shuaiyu@brandeis.edu'
		params[:password] = '12345'
		@fail_login = auth_user(params[:email], params[:password])
		assert_nil(@fail_login)
		params[:password] = '123456'
		@logged_in = auth_user(params[:email], params[:password])
		assert_equal(@logged_in._id, @login_user._id)
		assert_equal(@logged_in.handle, @login_user.handle)
		assert_equal(@logged_in.email, @login_user.email)
	end

end
