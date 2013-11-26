#####################
#
# Downcases each attribute name in the SI JSON
# SI objects can have inconsistent capitalization
# This script tries to standardize that issue
#
######################

require 'json'

# Define input and output paths
INPUT = "all_data/JSON/cleaned.json"
OUTPUT = "all_data/JSON/downcase.json"

# Load JSON file into a hash
puts "Loading raw data..."
raw_data = JSON.parse(File.read(INPUT))

# Create hash to store cleaned data
cleaned_data = Hash.new

# Iterate through each object in the hash and downcase 
# each attribute key
puts "Downcasing"
raw_data.each do |id,data|
	new_data = Hash.new
	data.each do |attribute,value|
		new_attribute = attribute.downcase.sub(/\W/,"_").to_sym
		new_data[new_attribute] = value
	end
	cleaned_data[id] = new_data
end

# Output hash to JSON file
puts "Writing JSON..."
File.open(OUTPUT,"w") do |file|
	file.write(JSON.pretty_generate(cleaned_data))
end
puts "Finished."
