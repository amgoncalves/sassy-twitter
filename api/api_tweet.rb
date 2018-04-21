get "/api/v1/:apitoken/tweets/:id" do
  return build_json_tweets($redis.lrange($globalTL, 0, 50).reverse) unless params[:id] != "recent"
  tweet = Tweet.where(_id: params[:id]).first
  if tweet
    tweet.to_json
  else
    error 404, { :error => "Tweet #{:id} not found." }.to_json
  end
end

def build_json_tweets(tweets)
  hash = Hash.new
  count = 1
  tweets.each do |tweet|
    tweet = tweet.to_json unless tweet.class != Tweet    
    hash["#{count}"] = JSON.parse(tweet)
    count += 1
  end
  hash.to_json  
end
