ENV['RACK_ENV'] = 'test'

require 'minitest/spec'
require 'minitest/autorun'
require 'rack/test'
require 'rack-minitest/test'
require 'mongoid'
require 'sinatra'
require_relative '../app.rb'

Mongoid::Config.connect_to('nanotwitter-dev')
