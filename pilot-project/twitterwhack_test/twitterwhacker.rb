require 'twitter'
require 'pry-byebug'
 
class TwitterWhacker
  attr_accessor :client, :results_first, :results_second, :results_both, :score, :index
  MAX_RESULTS = 100

  def initialize
    @client = Twitter::REST::Client.new do |config|
      config.consumer_key = "jyA1rgwVcyejvvi2MXdHUQYJS"
      config.consumer_secret = "juCU454rLLimxmAugv4mgJXzpJDuiRXF1bTUR8Pj9XBJW911kx"
      config.access_token = "946869380-x54owOtkOnbs9PKSCRnZ9UMBy0gJVJD2jTyIldIJ"
      config.access_token_secret = "KwowEU4LHDP2qggkFT4OghtP99Ojws9MAHo6HbPcRd9Em"
    end
  end

  def search_first(term_one)
	  @results_first = self.client.search(term_one, result_type: "recent").take(MAX_RESULTS).length
  end

  def search_second(term_two)
	  @results_second = self.client.search(term_two, result_type: "recent").take(MAX_RESULTS).length
  end

  def search_both(term_one, term_two)
	  # @results_both = self.client.search(term_one + " " + term_two, result_type: "recent").take(MAX_RESULTS).collect do |tweet|
		  # # "#{tweet.user.screen_name}: #{tweet.text}"
		  # Array([tweet.user.screen_name, tweet.text])
	  # end
	   @results_hash= self.client.search(term_one + " " + term_two, result_type: "recent", tweet_mode: "extended", count: MAX_RESULTS).to_h()[:statuses]
	   @results_both = @results_hash.collect do |res|
		   Array([res[:user][:screen_name], res[:full_text]])
	   end
  end

  def compute_score()
	  @score = @results_first * @results_second
  end

  def compute_index()
	  @index = @results_both.length
  end

  def example_tweet()
	if @index == 0
		res = ['anyone', 'There is no tweet which contains both the terms.']
	else
		rdm = Random.new()
		example_idx = rdm.rand(@index)
		res = @results_both[example_idx]
	end
  end

  def comment()
	  if @index == 0
		  "You got whacked!"
	  elsif @index <= 5
		  "Excellent!"
	  elsif @index <= 20
		  "Pretty Good!"
	  elsif @index <= 50
		  "Not bad."
	  elsif @index <= 70
		  "It's all right!"
	  elsif @index < 90
		  "Not good."
	  elsif @index >= 90
		  "Try again!"
	  end
  end
end
