require 'nokogiri'
require 'csv'

INPUT = "si.html"
OUTPUT = "out.csv"

######### Initialize CSV #########

csv_out = CSV.open(OUTPUT, "w")
csv_out << ["title","keywords"]

######### Parse HTML #########

puts "Parsing HTML..."
sample = Nokogiri::HTML(open(INPUT)) do |config|
	config.noblanks
end

sample.css("div .record").each do |record|

	# Record info
	title = record.at_css("h2.title").content
	keywords = Array.new

	# Get keywords
	keywords << record.at_css("dd.topic-first").content
	record.css("dd.topic").each do |subtopic|
		keywords << subtopic.content
	end
	csv_out << [title,keywords]
end
