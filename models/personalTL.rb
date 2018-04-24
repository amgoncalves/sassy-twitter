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

  def remove_tweet(tweet_id)
    if tweets.size = 0 || tweets.include?(tweet_id)
      nxt_tweets = tweets.delete(tweet_id)
      self.set(tweets: nxt_tweets) 
    end
  end

  def add_tweet_list(new_tweets)
    nxt_tweets = tweets + new_tweets
    self.set(tweets: nxt_tweets)
  end

  def remove_tweet_list(remove_tweets)
    nxt_tweets = tweets - remove_tweets
    self.set(tweets: nxt_tweets)
  end

end