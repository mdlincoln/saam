require 'json'
require 'csv'

######### Define arguments #########

INPUT = "data/JSON/cleaned.json"
TARGET = "mountain" # Enter primary keyword to be profiled
OUTPUT = "data/trends/#{TARGET}.csv"

puts "Loading data..."
data = JSON.parse(File.read(INPUT))
trends = CSV.open(OUTPUT,"w")

# trends << ["year","total paintings","target paintings","ratio"]	# =>  Swap comments for either full table, or ratio column only
trends << [TARGET]

######### Check each year #########
step = 1750 # Enter the year to begin (default to 1750, as this is when SAAM collections begin to get interesting)

puts "Checking all years since #{step} for `#{TARGET}`"
while step < 2012

	# How many total records have that year?
	total = data.select{|k,v| v["Date"]==step}.count.to_f

	# How many total records from that year have the target topic?
	with_topic = data.select{|k,v| 
		v["Date"]==step && 
		(
			v["Topic"].include?("mountain")
		)
		}.count.to_f
	
	# Calculate the ratio of ptgs with topic to total paintings that year
	if total == 0
		ratio = 0
	else
		ratio = with_topic / total
	end

	# Write out row to CSV
	# trends << [step,total,with_topic,ratio]	# => switch on to output full table
	trends << [ratio]

	# Increment to the next year
	step += 1
end

puts "Results written to '#{OUTPUT}'"
