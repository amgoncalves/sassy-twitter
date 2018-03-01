require 'mongo'
require 'mongoid'

class Hashtag
	include Mongoid::Document

	field :hashtag_name, type: String
	field :Tweets, type: Set, default: []

	validates :hashtag_name, presence: true, uniqueness: true

end

