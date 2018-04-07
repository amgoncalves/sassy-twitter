require 'json'
require 'byebug'
require 'csv'
require 'set'

filename = './seeds/users.csv'
line_count = 500


names_set = Set.new([])
File.open(filename) do |file|
	file.each_line.with_index do |line, index|
		row = CSV.parse_line(line, :col_sep => ",", :headers => false)
		if index < line_count
			names_set.add(row[1])
		end
	end
end


File.open("intermediate_follow_payload", "w+") do |f|
	names_set.each do |login|
		names_set.each do |target|
			if login != target 
				f.puts(login + "," + target)
			end
		end
	end
end


File.open("create_user_payload", "w+") do |f|
	f.print('{')
	f.print('"keys":["email","password","handle"], ')
	f.print('"values":[')
	names_set.each_with_index do |name, index|
		if index < line_count - 1
			f.print('["' + name + "@loadtest.com" + '",')

			f.print('"' + "pwd" + name + '",')

			f.print('"' + "hand" + name + '"]' + ", ")

		else
			f.print('["' + name + "@loadtest.com" + '",')

			f.print('"' + "pwd" + name + '",')

			f.print('"' + "hand" + name + '"]')
		end
	end
	f.print(']')
	f.print('}')
end