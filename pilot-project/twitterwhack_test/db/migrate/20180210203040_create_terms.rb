class CreateTerms < ActiveRecord::Migration[5.1]
  def change
	  create_table :terms do |t|
		  t.string :term_one
		  t.string :term_two
	  end
  end
end
