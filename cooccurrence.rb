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

INPUT = "output.json"
OUTPUT_ONE = "1800-1849.csv"
OUTPUT_TWO = "1850-1899.csv"
OUTPUT_THREE = "1900-1935.csv"
OUTPUT_FOUR = "1936-1965.csv"
OUTPUT_FIVE = "1965-2011.csv"

raw_data = JSON.parse(File.read(INPUT))
list_header = ["source","target","label","type","date"]
first_pass = Array.new

# Create full edge list
raw_data.each do |id, data|
	unless data["Date"].nil?
		date = normalizeDate(data["Date"])
	end

	label = "#{data["Title"]} - #{id}"
	
	unless data["Topic"].nil?
		data["Topic"].combination(2).each do |edge|
			first_pass << [edge[0],edge[1],label,"Undirected",date]
		end
	end
end

# Initialize CSV files
one = CSV.open(OUTPUT_ONE,"w")
one << list_header
two = CSV.open(OUTPUT_TWO,"w")
two << list_header
three = CSV.open(OUTPUT_THREE,"w")
three << list_header
four = CSV.open(OUTPUT_FOUR,"w")
four << list_header
five = CSV.open(OUTPUT_FIVE,"w")
five << list_header

# Read out files
first_pass.each do |entry|
	case entry[4]
	when 1800...1849 
		one << entry
	when 1850...1899
		two << entry
	when 1900...1935
		three << entry
	when 1936...1965
		four << entry
	when 1966...2011
		five << entry
	else
	end
end
