require_relative 'spec_helper'

require_relative '../app.rb'

enable :sessions

describe "service" do 
  include Rack::Test::Methods

  def app
    Sinatra::Application
    cur_user = User.where(_id: "5a9f56c1c936e85b7f7d9693").first
    session[:user] = cur_user
  end

  describe "hello test" do
    it "should successfully return root path" do
      get '/'
      last_response.must_be_ok
      puts last_response
    end

    it "should return targeted user" do
      get "/user/5a9f5719c936e85b7f7d9694"
      last_response.must_be_ok
      puts last_response
    end
  end
end
