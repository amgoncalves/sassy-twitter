require 'mongo'
require 'mongoid'

class Hashtag
	include Mongoid::Document

	field :hashtag_name, type: String
	field :tweets, type: Set, default: []

	validates :hashtag_name, presence: true, uniqueness: true

  def add_tweet(tweet_id)
    new_tweets = self.tweets.add(tweet_id.to_s)
    self.set(tweets: new_tweets)
  end

end


