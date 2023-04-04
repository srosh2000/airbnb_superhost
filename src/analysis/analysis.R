#####################
#####################
### DATA ANALYSIS ###
#####################
#####################

# --- Libraries --- #
library(MASS) # for negative binomial model estimation 
library(ggplot2) # for data visualization 
library(VGAM) #Vector Generalized Linear and Additive Models for Tobit estimation 
library(olsrr) # tools for OLS regression 
library(stargazer)    # well-formatted tables, such as for summary statistics
library(sjPlot) # for creating summary table for regression output 
library(xtable)

# import data with outliers
df <- read.csv(file = "../../gen/temp/cleaned_listings.csv", header = TRUE)

# import data without outliers
df1 <- read.csv(file = "../../gen/temp/cleaned_listings1.csv", header = TRUE)

# --- Descriptive Statistics ---#
# for ordinary hosts
stargazer(subset(df1, df1$superhost == 0), title = "For Ordinary Hosts", type = "html", out = "../../gen/output/ordinary_hosts.html")
# for superhosts
stargazer(subset(df1, df1$superhost == 1), title = "For Super Hosts", type = "html", out = "../../gen/output/super_hosts.html")


# --- Review Volume Model --- #

# Plotting the count of reviews by superhost status 
ggplot(df1, aes(x=nrreview, fill=superhost)) + geom_density() + facet_wrap(~superhost, scale = "free_y") + ggtitle("Variation in the Distribution of Reviews") + labs(y = "Density", x = "Number of Reviews")

# Saving the number of reviews plot 
ggsave("../../gen/output/plot_nrreviews.png")

## Comment: From the plot we see that the unconditional mean of the outcome variable(no. of reviews) is much lower than its variance

# Conditional mean and variances of number of reviews given superhost status 
with(df, tapply(nrreview, superhost, function(x){ sprintf("M(SD) = %1.2f (%1.2f)", mean(x), sd(x))}))
## Comment: The variances within each level of superhost status are higher than the means within each level. These differences suggest that over-dispersion is present and that a negative binomial model would be appropriate. 


# Estimating Negative Binomial Regression 
# Multicollinearity diagnostics 
l1<- lm(nrreview ~ price + superhost +  price*superhost+picture + verification+ capacity+ nrroom+ nrbed+ minnight+ bookability+ entire_home_apt+ hotel_room+ share_room, data = df1 )
ols_vif_tol(l1)
# Model 1a (m2) : NBR with control variables and without outliers 
summary(m1<- glm.nb(nrreview ~ price + superhost + price*superhost + picture + verification+capacity+nrroom+nrbed+minnight+bookability + entire_home_apt + hotel_room+share_room, data = df1))
#Get the confidence intervals for the coefficients by profiling the likelihood function 
est<- cbind(Estimate = coef(m1), confint(m1))
#Exponentiating model coefficients and confidence intervals to get incident rate ratios
review1<- exp(est) 

# Exporting incident ratio output table 

stargazer(review1,               
          title = "Incident Ratios of the Review Model Estimates ( Without Outliers)", 
          model.numbers = FALSE, dep.var.caption = " Number of Reviews", dep.var.labels.include = FALSE,     
          object.names = TRUE, intercept.bottom = FALSE, omit.stat = c("adj.rsq"),            
          star.cutoffs = c(.05,.01, .001), ci = FALSE, single.row = TRUE,                   
          type="html", align = TRUE, header = FALSE, digits = 2, out="../../gen/output/review_IR.html")  


# Model 1b (m2_a): NBR with control variables and with outliers 
summary(m2<- glm.nb(nrreview ~ price + superhost + price*superhost + picture + verification+capacity+nrroom+nrbed+minnight+bookability + entire_home_apt + hotel_room+share_room, data = df))
#Get the confidence intervals for the coefficients by profiling the likelihood function 
est<- cbind(Estimate = coef(m2), confint(m2))
#Exponentiating model coefficients and confidence intervals to get incident rate ratios
review2<- exp(est) 

# Exporting incident ratio output 

stargazer(review2,               
          title = "Incident Ratios of the Review Model Estimates ( With Outliers)", 
          model.numbers = FALSE, dep.var.caption = " Number of Reviews", dep.var.labels.include = FALSE,     
          column.labels = c("Without Outliers", "With Outliers"),
          object.names = TRUE, intercept.bottom = FALSE, omit.stat = c("adj.rsq"),            
          star.cutoffs = c(.05,.01, .001), ci = FALSE, single.row = TRUE,                   
          type="html", align = TRUE, header = FALSE, digits = 2, out="../../gen/output/review_IR2.htm")  


# Compare Negative Binomial Regressions With and Without Outliers

stargazer(m1, m2,               
          title = "Negative Binomial Regression with and without Influential Outlier", 
          model.numbers = FALSE, dep.var.caption = "", dep.var.labels.include = FALSE,     
          column.labels = c("Without Outliers", "With Outliers"),
          object.names = TRUE, intercept.bottom = FALSE, omit.stat = c("adj.rsq"),            
          star.cutoffs = c(.05,.01, .001), ci = FALSE, single.row = TRUE,                   
          type="html", header = FALSE, digits = 2, out="../../gen/output/review_model.html")  


# --- Rating Model --- #

# Plot rating by superhost status 
ggplot(df1, aes(x=rating, fill=superhost)) + geom_density() + facet_wrap(~superhost, scale = "free_y") + ggtitle("Variation in the Distribution of Ratings")+labs(y = "Density", x = "Ratings")

# Saving the number of reviews plot 
ggsave("../../gen/output/plot_rating.png")

# Model 2a(t1): Estimating Tobit with control variables + without outliers 
summary(t1<- vglm(rating ~ price + superhost +  price*superhost+picture + verification+ capacity+ nrroom+ nrbed+ minnight+ bookability+ entire_home_apt+ hotel_room+ share_room, tobit(Lower = 1, Upper = 5), data = df1 ))

# Exporting output results 
res1 <- summary(t1)
sink('../../gen/output/tobit1.html')
print(xtable(coefficients(res1)), title = 'Rating Model without outliers', type='html')
sink()


# Running OLS on model 2a for robustness check 
summary(ols1<- lm(rating ~ price + superhost +  price*superhost+picture + verification+ capacity+ nrroom+ nrbed+ minnight+ bookability+ entire_home_apt+ hotel_room+ share_room, data = df1 ))

# Model 2b(t2): Estimating Tobit with control variables + with outliers 
summary(t2<- vglm(rating ~ price + superhost +  price*superhost+picture + verification+ capacity+ nrroom+ nrbed+ minnight+ bookability+ entire_home_apt+ hotel_room+ share_room, tobit(Lower = 1, Upper = 5), data = df ))

# Exporting tobit output ( with outliers) 
res2<- summary(t2)
sink('../../gen/output/tobit2.html')
print(xtable(coefficients(res2)), title = 'Rating Model with outliers', type='html')
sink()
#Running OLS on model 2b for robustness check 
summary(ols2<- lm(rating ~ price + superhost +  price*superhost+picture + verification+ capacity+ nrroom+ nrbed+ minnight+ bookability+ entire_home_apt+ hotel_room+ share_room, data = df ))

# Calculate 95% CI for the coefficients of the rating model (t1)

b<- coef(t1)
se<- sqrt(diag(vcov(t1)))
cbind(LL = b - qnorm(0.975)* se, UL = b + qnorm(0.975)*se)

# Calculate 95% CI for the coefficients of the rating model (t2)

c<- coef(t2)
se<- sqrt(diag(vcov(t2)))
cbind(LL = b - qnorm(0.975)* se, UL = b + qnorm(0.975)*se)





