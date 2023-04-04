#####################
#####################
### DOWNLOAD DATA ###
#####################
#####################

# --- Creating directories --- #
dir.create("../../data")
dir.create("../../gen")
dir.create("../../gen/temp")
dir.create("../../gen/output")

# --- Download Data --- #
download_data <- function(url, filename){
  download.file(url = url, destfile = paste0(filename, ".csv"))
}

url_listings <- "https://drive.google.com/uc?authuser=0&id=1y1ylt9F9J1KSXAHJ-T2Yp2CMnbKaxpGo&export=download"

download_data(url_listings, "../../data/listings")

