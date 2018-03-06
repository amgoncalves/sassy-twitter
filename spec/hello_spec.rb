require_relative 'spec_helper'

describe "service" do 
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  describe "hello test" do
    it "should successfully return root path" do
      get '/'
      assert last_response.ok?
      assert true
    end
  end
end
