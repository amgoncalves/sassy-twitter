require 'mongo'
require 'mongoid'

class Profile
  include Mongoid::Document

	field :date_joined, type: String, default: ""
	field :dob, type: String, default: ""
	field :bio, type: String, default: ""
	field :location, type: String, default: ""
	field :name, type: String, default: ""

	def initialize(params)
		super
	end

	def mongoize 
		[ bio, dob, date_joined, location, name]
	end

	class << self
		def demongoize(object)
			profile_hash = {:bio => object[0], :dob => object[1], :date_joined => object[2], :location => object[3], :name => object[4]}
			Profile.new(profile_hash)
		end

		def mongoize(object)
			case object
			when Profile then object.mongoize
			else object
			end
		end

		def evolve(object)
			case object
			when Profile then object.mongoize
			else object
			end

		end
	end
end
