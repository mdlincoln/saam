require 'csv'
require 'json'
require 'ruby-progressbar'

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
	node_list << [id,title,date]
end

prog_bar = ProgressBar.create(:title => "records connected", :starting_at => 0, :total => count, :format => '|%b>>%i| %p%% %t')	# => Create a progress bar

puts "Creating edge list..."
raw_data.each do |id, data|
	data["Topic"].each do |topic|
		raw_data.select{|k,v| v["Topic"].include?(topic)}.each do |key, value|
			 edge_list << [id,key,topic,"Undirected"]
		end
	end
	prog_bar.increment
end

