require_relative './spec_helper.rb'
require 'byebug'

class ApiUserSpec < MiniTest::Unit::TestCase
  def app
    Sinatra::Application
  end

  def setup
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.clean
    @handle = "hpotter"
    @params = {}
    @params[:user] = { :handle => @handle,
		       :email => "hpotter@hogwarts.edu",
		       :password => 'password' }
    @dob = Date.today.strftime("%B %d, %Y")
    @params[:user][:profile] = Profile.new({:bio => 'wizard', :dob => @dob, :date_joined => @dob, :location => 'England', :name=> 'Harry Potter'})
    @user = User.new(@params[:user])
    @user.save
    @api_key = @handle
    post '/login', @params[:user]
  end

  def test_tweet
    msg = "Hello, world!"
    params = {}
    params[:tweet] = {}
    params[:tweet][:content] = msg
    post "/api/v1/#{@api_key}/tweets/new", params
    assert_equal(200, last_response.status)
    attributes = JSON.parse(last_response.body)
    assert_equal("hpotter", attributes["author_handle"])
    assert_equal(msg, attributes["content"])
  end
end
