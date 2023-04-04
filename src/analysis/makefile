DATA	=	../../data
TEMP	=	../../gen/temp
OUTPUT	=	../../gen/output

all:	$(OUTPUT)/ordinary_hosts.html	$(OUTPUT)/super_hosts.html	$(OUTPUT)/plot_nrreviews.png	$(OUTPUT)/review_IR.html	$(OUTPUT)/review_IR2.htm	$(OUTPUT)/review_model.html	$(OUTPUT)/plot_rating.png	$(OUTPUT)/tobit1.html	$(OUTPUT)/tobit2.html

$(OUTPUT)/ordinary_hosts.html	$(OUTPUT)/super_hosts.html	$(OUTPUT)/plot_nrreviews.png	$(OUTPUT)/review_IR.html	$(OUTPUT)/review_model.html	$(OUTPUT)/plot_rating.png	$(OUTPUT)/tobit1.html:	$(TEMP)/cleaned_listings1.csv	analysis.R
	R	--vanilla	<	analysis.R  

$(OUTPUT)/review_IR2.htm	$(OUTPUT)/tobit2.html: $(TEMP)/cleaned_listings.csv	analysis.R
	R	--vanilla	<	analysis.R  

