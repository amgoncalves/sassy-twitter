require 'bcrypt'
require 'mongo'
require 'mongoid'

class Profile
<<<<<<< HEAD
	attr_reader :bio, :name

	def initialize(bio = "", name = "", date_joined = "", location = "", name = "")
		@bio, @name, @date_joined, @location, @name = bio, name, date_joined, location, name
	end

	def mongoize 
		[ bio, dob, date_joined, location, name]
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
=======
  attr_reader :bio, :name

  def initialize(bio = "", name = "")
    @bio, @name = bio, name
  end

  def mongoize 
    [ bio, dob, date_joined, location, name]
  end

  class << self
    def demongoize(object)
      Profile.new(object[0], object[1])
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
>>>>>>> ad9a1a2d473f2ac9bd8838e1b35b08f56342a938
end

class User
  include BCrypt
  include Mongoid::Document

  field :user_id, type: Integer
  field :handle, type: String
  field :email, type: String
  field :password, type: String
  field :APItoken, type: String
  field :Profile, type: Profile

  def self.authenticate(params = {})
    return nil if params[:handle].blank? || params[:password].blank?

    @@credentials ||= YAML.load_file(File.join(__dir__, '../credentials.yml'))
    handle = params[:handle].downcase
    return nil if handle != @@credentials['handle']

    password_hash = Password.new(@@credentials['password_hash'])
    User.new(handle) if password_hash == params[:password]
  end
end
