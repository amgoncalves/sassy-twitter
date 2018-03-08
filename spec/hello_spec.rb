require_relative 'spec_helper'

describe "service" do 
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  describe "hello test" do
    it "should successfully return root path" do
      get '/'
      last_response.must_be_ok
    end
  end
end
