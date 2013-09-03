require 'csv'
require 'json'
require 'ruby-progressbar'

INPUT = "all_data/JSON/cleaned.json"
OUT_NODES = "all_data/networks/paintings/nodes.csv"
OUT_EDGES = "all_data/networks/paintings/edges.csv"
EDGE_BOUND = 4 # => Define the minimum number of shared topics required to define an edge between nodes
TIME_BEGIN = 1900
TIME_END = 1940

puts "Loading data..."
raw_data = JSON.parse(File.read(INPUT), :symbolize_names => true)
puts "#{raw_data.count} records loaded."
set_data = raw_data.select{|k,v| v[:date].between?(TIME_BEGIN,TIME_END)}
puts "#{set_data.count} records between #{TIME_BEGIN} and #{TIME_END}"


node_list = CSV.open(OUT_NODES,"w")
node_list << ["id","label","date","artist","topics","type","image"]
edge_list = CSV.open(OUT_EDGES,"w")
edge_list << ["source","target","weight","type"]

id_list = Array.new

# Create full node list
puts "Creating node list..."
set_data.each do |id, data|
	id_list << id
	date = data[:date]
	title = data[:title]
	type = data[:type].first
	artist = data["artist"].first unless data["artist"].nil?
	topics = String.new
	data[:topic].each do |t|
		topics.concat("#{t}; ")
	end
	image = "http://ids.si.edu/ids/deliveryService?max=120&id=#{data[:Image]}" # => This gives a link to a small image
	node_list << [id,title,date,artist,topics,type]
end


puts "Calculating potential node combinations..."
combos = id_list.combination(2)
number = combos.count
puts "#{number} possible edges"

prog_bar = ProgressBar.create(:title => "records connected", :starting_at => 0, :total => combos.count, :format => '%p%% |%b>>%i| %c %t')	# => Create a progress bar

puts "Evaluating combinations..."
combos.each do |pair|
	id_one = pair[0]
	id_two = pair[1]
	topics_one = set_data[id_one][:topic]
	topics_two = set_data[id_two][:topic]
	weight = (topics_one & topics_two).count
	if weight > EDGE_BOUND
		edge_list << [id_one,id_two,weight,"Undirected"]
	else
	end
	prog_bar.increment
end
