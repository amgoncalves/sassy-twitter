require 'json'
# require 'byebug'
require 'csv'
require 'set'

filename = './seeds/users.csv'
line_count = 300


# names_set = Set.new([])
names_set = Hash.new()
File.open(filename) do |file|
	file.each_line.with_index do |line, index|
		row = CSV.parse_line(line, :col_sep => ",", :headers => false)
		if index < line_count
			# names_set.add(row[1])
			names_set[row[0]] = row[1]
		end
	end
end

File.open("follow_target_payload", "w+") do |f|
	# names_set.each do |login|
	# 	names_set.each do |target|
	f.print('{')
	f.print('"keys":["targeted_id"], ')
	f.print('"values":[')

	names_set.each_with_index do |(targeted_id, target_name), index|
		if index == line_count - 1 
			f.print('["' + targeted_id + '"]')
		else 
			f.print('["' + targeted_id + '"]' + ", ")
		end
	end
	f.print(']')
	f.print('}')
end

File.open("follow_payload", "w+") do |f|
	# names_set.each do |login|
	# 	names_set.each do |target|
	f.print('{')
	f.print('"keys":["login_id", "targeted_id"], ')
	f.print('"values":[')

	names_set.each_with_index do |(login_id, login_name), index1|
		names_set.each_with_index do |(targeted_id, target_name), index2|
			if index1 == line_count - 1 && index2 == line_count - 2 
				f.print('["' + login_id + '",')
				f.print('"' + targeted_id + '"]')
			else 
				if login_id != targeted_id
					f.print('["' + login_id + '",')
					f.print('"' + targeted_id + '"]' + ", ")
				end
			end
		end
	end
	f.print(']')
	f.print('}')
end


File.open("make_user_payload", "w+") do |f|
	f.print('{')
	f.print('"keys":["id", "email","password","handle"], ')
	f.print('"values":[')
	# names_set.each_with_index do |name, index|
	names_set.each_with_index do |(id, name), index|
		if index < line_count - 1
			f.print('["' + id + '",')

			f.print('"' + name + "@loadtest.com" + '",')

			f.print('"' + "pwd" + name + '",')

			f.print('"' + "hand" + name + '"]' + ", ")

		else
			f.print('["' + id + '",')

			f.print('"' + name + "@loadtest.com" + '",')

			f.print('"' + "pwd" + name + '",')

			f.print('"' + "hand" + name + '"]')
		end
	end
	f.print(']')
	f.print('}')
end
