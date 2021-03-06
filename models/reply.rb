require 'mongoid'
require 'mongo'

class Reply
  include Mongoid::Document
  include ActiveModel::Validations

  field :tweet_id, type: String
  field :content, type: String
  field :time_created, type: DateTime, default: Time.now
  field :replier_id, type: BSON::ObjectId, default: String.new
  field :replier_handle, type: String, default: String.new

  validates_length_of :content, minimum: 1, maximum: 400

  belongs_to :tweet
end