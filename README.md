saam
====

Scripts for scraping collection data from the Smithsonian American Art Museum.

These scripts can be used to parse information collected from the Smithsonian Institution using [si-scrape](https://github.com/mdlincoln/si-scrape).
JSON output goes into the `data/json` directory.
(Run `rake` to set up the directories to receive the collections data.)

## `clean/`

### `downcase.rb`

Downcases each attribute name in the SI JSON.
SI objects can have inconsistent capitalization.
This script tries to standardize that issue.

### `normalize.rb`

## `analyze/`

### `cooccurrence.rb`

#### `query.json`

### `listtopics.rb`

### `topicmatch.rb`

### `trends.rb`

***

[Matthew D. Lincoln](http://matthewlincoln.net) | Ph.D Student, Department of Art History & Archaeology, University of Maryland, College Park
