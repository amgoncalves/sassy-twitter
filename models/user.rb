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
  field :followeds, type: Set, default: []
	field :nfolloweds, type: Integer, default: 0
  field :followings, type: Set, default: []
	field :nfollowings, type: Integer, default: 0
  field :tweets, type: Array, default: []
	field :ntweets, type: Integer, default: 0
  field :liked, type: Set, default: []

  validates :handle, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
  validates :password_hash, presence: true
  validates :APItoken, presence: true, uniqueness: true

  def initialize(params)
    super
    self.APItoken = self.handle
  end  

	def toggle_following(following_id)
		nxt_followings = followings
		nxt_nfollowings = nfollowings
		if followings.include?(following_id)
			nxt_followings.delete(following_id)
			nxt_nfollowings = nxt_nfollowings - 1
		else
			nxt_followings.add(following_id)
			nxt_nfollowings = nxt_nfollowings + 1
		end
		self.set(followings: nxt_followings)
		self.set(nfollowings: nxt_nfollowings)
	end

	def toggle_followed(followed_id)
		nxt_followeds = followeds
		nxt_nfoloweds = nfolloweds
		if followeds.include?(followed_id)
			nxt_followeds.delete(followed_id)
			nxt_nfoloweds = nxt_nfoloweds - 1
		else
			nxt_followeds.add(followed_id)
			nxt_nfoloweds = nxt_nfoloweds + 1
		end
		self.set(followeds: nxt_followeds)
		self.set(nfolloweds: nxt_nfoloweds)
	end

	def add_tweet(tweet_id)
		nxt_tweets = tweets.push(tweet_id)
		self.set(tweets: nxt_tweets)
		nxt_ntweets = ntweets + 1
		self.set(ntweets: nxt_ntweets)
	end

  def update_profile(newprofile)
    self.set(profile: newprofile)
  end

	def follow?(target_user)
		followings.include?(target_user._id)
	end

  def password
    @password ||= Password.new(password_hash)
  end

  def password=(new_password)
    @password = Password.create(new_password)
    self.password_hash = @password
  end

  def findById(user_id)
    return self.where(_id: user_id).first
  end
  
  def self.search(query)
    self.where(handle: /#{query}/i)
  end

  def like?(tweet_id)
    self.liked.include?(tweet_id.to_s)
  end

  def like(tweet_id)
    new_liked = self.liked.add(tweet_id.to_s)
    self.set(liked: new_liked)
  end

  def unlike(tweet_id)
    new_liked = self.liked.delete(tweet_id.to_s)
    self.set(liked: new_liked)
  end  
end
