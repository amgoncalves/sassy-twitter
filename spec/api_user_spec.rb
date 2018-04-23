require_relative './spec_helper.rb'

class ApiUserSpec < MiniTest::Unit::TestCase
  def app
    Sinatra::Application
  end

  def setup
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.clean
    @params = {}
    @params[:user] = { :handle => 'hpotter',
		       :email => "hpotter@hogwarts.edu",
		       :password => 'password' }
    @dob = Date.today.strftime("%B %d, %Y")
    @params[:user][:profile] = Profile.new({:bio => 'wizard', :dob => @dob, :date_joined => @dob, :location => 'England', :name=> 'Harry Potter'})
    @user = User.new(@params[:user])
    @user.save
    @api_key = "hpotter"
    post '/login', @params[:user]
  end

  def test_known_user
    params = {}
    params[:input_type] = "handle"
    params[:key] = "hpotter"
    get "/api/v1/#{@api_key}/users/#{params[:key]}", params
    assert_equal(200, last_response.status)
    attributes = JSON.parse(last_response.body)
    puts "\n\n\nAttributes: #{attributes}\n\n\n"
    assert_equal("hpotter", attributes["handle"])
    assert_equal("Harry Potter", attributes["profile"]["name"])
  end

  def test_unknown_user
    params = {}
    params[:input_type] = "handle"
    params[:key] = "supercalifragilisticexpialidocious"    
    get "/api/v1/#{@api_key}/users/#{params[:key]}", params
    assert_equal(404, last_response.status)
  end
end
