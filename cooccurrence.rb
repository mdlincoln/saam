require 'csv'
require 'json'

INPUT = "data/JSON/cleaned.json"
QUERY = JSON.parse(File.read("query.json"), :symbolize_names => true)
puts QUERY

# query.json should be written as follows:

# [
# 	{
# 		"begin": 1750,		=> Lower bound
# 		"end": 1830			=> Upper bound
# 	},... => Additional queries follow this
# ]

puts "Loading data..."
raw_data = JSON.parse(File.read(INPUT))
first_pass = Array.new

# Create full edge list
puts "Creating edge list..."
raw_data.each do |id, data|
	date = data["Date"]

	label = "#{data["Title"]} - #{id}"
	
	data["Topic"].combination(2).each do |edge|
		first_pass << [edge[0],edge[1],label,"Undirected",date]
	end
end


# Write out query edge lists
puts "Writing CSV files..."
list_header = ["source","target","label","type","date"]
QUERY.each do |v|
	start_date = v[:begin]
	end_date = v[:end]
	filename = "#{start_date}-#{end_date}.csv"
	print "Writing #{filename}..."
	output = CSV.open("data/networks/test/#{filename}","w")
	output << list_header

	first_pass.select{ |entry| entry[4].between?(start_date,end_date) }.each do |line|
		output << line
	end
	puts "done."
end
