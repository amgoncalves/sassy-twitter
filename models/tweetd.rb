require 'mongoid'
require 'mongo'

class Tweetd
  include Mongoid::Document
  include ActiveModel::Validations

  field :content, type: String
  field :time_created, type: DateTime, default: Time.now
  field :userd_id, type: String, default: String.new
  field :author_handle, type: String, default: String.new
  field :original_tweet_id, type: BSON::ObjectId, default: String.new
  field :likedby, type: Set, default: []
  field :replys, type: Array, default: Array.new

  validates_length_of :content, minimum: 1, maximum: 400

  has_many :replies
  belongs_to :userd

  def add_reply(reply_id)
    new_reply = replys.push(reply_id)
    self.set(replys: new_reply)
  end

  def add_like(user_id)
    new_likedby = self.likedby.add(user_id.to_s)
    self.set(likedby: new_likedby)
  end

  def delete_like(user_id)
    new_likedby = self.likedby.delete(user_id.to_s)
    self.set(likedby: new_likedby)
  end

  def findById(tweet_id)
    return self.where(_id: tweet_id).first
  end

  def self.search(query)
    self.where(content: /#{query}/i)
  end  
end