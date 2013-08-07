require 'nokogiri'
require 'csv'
require 'open-uri'

def getContent(input)
	if input == nil
		return nil
	else
		return input.content
	end
end

INPUT = "si.html"
OUTPUT = "out.csv"

######### Initialize CSV #########

csv_out = CSV.open(OUTPUT, "w")
csv_out << ["source","target"]

index = 0

loop do
	break if index >8300
	######### Parse HTML #########
	puts "At item #{index}"

	sample = Nokogiri::HTML(open("http://collections.si.edu/search/results.htm?fq=object_type%3A%22Paintings%22&q=set_name%3A%22Smithsonian+American+Art+Museum+Collection%22&start=#{index}")) do |config|
		config.noblanks
	end

	sample.css("div .record").each do |record|

		keywords = Array.new

		# Get keywords
		puts
		print "Keyword combos: "
		keywords << getContent(record.at_css("dd.topic-first"))
		record.css("dd.topic").each do |subtopic|
			keywords << getContent(subtopic)
		end
		keywords.combination(2).each do |array|
			print "#"
			csv_out << array
		end
	end
	sleep 2
	index += 20
end
