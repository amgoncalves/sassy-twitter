ENV['RACK_ENV'] = 'test'
require 'minitest/autorun'
require 'rack/test'

require_relative '../app.rb'

require 'mongoid'
Mongoid.load!('./config/mongoid.yml')
