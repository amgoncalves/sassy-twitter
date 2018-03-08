require 'mongoid'
require 'mongo'

class Tweet
  include Mongoid::Document
  include ActiveModel::Validations

  field :content, type: String
  field :time_created, type: DateTime, default: Time.now
  field :author_id, type: String, default: String.new
  field :original_tweet_id, type: String, default: String.new
  field :likedby, type: Array, default: Array.new
  field :replys, type: Array, default: Array.new

  validates_length_of :content, minimum: 1, maximum: 1000

  has_many :replies
  # belong_one :user

  def add_reply(reply_id)
    new_reply = replys.push(reply_id)
    self.set(replys: new_reply)
  end

  def add_like(user_id)
    new_likedby = likedby.push(user_id)
    self.set(likedby: new_likedby)
  end

  def delete_like(user_id)
    new_likedby = likedby.delete(user_id)
    self.set(likedby: new_likedby)
  end

  def findById(tweet_id)
    return self.where(_id: tweet_id).first
  end
end
