require 'nokogiri'
require 'csv'

def getContent(input)
	if input == nil
		return nil
	else
		return input.content
	end
end

INPUT = "saved.html"
OUTPUT = "out.csv"

puts "Loading input..."
sample = Nokogiri::HTML(open(INPUT))
csv_out = CSV.open(OUTPUT,"w")
csv_out << ["source","target","type","date"]

sample.css("div.record").each do |record|

	raw_date = getContent(record.at_css("dd.date-first"))
	if raw_date.nil?
		# Skip and go to next record
	else
		date = raw_date.slice(/(\d*)(\D|$)/,1)
		keywords = Array.new
		# Get keywords
		puts
		print "#{date} Keyword combos: "
		keywords << getContent(record.at_css("dd.topic-first"))
		record.css("dd.topic").each do |subtopic|
			keywords << getContent(subtopic)
		end
		keywords.combination(2).each do |array|
			print "#"
			csv_out << [array[0],array[1],"Undirected",date]
		end
	end
end