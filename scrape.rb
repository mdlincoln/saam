require 'nokogiri'
require 'csv'

INPUT = "sample.html"
OUTPUT = "out.csv"

######### Initialize CSV #########

csv_out = CSV.open(OUTPUT, "w")

######### Parse HTML #########

puts "Parsing HTML..."
sample = Nokogiri::HTML(open(INPUT))

sample.css("#contentArtworkKeywords p").each do |keyword|
	string = keyword.content
	string.gsub!(/\n/," ").gsub!("  "," ").strip!
	puts string
end
