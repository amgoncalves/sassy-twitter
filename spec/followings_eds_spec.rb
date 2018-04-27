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
    shuai_profile = {:bio => "engineer", :dob => @dob, :date_joined => @date_joined, :location => 'new york', :name=> 'Shuai Yu'}
    @params[:user][:profile] = Profile.new(shuai_profile)
    @targeted = User.new(@params[:user])
    @targeted.save
    @id_shuai = @targeted._id

    # log in as shuai, follow other users
    post '/login?', @params[:user]

    @params[:user] = { :handle => 'alyssa',
		       :email => 'alyssa@brandeis.edu',
		       :password => '123456'}
    @yesterday = Date.yesterday
    @dob = @yesterday.strftime("%B %d, %Y")
    @date_joined = @yesterday.strftime("%B %Y")
    alyssa_profile = {:bio => 'girl', :dob => @dob, :date_joined => @date_joined, :location => 'boston', :name => 'Alyssa Goncalves'}
    @profile = Profile.new(alyssa_profile)
    @params[:user][:profile] = @profile
    @targeted = User.new(@params[:user])
    @targeted.save
    @id_alyssa = @targeted._id
    @params[:targeted_id] = @id_alyssa.to_s
    # log in as shuaiyu8
    # follow alyssa
    post '/follow', @params

    @params[:user] = { :handle => 'sichen',
		       :email => 'sichen@brandeis.edu',
		       :password => '12345678'}
    @today = Date.today
    @dob = @today.strftime("%B %d, %Y")
    @date_joined = @today.strftime("%B %Y")
    si_profile = {:bio => 'student', :dob => @dob, :date_joined => @date_joined, :location => 'waltham', :name => 'Si Chen'}
    @profile = Profile.new(si_profile)
    @params[:user][:profile] = @profile
    @targeted = User.new(@params[:user])
    @targeted.save
    @id_si = @targeted._id
    @params[:targeted_id] = @id_si.to_s
    # log in as shuaiyu8
    # follow si
    post '/follow', @params

    post '/logout'
    # login as user 'sichen'
    post '/login?', @params[:user]
    @params[:targeted_id] = @id_shuai.to_s
    # sichen follows shuai
    post '/follow', @params
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
    assert res.body.include?('new york')
    # date joined of the targeted user
    assert res.body.include?('Joined ' + @date_joined)
  end

  def test_following
    @params[:targeted_id] = @id_shuai.to_s
    res = get "/user/followings/", @params
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
    res = get "/user/followeds/", @params
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
