require 'json'

INPUT = "all_data/JSON/cleaned.json"
OUTPUT = "all_data/JSON/downcase.json"
puts "Loading raw data..."
raw_data = JSON.parse(File.read(INPUT))
cleaned_data = Hash.new

puts "Downcasing"
raw_data.each do |id,data|
	new_data = Hash.new
	data.each do |attribute,value|
		new_attribute = attribute.downcase.sub(/\W/,"_").to_sym
		new_data[new_attribute] = value
	end
	cleaned_data[id] = new_data
end

puts "Writing JSON..."
File.open(OUTPUT,"w") do |file|
	file.write(JSON.pretty_generate(cleaned_data))
end
puts "Finished."
