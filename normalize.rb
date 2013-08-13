require 'nokogiri'
require 'csv'
require 'json'


#  Normalize dates, e.g. "c. 1865" becomes "1865", and "1901-1902" becomes "1902".
def normalizeDate(input)
	if input.nil?
		return nil
	else
		normalized = input.first.slice(/(\d*)(\D|$)/,1).to_i
		if normalized == 0
			return nil
		else
			return normalized
		end
	end
end

# Returns a given number of topics from SAAM's hierarchical schema, e.g. "Study\botanical study\American mistletoe" can be reduced to "Study\botanical study" or "Study"
def cleanTopic(input)
	if input.nil?
		return nil
	else
		topics = input.split("\\")
		case topics.count
		when 1
			return topics[0]
		when 2...10
			return "#{topics[0]} - #{topics[1]}"
		else
		end
	end
end

# Set input and output files
INPUT = "output.json"
OUTPUT = "normalized_saam_two_topics.json"
raw_data = JSON.parse(File.read(INPUT))
normalized_data = Hash.new

# Loop through raw input
raw_data.each do |id, data|
	# Only include records that have both "Date" and "Topic"
	unless data["Date"].nil? or data["Topic"].nil?

		# Normalize date
		normalized_date = normalizeDate(data["Date"])

		# Normalize topics
		normalized_topics = Array.new
		data["Topics"].each do |topic|
			normalized_topics << cleanTopic(topic)
		end

		# Check that normalized values are still valid, e.g. items that had a Date value of "n.d" will no longer be valid after cleaning, and must be discarded
		if normalized_date.nil? or normalized_topics.empty?
			# Skips record
		else
			# Replace original values with normalized values, and store in normalized_data hash
			data["Date"] = normalized_date
			data["Topics"] = normalized_topics
			normalized_data[id] = data
		end
	else
		# Skips record
	end
end

######### Write JSON file #########
puts "Writing JSON..."
File.open(OUTPUT,"w") do |file|
	file.write(JSON.pretty_generate(normalized_data))
end
puts "Finished."
