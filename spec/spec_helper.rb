ENV['RACK_ENV'] = 'test'

require 'minitest/spec'
require 'minitest/autorun'
require 'rack/test'
require 'rack-minitest/test'
require 'mongoid'
require 'sinatra'

Mongoid::Config.connect_to('nanotwitter-dev')

# class MiniTest::Spec
#   # provides Rack's mock test methods, such as the http request verbs (get, post, ...)
#   include Rack::Test::Methods

#   # provides json relates methods, such as get_json, post_json, last_json_response
#   include Rack::Minitest::JSON

#   # provides assertions such as assert_ok, assert_response_status
#   include Rack::Minitest::Assertions  ## included in expectations

#   # provides expectations/matchers such as last_response.must_be_ok and last_response.must_be_not_found
#   include Rack::Minitest::Expectations
# end
