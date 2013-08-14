require 'csv'
require 'json'

INPUT = "data/JSON/cleaned.json"
QUERY = JSON.parse(File.read("query.json"))

raw_data = JSON.parse(File.read(INPUT))
first_pass = Array.new

# Create full edge list
raw_data.each do |id, data|
	date = data["Date"]

	label = "#{data["Title"]} - #{id}"
	
	data["Topic"].combination(2).each do |edge|
		first_pass << [edge[0],edge[1],label,"Undirected",date]
	end
end


# Write out query edge lists
list_header = ["source","target","label","type","date"]
QUERY.each do |k,v|
	output = CSV.open("data/networks/test/#{k}.csv","w")
	output << list_header

	start_date = v["begin"]
	end_date = v["end"]

	first_pass.select{ |entry| entry[4].between?(start_date,end_date) }.each do |line|
		output << line
	end
end
