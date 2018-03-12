require_relative './spec_helper.rb'

class NewTweetTest < MiniTest::Unit::TestCase
	include Rack::Test::Methods

	def app
		Sinatra::Application
	end

	def setup
		DatabaseCleaner.strategy = :truncation
		DatabaseCleaner.clean

		@params = {}
		@params[:user] = { :handle => 'shuaiyu8',
										:email => 'shuaiyu@brandeis.edu',
										:password => '123456'}
		@login_user = User.new(@params[:user])
		@login_user.save
		@id_loggedin = @login_user._id

		post '/login?', @params[:user]
	end

	def test_newtweet
		@content = 'This is my first tweet'
		@params[:tweet] = {}
		@params[:tweet][:content] = @content
		post '/tweet/new', @params
		@tweet = Tweet.where(content: @content).first
		refute_nil(@tweet, 'Tweet not saved')
		@tweet_id = @tweet._id
		@user = User.where(_id: @id_loggedin).first
		assert_equal(@user.tweets.include?(@tweet_id), true, 'Tweet not added')
		assert_equal(@tweet.author_id, @user._id, 'Author id not matched')
	end
end
