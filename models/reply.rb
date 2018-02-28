require 'mongoid'
require 'mongo'

class Reply
  include Mongoid::Document
  include ActiveModel::Validations

  field :tweet_id, type: String
  field :content, type: String
  field :time_created, type: DateTime, default: Time.now
  # field :user_id, type: Integer

  validates_length_of :content, minimum: 1, maximum: 100

  # belongs_to :user
  belongs_to :tweet
end