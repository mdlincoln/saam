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
csv_out << ["source","target","date"]

index = 0

loop do
	break if index >8300
	######### Parse HTML #########
	puts "At item #{index}"

	sample = Nokogiri::HTML(open("http://collections.si.edu/search/results.htm?fq=object_type%3A%22Paintings%22&q=set_name%3A%22Smithsonian+American+Art+Museum+Collection%22&start=#{index}")) do |config|
		config.noblanks
	end

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
				csv_out << [array[0],array[1],date]
			end
		end
	end
	sleep 2
	index += 20
end
