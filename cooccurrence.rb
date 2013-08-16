require 'csv'
require 'json'

INPUT = "all_data/JSON/cleaned.json"
QUERY = JSON.parse(File.read("query.json"), :symbolize_names => true)
puts QUERY

# query.json should be written as follows:

# [
# 	{"begin": 1750, "end": 1830},
# 	{"begin": 1831, "end": 1865}
# ]

puts "Loading data..."
raw_data = JSON.parse(File.read(INPUT))
edge_list = Array.new

# Create full edge list
puts "Creating edge list..."
raw_data.each do |id, data|
	date = data["Date"]

	label = "#{data["Title"]} - #{id}"
	
	data["Topic"].combination(2).each do |edge|
		edge_list << [edge[0],edge[1],label,"Undirected",date]
	end
end


# Write out query edge lists
puts "Writing CSV files..."
list_header = ["source","target","label","type","date"]
QUERY.each do |q|
	start_date = q[:begin]
	end_date = q[:end]
	filename = "#{start_date}-#{end_date}.csv"
	print "Writing #{filename}..."
	output = CSV.open("all_data/networks/cooccurrence/#{filename}","w")
	output << list_header

	edge_list.select{ |entry| entry[4].between?(start_date,end_date) }.each do |line|
		output << line
	end
	puts "done."
end
