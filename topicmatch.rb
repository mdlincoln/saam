require 'csv'
require 'json'
require 'ruby-progressbar'

INPUT = "data/JSON/cleaned.json"
OUT_NODES = "data/networks/paintings/nodes.csv"
OUT_EDGES = "data/networks/paintings/edges.csv"
EDGE_BOUND = 4 # => Define the minimum number of shared topics required to define an edge between nodes

puts "Loading data..."
raw_data = JSON.parse(File.read(INPUT))
count = raw_data.count
node_list = CSV.open(OUT_NODES,"w")
node_list << ["id","label","date"]
edge_list = CSV.open(OUT_EDGES,"w")
edge_list << ["source","target","weight","type"]

id_list = Array.new

# Create full node list
puts "Creating node list..."
raw_data.each do |id, data|
	id_list << id
	date = data["Date"]
	title = data["Title"]
	node_list << [id,title,date]
end


puts "Calculating potential node combinations..."
combos = id_list.combination(2)

prog_bar = ProgressBar.create(:title => "records connected", :starting_at => 0, :total => combos.count, :format => '|%b>>%i| %p%% %t')	# => Create a progress bar

puts "Evaluating combinations..."
combos.each do |pair|
	id_one = pair[0]
	id_two = pair[1]
	topics_one = raw_data[id_one]["Topic"]
	topics_two = raw_data[id_two]["Topic"]
	weight = (topics_one & topics_two).count
	if weight > EDGE_BOUND
		edge_list << [id_one,id_two,weight,"Undirected"]
	else
	end
	prog_bar.increment
end
