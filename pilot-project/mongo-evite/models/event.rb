class Event
	include Mongoid::Document

	field :name, type: String
	field :date, type: Date
end
