require 'json'
require 'byebug'
require 'csv'

filename = './seeds/tweets.csv'
line_count = File.readlines(filename).size
line_count = 100


File.open("tweet_load", "w+") do |f|
	f.print('{')
	f.print('"keys":["tweet"], ')
	f.print('"values":[')
	line_count = 500
	File.open(filename) do |file|
		file.each_line.with_index do |line, index|
			row = CSV.parse_line(line, :col_sep => ",", :headers => false)
			if index < line_count
				f.print('["' + row[1] + '"]' + ", ")
			else
				f.print('["' + row[1] + '"]')
				break
			end
		end
	end
	f.print(']')
	f.print('}')
end

File.open("reply_load", "w+") do |f|
  f.print('{')
  f.print('"keys":["reply"], ')
  f.print('"values":[')
  line_count = 500
  File.open(filename) do |file|
    file.each_line.with_index do |line, index|
      row = CSV.parse_line(line, :col_sep => ",", :headers => false)
      if index < line_count
        f.print('["' + row[1] + '"]' + ", ")
      else
        f.print('["' + row[1] + '"]')
        break
      end
    end
  end
  f.print(']')
  f.print('}')
end
