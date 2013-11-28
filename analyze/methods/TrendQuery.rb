# An attempt to define a query object for trends.rb

require 'JSON'

class TrendQuery

	attr_accessor :startyear, :endyear, :superset_and, :superset_parts, :subset_and, :subset_parts

	def initialize(query_file)
		query_hash = JSON.parse(query_file, :symbolize_names => true)
		@startyear = query_hash[:startyear]
		@endyear = query_hash[:endyear]
		
		@superset_and = query_hash[:superset][:and]
		@superset_parts = query_hash[:superset][:parts]

		@subset_and = query_hash[:subset][:and]
		@subset_parts = query_hash[:subset][:parts]
	end

	public

	def inspect
		return "Start date: #{@startyear}; End date: #{@endyear}\nSuperset => Inclusive? #{@superset_and}; Parts: #{@superset_parts}\nSubset => Inclusive? #{@subset_and}; Parts: #{@subset_parts}"
	end
end
