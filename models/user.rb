require 'bcrypt'
require 'mongo'
require 'mongoid'
require_relative 'profile'

class User
  include BCrypt
  include Mongoid::Document

  field :handle, type: String
  field :email, type: String
  field :password_hash, type: String
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

  def initialize(params)
    super
    self.APItoken = self.handle
  end  

  def password
    @password ||= Password.new(password_hash)
  end

  def password=(new_password)
    @password = Password.create(new_password)
    self.password_hash = @password
  end  
end
