require 'json'
require 'csv'

INPUT = "data/cleaned.json"
TARGET = "figure(s) in interior"
OUTPUT = "data/#{TARGET}.csv"

puts "Loading data..."
data = JSON.parse(File.read(INPUT))
trends = CSV.open(OUTPUT,"w")
trends << ["year","total paintings","topic paintings", TARGET]

step = 1750

while step < 2012
	puts step
	total = data.select{|k,v| v["Date"]==step}.count.to_f
	with_topic = data.select{|k,v| v["Date"]==step && v["Topic"].include?(TARGET)}.count.to_f
	
	if total == 0
		ratio = 0
	else
		ratio = with_topic / total
	end

	trends << [step,total,with_topic,ratio]

	step += 1
end


