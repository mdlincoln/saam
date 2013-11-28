#############
# This script will output a frequency list of the values for any given
# attribute you pass into it. For example, the default script searches
# through the `topic` attribute of each object, outputting a table
# with the frequencies of each unique topic.
#############

require 'json'
require 'csv'
require 'ruby-progressbar'

# Define input/output paths
INPUT = "data/JSON/cleaned.json"
OUTPUT = "data/trends/topiclist.csv"

# Initialize the topic list csv
list = CSV.open(OUTPUT,"w")
list << ["topic","count"]

# Load data
puts "Loading data..."
data = JSON.parse(File.read(INPUT), :symbolize_names => true)
raw_topics = Array.new

# Iterate through the collection to create a list of topics
puts "#{data.count} records loaded"
puts "Retrieving topics..."
data.each do |k,v|
	raw_topics << v.values_at(TOPIC.to_sym)
end

# Create a list of unique topics, eliminating repeats
puts "Flattening topic array."
# The raw list is an array of arrays.
# This must be flattened into one long list
raw_topics.flatten!
puts "#{raw_topics.count} topics found."
puts "Saving unique topics..."
unique_topics = raw_topics.uniq

puts "#{unique_topics.count} unique topics saved."

# Count the frequencies of each unique topic and write out to CSV
puts "Counting frequencies..."
prog_bar = ProgressBar.create(:title => "Records counted", :starting_at => 0, :total => unique_topics.count, :format => '%c |%b>>%i| %p%% %t')	# => Create a progress bar

unique_topics.each do |topic|
	list << [topic,raw_topics.count(topic)]
	prog_bar.increment
end

puts "Finished."
