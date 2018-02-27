class Persn
	include Mongoid::Document

	field :name, type: String
	field :date_of_birth, type: Date
	field :gender, type: String
	field :zipcode, type: String
	# field :bio, type: String
end
