require 'mongo'
require 'mongoid'

class PersonalTL
  include Mongoid::Document

  field :user_id, type: String
  field :tweets, type: Array, default: Array.new

  def add_tweet(tweet_id)
    nxt_tweets = tweets.push(tweet_id)
    self.set(tweets: nxt_tweets)
    nxt_ntweets = ntweets + 1
    self.set(ntweets: nxt_ntweets)
  end

end