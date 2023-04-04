#####################
#####################
### CLEANING DATA ###
#####################
#####################
 
# --- Create an usable data set --- #


# --- Libraries --- #
library(tidyverse)
library(dplyr)
library(lubridate)
library(gtsummary)
library(readr)
library(expss)
library(plyr)
library(stringr)

# import raw data set listings.csv
listings <- read.csv(file = "../../data/listings.csv", header = TRUE)

# create a new data frame
df <- select(listings, 
             "host_is_superhost", 
             "host_has_profile_pic", 
             "host_identity_verified", 
             "room_type",
             "accommodates",
             "bedrooms",
             "beds",
             "price",
             "minimum_nights",
             "number_of_reviews",
             "review_scores_rating",
             "instant_bookable")

# change variable names
colnames(df) <- c("superhost",
                  "picture",
                  "verification",
                  "roomtype",
                  "capacity",
                  "nrroom",
                  "nrbed",
                  "price",
                  "minnight",
                  "nrreview",
                  "rating",
                  "bookability")


# Creating dummies for the boolean variables
df$superhost<-ifelse(df$superhost == "t",1,0)
df$picture<-ifelse(df$picture=="t",1,0)
df$verification<-ifelse(df$verification=="t",1,0)
df$bookability<-ifelse(df$bookability=="t" ,1,0)

#Convert dummies to factor class 

df$superhost<- as.factor(df$superhost)
df$picture<- as.factor(df$picture)
df$verification<- as.factor(df$verification)
df$bookability<- as.factor(df$bookability)


# --- Variable cleaning if applicable --- #

# --- Capacity --- #

# delete NAs from data set
na.omit(df$capacity)

# --- Price --- #

# delete "$" string from price variable 
df$price <- str_remove_all(df$price, "[$]") 

# transform price variable into a numeric variable
df$price <- as.numeric(df$price)

# replace missing values in price column with median
df$price[is.na(df$price)]<-median(df$price,na.rm=TRUE)

# --- Rating --- #

# replace missing values in rating column with median 
df$rating[is.na(df$rating)]<-median(df$rating,na.rm=TRUE)

# --- Room Type --- #

# create dummy variables for the room type
df$entire_home_apt<-ifelse(df$roomtype=="Entire home/apt",1,0)
df$hotel_room<-ifelse(df$roomtype=="Hotel room",1,0)
df$private_room<-ifelse(df$roomtype=="Private room",1,0)
df$share_room<-ifelse(df$roomtype=="Shared room" ,1,0)
# convert room type dummies to factors 
df$entire_home_apt<-as.factor(df$entire_home_apt)
df$hotel_room<-as.factor(df$hotel_room)
df$private_room<-as.factor(df$private_room)
df$share_room<-as.factor(df$share_room)

# --- Check for duplicates and NAs--- # 

# remove duplicates
df <- df %>% 
  filter(!duplicated(df))

# remove NA's 
df <- 
  na.omit(df)

# --- Arrange and filter data --- #

# arrange data by room type and superhost == 1
df <- df %>% 
  arrange(df$roomtype, desc(df$superhost)) 


# --- Outlier detection and filter data --- #

# filter data by price > 0 & number of reviews > 0
df<- filter(df, df$price > 0 & df$nrreview > 0)

# Removing outliers ( using percentile method) from price 
lower_bound<- quantile(df$price, 0.025)
lower_bound 
upper_bound<- quantile(df$price, 0.975)
upper_bound 

df1<- filter(df, price <=400)

# Removing outliers ( using percentile method) from nrreview 

lower_bound<- quantile(df$nrreview, 0.025)
lower_bound 
upper_bound<- quantile(df$nrreview, 0.975)
upper_bound 

df1<- filter(df1, nrreview<=205)



# Removing outliers ( using percentile method) from nrroom 

lower_bound<- quantile(df$nrroom, 0.025)
lower_bound 
upper_bound<- quantile(df$nrroom, 0.975)
upper_bound 

df1<- filter(df1, nrroom<=4)

# Removing outliers ( using percentile method) from nrbed 

lower_bound<- quantile(df$nrbed, 0.025)
lower_bound 
upper_bound<- quantile(df$nrbed, 0.975)
upper_bound 


df1<- filter(df1, nrbed <= 5)

# Removing outliers ( using percentile method) from minnight 

lower_bound<- quantile(df$minnight, 0.025)
lower_bound 
upper_bound<- quantile(df$minnight, 0.975)
upper_bound 


df1<- filter(df1, minnight<=10)



# Save clean airbnb dataset as .csv
# dataset below is before filtering outliers to facilitate some comparisons for robustness 
#write.csv(df, "../../gen/temp/cleaned_listings.csv") # commented out for illustration purposes about remake
# dataset below is after filtering outliers 
#write.csv(df1, "../../gen/temp/cleaned_listings1.csv") # commented out for illustration purposes about remake

summary(df)
summary(df1)


