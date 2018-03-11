ENV['RACK_ENV'] = 'test'

require 'minitest/spec'
require 'minitest/autorun'
require 'rack/test'
require 'rack-minitest/test'
require 'mongoid'
require 'sinatra'
require_relative '../models/profile'
require_relative '../models/user'
require_relative '../app.rb'
require 'database_cleaner'

Mongoid::Config.connect_to('nanotwitter-dev')
