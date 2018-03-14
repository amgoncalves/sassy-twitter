require 'json'
require 'byebug'
require 'csv'

# payload = {}
# payload['tweet'] = Array.new
# File.write('tweet_load', '{'
# CSV.foreach("./seeds/tweets.csv") do |row|
# 	payload['tweet'].push(row[1])
# 	byebug
# end
#
filename = './seeds/tweets.csv'
line_count = File.readlines(filename).size

File.open("tweet_load", "w+") do |f|
	f.print('{')
	f.print('"keys":["tweet"],')
	f.print('"values":[')
	CSV.foreach("./seeds/tweets.csv") do |row|
			f.print('["' + row[1] + '"]' + ",")
			# f.print('"' + row[1] + '"' + ",")
	end


	# csv = CSV.parse(filename, :col_sep => ",", :headers => false)
	# csv.each_with_index do |row, index|
	# 	if index + 1 == csv.length
	# 		 byebug
	# 		f.puts('"' + row[1] + '"')
	# 	else
	# 		f.puts('"' + row[1] + '"' + ",")
	# 	end
	# end


	# CSV.foreach("./seeds/tweets.csv") do |row, line_num|
	# 	if line_num == line_count 
	# 		byebug
	# 		f.puts('"' + row[1] + '"')
	# 	else
	# 		f.puts('"' + row[1] + '"' + ",")
	# 	end
	# end
	f.print(']')
	f.print('}')
end
