require 'pry-byebug'
require 'sinatra'
require 'sinatra/activerecord'
require_relative './models/terms'
require_relative './twitterwhacker'
require 'jquery-cdn'

# set :public_folder, File.dirname(__FILE__) + '/public'

JqueryCdn.local_url = proc { '/jquery.js'}

get '/' do
	erb :index
end

post '/results' do
	@tw = TwitterWhacker.new()
	@terms = Terms.new(params[:terms])

	@tw.search_first(@terms.term_one)
	@tw.search_second(@terms.term_two)
	@tw.search_both(@terms.term_one, @terms.term_two)

	@idx = @tw.compute_index()
	@score = @tw.compute_score()

	@example_tweet = @tw.example_tweet()
	@comment = @tw.comment()

	erb :results
end


