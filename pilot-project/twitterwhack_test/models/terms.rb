class Terms < ActiveRecord::Base
	validates_presence_of :term_one, message: "Term cannot be blank."
	validates_presence_of :term_two, message: "Term cannot be blank."
end
