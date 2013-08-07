require 'nokogiri'
require 'open-uri'

OUTPUT = "saved.html"

######### Initialize CSV #########

html_out = File.open(OUTPUT, "w")
index = 0

loop do
	######### Parse HTML #########
	puts "At item #{index}"

	sample = Nokogiri::HTML(open("http://collections.si.edu/search/results.htm?fq=object_type%3A%22Paintings%22&q=set_name%3A%22Smithsonian+American+Art+Museum+Collection%22&start=#{index}")) do |config|
		config.noblanks
	end

	sample.css("div.record").each do |record|
		html_out << record
	end


	sleep 2
	index += 20
	break if index >8300
end

puts "Finished"
