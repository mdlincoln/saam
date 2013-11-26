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

### `topicmatch.rb`

### `trends.rb`

***

[Matthew D. Lincoln](http://matthewlincoln.net) | Ph.D Student, Department of Art History & Archaeology, University of Maryland, College Park
