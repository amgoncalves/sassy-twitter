require 'mongo'
require 'mongoid'

class Profile
  include Mongoid::Document
  
	# attr_reader :bio, :dob, :date_joined, :location, :name

	field :date_joined, type: Date, default: Date.today
	field :dob, type: Date, default: Date.jd(0)
	field :bio, type: String, default: ""
	field :location, type: String, default: ""
	field :name, type: String, default: ""

	# def initialize(bio = "", dob = Date.jd(0), date_joined = Date.today, location = "", name = "")
	# 	@bio, @dob, @date_joined, @location, @name = bio, dob, date_joined, location, name
	# 	instance_variable_set("@bio", @bio)
	# 	instance_variable_set("@dob", @dob)
	# 	instance_variable_set("@date_joined", @date_joined)
	# 	instance_variable_set("@location", @location)
	# 	instance_variable_set("@name", @name)
	# end

	def initialize(params)
		super
	end

	def mongoize 
		[ bio, dob, date_joined, location, name]
	end

	class << self
		def demongoize(object)
			# Profile.new(object[0], object[1], object[2], object[3], object[4])
			profile_hash = {:bio => object[0], :dob => object[1].to_date, :date_joined => object[2].to_date, :location => object[3], :name => object[4]}
			# profile_hash.each { |key, value| profile_hash[key] = ""}
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
