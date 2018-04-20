get "/api/v2/:apitoken/tweets/:id" do
  return get_recent_tweets unless params[:id] != "recent"
  tweet = Tweet.where(_id: params[:id]).first
  if tweet
    tweet.to_json
  else
    error 404, { :error => "Tweet #{:id} not found." }.to_json
  end
end

def get_recent_tweets
  hash = Hash.new
  count = 1
  tweets = $redis.lrange($globalTL, 0, 50).reverse
  tweets.each do |tweet|
    hash["#{count}"] = JSON.parse(tweet)
    count += 1
  end
  hash.to_json
end
