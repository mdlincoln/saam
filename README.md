saam
====

Scripts for scraping collection data from the Smithsonian American Art Museum.

These scripts can be used to parse information collected from the Smithsonian Institution using [si-scrape](https://github.com/mdlincoln/si-scrape).
JSON output goes into the `data/json` directory.
(Run `rake` to set up the directories where you can deposit the raw collections data, and where the analytical scripts will output their data.)

## `clean/`

### `downcase.rb`

Downcases each attribute name in the SI JSON.
SI objects can have inconsistent capitalization.
This script tries to standardize that issue.

### `normalize.rb`

Runs several cleaning methods on raw SI json downloaded from SI
scrape, including splitting hierarchical keyword strings, munging
dates, and removing any objects that come without either "date" or
"topic" fields.

## `analyze/`

### `cooccurrence.rb`

Creates an edge list (in CSV format) of topic keywords connected by edges when they co-exist in an artwork.
You may define the timespan(s) of your query by writing in `query.json`.
Lists are written to `data/networks/`, and can easily be loaded into a network analysis software such as [Gephi](https://gephi.org).

#### `query.json`

`query.json` should be written as follows:

````json
[
    {"begin": 1750, "end": 1830},
    {"begin": 1831, "end": 1865}
]
````

This will cause `cooccurrence.rb` to output two node/edge list sets for each defined time period.

### `listtopics.rb`

This script will output a frequency list of the values for any given attribute you pass into it.
For example, the default script searches through the `topic` attribute of each object, outputting a table with the frequencies of each unique topic.

### `topicmatch.rb`

This script will create a node and edge list CSV of artworks connected
when they share more than a set threshold number of keywords. These
node and edge lists are written to `data/networks`, and can then be
loaded into Gephi or similar network visualization software.

### `trends.rb`

This script creates a table of the ratios of a given attribute (say,
keyword, or medium) per year covered by the collection. It will
iterate year-by-year through the collection, counting artworks that
match the query criteria (e.g. `v[:topic].include?("domestic")`) and
calculate the ratio of that number to the total number of artworks
done in that year.

***

[Matthew D. Lincoln](http://matthewlincoln.net) | Ph.D Student, Department of Art History & Archaeology, University of Maryland, College Park
