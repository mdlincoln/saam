require 'nokogiri'
require 'csv'
require 'json'

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

# Create full edge list
raw_data.each do |id, data|
	puts id
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
end

puts "Calculating unique topics list"
topic_list.uniq!

puts topic_list
