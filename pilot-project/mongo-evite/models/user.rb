require 'bcrypt'
require 'mongo'
require 'mongoid'
require_relative 'profile'

class User
  include BCrypt
  include Mongoid::Document

  field :handle, type: String
  field :email, type: String
  field :password, type: String
  field :APItoken, type: String
  field :Profile, type: Profile
  field :Followed, type: Set, default: []
  field :Following, type: Set, default: []
  field :Tweets, type: Set, default: []
  field :LikedTweets, type: Set, default: []

  validates :handle, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true
  validates :APItoken, presence: true, uniqueness: true

  def self.authenticate(params = {})
    return nil if params[:handle].blank? || params[:password].blank?

    @@credentials ||= YAML.load_file(File.join(__dir__, '../credentials.yml'))
    handle = params[:handle].downcase
    return nil if handle != @@credentials['handle']

    password_hash = Password.new(@@credentials['password_hash'])
    User.new(handle) if password_hash == params[:password]
  end
end
