class TrendQuery
	def initialize(query_hash)
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

	def start_year
		return @startyear
	end

	def end_year
		return @endyear
	end

	def superset_and?
		return @superset_and
	end

	def superset_parts
		return @superset_parts
	end

	def subset_and?
		return @subset_and
	end

	def subset_parts
		return @subset_parts
	end
end
