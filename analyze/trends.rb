#########
#
# This script creates a table of the ratios of a given attribute (say,
# keyword, or medium) per year covered by the collection. It will
# iterate year-by-year through the collection, counting artworks that
# match the query criteria (e.g. `v[:topic].include?("domestic")`) and
# calculate the ratio of that number to the total number of artworks
# done in that year.
#
#########

require 'json'
require 'csv'
require 'ruby-progressbar'

######### Define arguments #########

TARGET = "domestic" # Enter primary keyword to be profiled
INPUT = "aic/JSON/cleaned.json"
OUTPUT = "aic/trends/#{TARGET}.csv"

puts "Loading data..."
data = JSON.parse(File.read(INPUT), :symbolize_names => true)
trends = CSV.open(OUTPUT,"w")

# trends << ["year","total paintings","target paintings","ratio"]	# =>  Swap comments for either full table, or ratio column only
trends << [TARGET]

######### Check each year #########
step = 1750 # Enter the year to begin (default to 1750, as this is when SAAM collections begin to get interesting)


puts "Checking all years since #{step} for `#{TARGET}`"

prog_bar = ProgressBar.create(:title => "Years checked", :starting_at => 0, :total => 2013-1750, :format => '%c |%b>>%i| %p%% %t')	# => Create a progress bar

while step < 2012

	###### DEFINE QUERY HERE #######

	# How many total records have that year?
	total = data.select{|k,v| v[:date]==step}.count.to_f

	# How many total records from that year have the target topic?
	with_topic = data.select{|k,v| 
		v[:date]==step && 
		(
			v[:topic].include?("domestic")
		)
		}.count.to_f

	#################################
	
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
	prog_bar.increment
end

puts "Results written to '#{OUTPUT}'"
