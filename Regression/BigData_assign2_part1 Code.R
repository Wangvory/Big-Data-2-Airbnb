#Big Data 2 Group Project Assignment 2
#Group BD5
library(Metrics)
library(caret)
library(lmtest)
library(sandwich)
library(mgcv)
library(robustbase)
library(MASS)
library(car)
library(plyr)
library(pastecs)
library(Hmisc)
library(psych)
library(stringr)
library(varhandle)
library(tidyverse)
library(forecast)
library(leaps)
library(mlbench)
library(caret)
library(randomForest)
library(forecast)
library(zoo)

clean3<- read.csv("/Users/zhoujiawang/Desktop/Brandeis Life/BigData2/ABB Data Raw/Data Visualize/clean_V3.csv", header=TRUE)
clean3<-na.omit(clean3)
str(clean3)
attach(clean3)

# define the control using cross
control <- trainControl(method="cv", number=5)
model <- train(average_price~., data=clean3,method='lm',trControl=control)
importance <- varImp(model, scale=FALSE)
# summarize importance
print(importance)
plot(importance)

library(mlbench)
library(caret)
control <- rfeControl(functions=rfFuncs, method="cv", number=10)
# run the RFE algorithm
x <- clean3[,1:42]
y <-clean3[,43]
sizes <- c(10,20,30,40,50,60)
results <- rfe(x, y, sizes=sizes, rfeControl=control)
# summarize the results
print(results)
# list the chosen features
predictors(results)
# plot accuracy versus the number of features
plot(results, type=c("g", "o"))

library(ggplot2)
library(ggExtra)
library(hrbrthemes)

#1. Show descriptive statistics for relevant and important variables.
# Y
describe(average_price)
summary(average_price)
stat.desc(average_price)
clean3 %>%
  ggplot( aes(x=average_price)) +
  geom_density(fill="#69b3a2", color="#e9ecef", alpha=0.8)+
  ggtitle("average_price Density Plot")

#box-and-whisker plots for relevant and important variables.
#Bed Type
ggplot(data=clean3, aes(x=bed_type, group=bed_type, fill=bed_type)) +
  geom_density(alpha=.4)
clean3 %>%
  ggplot( aes(x=bed_type, y=average_price, fill=bed_type)) +
  geom_boxplot() +
  ggtitle('Bed Types versus price box-and-whisker plot') +
  xlab("Bed Types")+
  ylab("room prices")
#room type
ggplot(data=clean3, aes(x=room_type, group=room_type, fill=room_type)) +
  geom_density(alpha=.4)
clean3 %>%
  ggplot( aes(x=room_type, y=average_price, fill=room_type)) +
  geom_boxplot() +
  ggtitle('room type versus price box-and-whisker plot') +
  xlab("room type")+
  ylab("room prices")

#Bedroom number
clean3$bedrooms<-as.factor(clean3$bedrooms)
clean3 %>%
  ggplot( aes(x=bedrooms, y=average_price, fill=bedrooms)) +
  geom_boxplot() +
  ggtitle('Bedroom numbers versus price box-and-whisker plot') +
  xlab("number of bedroom")+
  ylab("room prices")
clean3$bedrooms<-as.factor(clean3$bedrooms)
clean3 %>%
  ggplot( aes(x=bedrooms, y=average_price, fill=bedrooms)) +
  geom_violin() +
  ggtitle('Bedroom numbers versus price box-and-whisker plot') +
  xlab("number of bedroom")+
  ylab("room prices")
#bed number
clean3$beds<-as.factor(clean3$beds)
clean3 %>%
  ggplot( aes(x=beds, y=average_price, fill=beds)) +
  geom_boxplot() +
  ggtitle('Bed numbers versus price box-and-whisker plot') +
  xlab("number of bedroom")+
  ylab("room prices")


#A good variable to add in the model
clean3 %>%
  ggplot( aes(x=host_has_profile_pic, y=average_price, fill=host_has_profile_pic)) +
  geom_boxplot() +
  ggtitle('If Host post picture versus price box-and-whisker plot') +
  xlab("host_has_profile_pic")+
  ylab("room prices")
#"F" AVERAGE PRICES are higher
clean3 %>%
  ggplot( aes(x=host_identity_verified, y=average_price, fill=host_identity_verified)) +
  geom_boxplot() +
  ggtitle('If Host Identity Verified versus price box-and-whisker plot') +
  xlab("host_identity_verified")+
  ylab("room prices")
#Not very significant
#We might need to do a t-test for significance of difference

#host listing count
describe(calculated_host_listings_count)
summary(calculated_host_listings_count)
stat.desc(calculated_host_listings_count)
boxplot(calculated_host_listings_count,pch = 19,xlab = "Number of listings")
# linear trend + confidence interval
p_listing<-clean3%>%
  filter(calculated_host_listings_count>4)%>%
  ggplot( aes(x=calculated_host_listings_count, y=average_price)) +
  geom_point() +
  geom_smooth(method=lm , color="red", fill="#69b3a2", se=TRUE)
ggExtra::ggMarginal(p_listing,type = "histogram")
#nono

describe(review_scores_value)
summary(review_scores_value)
stat.desc(review_scores_value)
clean3 %>%
  ggplot( aes(x=review_scores_value, y=average_price,group=review_scores_value)) +
  geom_boxplot()+
  scale_fill_viridis(discrete = TRUE, alpha=0.6, option="A") +
  ggtitle("Box Plot") +
  xlab("Review Score")
# linear trend + confidence interval
p_review<-clean3%>%
  ggplot( aes(x=review_scores_value, y=average_price)) +
  geom_point() +
  geom_smooth(method=lm , color="red", fill="#69b3a2", se=TRUE)
ggExtra::ggMarginal(p_review,type = "histogram")

describe(reviews_per_month)
summary(reviews_per_month)
stat.desc(reviews_per_month)
boxplot(reviews_per_month,pch = 19,xlab = "review per month")
p_reviewfreq<-clean3%>%
  filter(reviews_per_month>1)%>%
  ggplot( aes(x=reviews_per_month, y=average_price)) +
  geom_point() +
  geom_smooth(method=lm , color="red", fill="#69b3a2", se=TRUE)
ggExtra::ggMarginal(p_reviewfreq,type = "histogram")
#negative

summary(cleaning_fee)
describe(cleaning_fee)
stat.desc(cleaning_fee)
boxplot(cleaning_fee,pch = 19,xlab = "cleaning_fee")
p_cleanfee<-clean3%>%
  filter(cleaning_fee>0)%>%
  ggplot( aes(x=cleaning_fee, y=average_price)) +
  geom_point() +
  geom_smooth(method=lm , color="red", fill="#69b3a2", se=TRUE)
ggExtra::ggMarginal(p_cleanfee,type = "histogram")

summary(security_deposit)
describe(security_deposit)
stat.desc(security_deposit)
plot(security_deposit, average_price)
#not strong


describe(host_response_rate.percentage)
summary(host_response_rate.percentage)
stat.desc(host_response_rate.percentage)
p_respon<-clean3%>%
  ggplot( aes(x=host_response_rate.percentage, y=average_price)) +
  geom_point() +
  geom_smooth(method=lm , color="red", fill="#69b3a2", se=TRUE)
ggExtra::ggMarginal(p_respon,type = "histogram")
#negative

