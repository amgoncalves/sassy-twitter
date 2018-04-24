require 'mongo'
require 'mongoid'

class PersonalTL
  include Mongoid::Document

  field :user_id, type: String, default: String.new
  field :tweets, type: Array, default: Array.new

  def add_tweet(tweet_id)
    nxt_tweets = tweets.push(tweet_id)
    if nxt_tweets.size > 50
      tweets.shift
    end
    self.set(tweets: nxt_tweets)
  end

end