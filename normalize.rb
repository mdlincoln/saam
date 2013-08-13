require 'nokogiri'
require 'csv'
require 'json'

######### Private methods #########

#  Normalize dates, e.g. "c. 1865" becomes "1865", and "1901-1902" becomes "1902".
def cleanDate(input)
	cleaned = input.first.slice(/(\d*)(\D|$)/,1).to_i
	if cleaned == 0
		return nil
	else
		return cleaned
	end
end

# Takes an array of topics, splits strings that describe a multi-level hierarchy (e.g. "Cityscape\\Chile\\Puerto Monti" becomes ["Cityscape","Chile","Puerto Monti"] and returns an array of total UNIQUE topics)
def cleanTopic(input)

	cleaned_list = Array.new

	# Split up hierarchical keywords
	input.each do |topic|
		topic.split("\\").each do |individual|
			cleaned_list << individual.downcase
		end
	end	

	# Only keep unique records
	return cleaned_list.uniq
end

######### Set input and output files #########
INPUT = "output.json"
OUTPUT = "normalized_saam.json"
puts "Loading raw data..."
raw_data = JSON.parse(File.read(INPUT))
cleaned_data = Hash.new

puts "Number of raw records: #{raw_data.count}"

puts "Cleaning records"
######### Loop through raw input #########
# Only including records that have both "Date" and "Topic"
raw_data.select {|k,v| v.has_key?("Date") && v.has_key?("Topic")}.each do |id, data|
	
	# Clean date
	clean_date = cleanDate(data["Date"])

	# Clean topics
	clean_topics = cleanTopic(data["Topic"])
		
	# Check that normalized values are still valid, e.g. items that had a Date value of "n.d" will no longer be valid after cleaning, and must be discarded
	if clean_date.nil?
		# Skips record
	else
		# Replace original values with normalized values, and store in normalized_data hash
		data["Date"] = clean_date
		data["Topic"] = clean_topics
		cleaned_data[id] = data
	end
end

######### Write JSON file #########

puts "Number of normalied records: #{cleaned_data.count}"

puts "Writing JSON..."
File.open(OUTPUT,"w") do |file|
	file.write(JSON.pretty_generate(cleaned_data))
end
puts "Finished."
