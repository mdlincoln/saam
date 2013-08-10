require 'nokogiri'
require 'csv'
require 'json'
require 'ruby-progressbar'

def normalizeDate(input)
	return input.first.slice(/(\d*)(\D|$)/,1).to_i
end

def cleanTopic(input)
	topics = input.split("\\")
	case topics.count
	when 1
		return topics[0]
	when 2...10
		return "#{topics[0]} - #{topics[1]}"
	else
	end
end

INPUT = "../si-scrape/output.json"

puts "Loading input..."
raw_data = JSON.parse(File.read(INPUT))
list_header = ["source","target","label","type","date"]
first_pass = Array.new
topic_list = Array.new

prog_bar = ProgressBar.create(:title => "Records processed", :starting_at => 0, :total => raw_data.count, :format => '|%b>>%i| %p%% %t')

# Create full edge list
raw_data.each do |id, data|
	unless data["Date"].nil?
		date = normalizeDate(data["Date"])
	end

	label = "#{data["Title"]} - #{id}"

	unless data["Topic"].nil?
		topic_list = Array.new
		data["Topic"].each do |t|
			topic_list << cleanTopic(t)
		end
		topic_list.combination(2).each do |edge|
			first_pass << [edge[0],edge[1],label,"Undirected",date]
		end
	end
	prog_bar.increment
end

puts "Calculating unique topics list"
topic_list.uniq!

puts topic_list
