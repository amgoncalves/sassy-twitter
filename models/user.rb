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
		nxt_following = following
		if following.include?(following_id)
			nxt_following.delete(following_id)
		else
			nxt_following.add(following_id)
		end
		self.set(following: nxt_following)
	end

	def toggle_followed(followed_id)
		nxt_followed = followed
		if followed.include?(followed_id)
			nxt_followed.delete(followed_id)
		else
			nxt_followed.add(followed_id)
		end
		self.set(followed: nxt_followed)
	end

  def release_following(following_id)
    if following.include?(following_id)
      new_following = following.delete(following_id)
      self.set(following: new_following)
    end
  end

  def release_followed(followed_id)
    if followed.include?(followed_id)
      new_followed = followed.delete(followed_id)
      self.set(followed: new_followed)
    end
  end

	def add_tweet(tweet_id)
		nxt_tweets = tweets.push(tweet_id)
		self.set(tweets: nxt_tweets)
	end

	def update_profile(newprofile)
		self.set(profile: newprofile)
	end

	def follow?(targeted_id)
		following.include?(targeted_id)
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
