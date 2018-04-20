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
    # yesterday = Date.yesterday.to_s
    yesterday = Date.yesterday
    @date_joined = yesterday.strftime("%B %Y")
    @dob = yesterday.strftime("%B %d, %Y")

    # @profile_shuai = Profile.new('ma4', yesterday, yesterday, 'waltham', 'Shuai Yu')
    shuai_profile = { :bio => 'ma4', :dob => @dob, :date_joined => @date_joined, :location => 'waltham', :name => 'shuai'}
    params[:user][:profile] = Profile.new(shuai_profile)

    # params[:user][:profile] = @profile_shuai
    @targeted = User.new(params[:user])
    @targeted.save

    # log in as shuaiyu8
    post '/login?', params[:user]

    params[:user] = { :handle => 'sichen',
		      :email => 'sichen@brandeis.edu',
		      :password => "12345678"}
    today = Date.today
    @date_joined = today.strftime("%B %Y")
    @dob = today.strftime("%B %d, %Y")
    si_profile = {:bio => 'student', :dob => @dob, :date_joined => @date_joined, :location => 'waltham', :name => 'Si Chen'}
    @profile = Profile.new(si_profile)
    # @profile = Profile.new('student', today, today, 'waltham', 'Si Chen')
    #
    # si_profile = { :bio => 'student', :dob => today, :date_joined => todya, :location => 'waltham', :name => 'shuai'}
    # params[:user][:profile] = Profile.new(si_profile)
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
    # assert res.body.include?('Joined ' + @profile.date_joined.strftime("%B %Y"))
    assert res.body.include?('Joined ' + @date_joined)
  end
end
