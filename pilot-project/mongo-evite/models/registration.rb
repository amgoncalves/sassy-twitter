class Registration
	include Mongoid::Document

	field :person_id, type: Integer
	field :event_id, type: Integer
	field :status, type: String
end
