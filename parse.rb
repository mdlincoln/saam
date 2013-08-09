require 'nokogiri'
require 'csv'
require 'json'

def normalizeDate(input)
	return input.first.slice(/(\d*)(\D|$)/,1).to_i
end

INPUT = "../si-scrape/output.json"
OUTPUT = "out.csv"

puts "Loading input..."
raw_data = JSON.parse(File.read(INPUT))
csv_out = CSV.open(OUTPUT,"w")
csv_out << ["source","target","label","type","date"]

raw_data.each do |id, data|
	puts id
	unless data["Date"].nil?
		date = normalizeDate(data["Date"])
	end

	label = "#{data["Title"]} - #{id}"
	
	unless data["Topic"].nil?
		data["Topic"].combination(2).each do |edge|
			csv_out << [edge[0],edge[1],label,"Undirected",date]
		end
	end
end
