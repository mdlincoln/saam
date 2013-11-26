require 'json'
require 'csv'
require 'ruby-progressbar'

INPUT = "all_data/JSON/cleaned.json"
OUTPUT = "all_data/trends/topiclist.csv"

list = CSV.open(OUTPUT,"w")
list << ["topic","count"]


puts "Loading data..."
data = JSON.parse(File.read(INPUT), :symbolize_names => true)
raw_topics = Array.new

puts "#{data.count} records loaded"
puts "Retrieving topics..."
data.each do |k,v|
	raw_topics << v.values_at(:Topic)
end

puts "Flattening topic array."
raw_topics.flatten!

puts "#{raw_topics.count} topics found."
puts "Saving unique topics..."
unique_topics = raw_topics.uniq

puts "#{unique_topics.count} unique topics saved."

puts "Counting frequencies..."
prog_bar = ProgressBar.create(:title => "Records counted", :starting_at => 0, :total => unique_topics.count, :format => '%c |%b>>%i| %p%% %t')	# => Create a progress bar

unique_topics.each do |topic|
	list << [topic,raw_topics.count(topic)]
	prog_bar.increment
end

puts "Finished."
