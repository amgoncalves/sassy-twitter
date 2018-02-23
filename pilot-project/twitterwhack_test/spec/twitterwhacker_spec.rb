# ENV['SINATRA_ENV'] = 'test'

require File.dirname(__FILE__) + '/../twitterwhacker'
require 'rspec'
# require 'spec/interop/test'
require 'rack/test'

# set :environment, :test
# Test::Unit::TestCase.send :include, Rack::Test::Methods

# RSpec.configure do |conf|
#   conf.include Rack::Test::Methods
# end
describe "twitterwhacker" do
	include Rack::Test::Methods

	def app
	  Sinatra::Application
	end

    before(:each) do
		@tw = TwitterWhacker.new()
	end

    it "should find tweets about rolling stones" do
		@tw.search_both('rolling', 'stone')
		@tw.compute_index()
		@tw.index.should_not == nil
    end

	it "should find tweets about rolling and stone" do
		@tw.search_first('rolling')
		@tw.search_second('stone')
		@tw.compute_score()
		@tw.score.should_not == 0
	end

    it "should find the same tweets using the same terms" do
		@tw.search_first('rolling')
		@tw.search_second('stone')
		@tw.search_both('rolling', 'stone')
		@res1 = @tw.results_both
		@tw.search_both('rolling', 'stone')
		@res2 = @tw.results_both
		@res1.should eq(@res2)
    end

	it "should find an example tweet using rolling and stone" do
		@tw.search_both('rolling', 'stone')
		@tw.compute_index()
		@tw.example_tweet.should_not == nil
	end

	it "should have the same comment using thesame terms" do
		@tw.search_both('rolling', 'stone')
		@tw.compute_index()
		com1 = @tw.comment()
		@tw.search_both('rolling', 'stone')
		@tw.compute_index()
		com2 = @tw.comment()
		com1.should == com2
	end

	it "should have no example using the terms aaaaaa and xxxxxx" do
		@tw.search_both('aaaaaa', 'xxxxxx')
		@tw.compute_index()
		res = ['anyone', 'There is no tweet which contains both the terms.']
		@tw.example_tweet.should eq(res)
	end
end
