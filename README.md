# Debug makefiles using `remake`
This is an example repository meant to accompany the building block on debugging makefiles using `remake`. 


## Repository overview

```bash

├── Airbnb data.Rproj
├── README.md
├── data
│   └── listings.csv
├── gen
│   ├── output
│   │   ├── ordinary_hosts.html
│   │   ├── plot_nrreviews.png
│   │   ├── plot_rating.png
│   │   ├── review_IR.html
│   │   ├── review_IR2.htm
│   │   ├── review_model.html
│   │   ├── super_hosts.html
│   │   ├── tobit1.html
│   │   └── tobit2.html
│   └── temp
│       ├── cleaned_listings.csv
│       └── cleaned_listings1.csv
├── makefile
├── report
│   ├── report.Rmd
│   └── report.html
└── src
    ├── analysis
    │   ├── Rplots.pdf
    │   ├── analysis.R
    │   └── makefile
    └── data-preparation
        ├── cleaning.R
        ├── download_data.R
        └── makefile
        
```



## Running instructions

To replicate the workflow of the AirBnb_Superhosts project, please follow the instructions below:

1. Install *make* following [the instructions on Tilburg Science Hub](https://tilburgsciencehub.com/building-blocks/configure-your-computer/automation-and-workflows/make/)
2. Install *R* and *RStudio* following [the instructions on Tilburg Science Hub](https://tilburgsciencehub.com/building-blocks/configure-your-computer/statistics-and-computation/r/)
3. Open *RStudio* and copy the line of code below to the "console" interface, followed by pressing return:
 
*install.packages(c("tidyverse", "dplyr", "lubridate", "gtsummary", "readr", "expss", "plyr", "stringr", "MASS", "ggplot2", "VGAM", "olsrr", "stargazer", "sjPlot", "xtable"))* 

5. Download the *src* folder with all the R scripts from the AirBnb_Superhosts root repository to a path of your liking
6. Download *makefile* in the root of the repository to the same path as the *src* folder
7. Open the command prompt and navigate to the path with both the *src* folder and *makefile* included
8. Type *"make"* and press return to generate the workflow 


