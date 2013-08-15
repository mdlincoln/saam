require 'csv'
require 'json'

INPUT = "data/JSON/cleaned.json"
OUT_NODES = "data/networks/paintings/nodes.csv"
OUT_EDGES = "data/networks/paintings/edges.csv"

puts "Loading data..."
raw_data = JSON.parse(File.read(INPUT))
count = raw_data.count
node_list = CSV.open(OUT_NODES,"w")
node_list << ["id","label","date"]
edge_list = CSV.open(OUT_EDGES,"w")
edge_list << ["source","target","label","type"]


# Create full node list
puts "Creating node list..."
raw_data.each do |id, data|
	date = data["Date"]
	title = data["Title"]
	line = [id,title,date]
	puts line
	node_list << line
end

puts "Creating edge list..."
raw_data.each do |id, data|
	data["Topic"].each do |topic|
		raw_data.select{|k,v| v["Topic"].include?(topic)}.each do |key, value|
			line = [id,key,topic,"Undirected"]
			puts line
			edge_list << line
		end
	end
end

