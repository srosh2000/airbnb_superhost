DATA = ../../data
TEMP = ../../gen/temp

all: $(DATA)/listings.csv $(TEMP)/cleaned_listings.csv $(TEMP)/cleaned_listings1.csv

$(DATA)/listings.csv: download_data.R
	R --vanilla < download_data.R

$(TEMP)/cleaned_listings.csv $(TEMP)/cleaned_listings1.csv: $(DATA)/listings.csv cleaning.R
	R --vanilla < cleaning.R