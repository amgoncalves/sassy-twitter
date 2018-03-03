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
  field :profile, type: Profile
  field :followed, type: Set, default: []
  field :following, type: Set, default: []
  field :tweets, type: Array, default: []
  field :likedTweets, type: Set, default: []

  validates :handle, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
  validates :password_hash, presence: true
  validates :APItoken, presence: true, uniqueness: true

  def initialize(params)
    super
    self.APItoken = self.handle
  end  

	def toggle_following(following_id)
		nxt_following = following
		if following.include?(following_id)
			nxt_following.delete(following_id)
		else
			nxt_following.add(following_id)
		end
		self.set(following: nxt_following)
	end

	def add_tweet(tweet_id)
		nxt_tweets = tweets.push(tweet_id)
		self.set(tweets: nxt_tweets)
	end

  def password
    @password ||= Password.new(password_hash)
  end

  def password=(new_password)
    @password = Password.create(new_password)
    self.password_hash = @password
  end  
end
