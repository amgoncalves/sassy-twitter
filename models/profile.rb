require 'mongo'
require 'mongoid'

class Profile
	include Mongoid::Document
	attr_reader :bio, :dob, :date_joined, :location, :name

	field :date_joined, type: Date, default: Date.today
	field :dob, type: Date, default: nil

	def initialize(bio = "", dob= nil, date_joined = Date.today, location = "", name = "")
		@bio, @dob, @date_joined, @location, @name = bio, dob, date_joined, location, name
	end

	def mongoize 
		[ @bio, @dob, @date_joined, @location, @name]
	end

	class << self
		def demongoize(object)
			Profile.new(object[0], object[1], object[2], object[3], object[4])
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
