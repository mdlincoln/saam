##################
#
# Creates an edge list (in CSV format) of topic keywords
# connected by edges when they co-exist in an artwork. You may define
# the timespan(s) of your query by writing in `query.json`. Lists are
# written to `data/networks/`
#
###################

require 'csv'
require 'json'

INPUT = "aic/JSON/cleaned.json"
QUERY = JSON.parse(File.read("query.json"), :symbolize_names => true)
puts QUERY

# query.json should be written as follows:

# [
# 	{"begin": 1750, "end": 1830},
# 	{"begin": 1831, "end": 1865}
# ]

puts "Loading data..."
raw_data = JSON.parse(File.read(INPUT), :symbolize_names => true)
edge_list = Array.new

# Create full edge list
puts "Creating edge list..."
raw_data.each do |id, data|
	# Retrieve the artwork date
	date = data[:date]

	# Define the labels for each node
	label = "#{data["Title"]} - #{id}"
	
	# Calculate the various combinations of topics for each artwork.
	# Each of these combinations will be recorded as an edge.
	data[:topic].combination(2).each do |edge|
		edge_list << [edge[0],edge[1],label,"Undirected",date]
	end
end


# Write out query edge lists
puts "Writing CSV files..."
list_header = ["source","target","label","type","date"]
QUERY.each do |q|

	# Initialize the topic CSV
	start_date = q[:begin]
	end_date = q[:end]
	filename = "#{start_date}-#{end_date}.csv"
	print "Writing #{filename}..."
	output = CSV.open("aic/networks/#{filename}","w")
	output << list_header

	edge_list.select{ |entry| entry[4].between?(start_date,end_date) }.each do |line|
		output << line
	end
	puts "done."
end
