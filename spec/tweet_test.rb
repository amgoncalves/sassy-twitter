require_relative './spec_helper.rb'

class TweetTest < MiniTest::Unit::TestCase
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

		@content = 'This is my first tweet'
		@params[:tweet] = {}
		@params[:tweet][:content] = @content
		post '/tweet/new', @params
		@tweet = Tweet.where(content: @content).first
		@tweet_id = @tweet._id
		@user = User.where(_id: @id_loggedin).first
	end

	def test_rely
		post '/tweet/new', @params
		@reply_content = 'Reply to fist tweet'
		@params[:reply] = {}
		@params[:reply][:content] = @reply_content
		@params[:tweet_id] = @tweet_id.to_s
		post '/reply', @params
		@reply = Reply.where(content: @reply_content).first
		refute_nil(@reply, 'Reply not saved')
		res = get "/tweet/#{@tweet_id}"
		assert res.ok?
		assert res.body.include?(@content)
		assert res.body.include?(@reply_content)
	end

	def test_tweetid
		post '/tweet/new', @params
		res = get "/tweet/#{@tweet_id}"
		assert res.ok?
		assert res.body.include?(@content)
	end

	def test_retweet
		@content_retweet = 'This is my first retweet'
		@params[:retweet] = {}
		@params[:retweet][:content] = @content_retweet
		@params[:tweet_id] = @tweet_id
		post 'retweet', @params
		@retweet = Tweet.where(content: @content_retweet).first
		refute_nil(@retweet, 'Retweet not saved')
		assert_equal(@retweet.original_tweet_id, @tweet_id, 'Original tweet id does not match')
		assert_equal(@retweet.content, @content_retweet)
		@user = User.where(_id: @id_loggedin).first
		assert_equal(@user.tweets.include?(@retweet._id), true, 'Retweet not added')
		assert_equal(@user._id, @retweet.author_id, 'Author ID not matched')
	end
end
