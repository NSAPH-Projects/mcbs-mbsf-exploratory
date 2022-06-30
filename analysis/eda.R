library(ggplot2)
library(dplyr)
#read in files
#setwd("~/mcbs-mbsf-exploratory/")

#### data prep ####
demo <- read.csv("~/mcbs-mbsf-exploratory/data/mcbs_demo_x_mbsf_2015.csv")
nicoalco <- read.csv("~/mcbs-mbsf-exploratory/data/mcbs_nicoalco_x_mbsf_2015.csv")

#combine into one dataset
combo <- merge(demo, nicoalco, by="BASEID")
length(unique(combo$BASEID)) #there are 12,297 unique beneficiaries

#variable names in combined dataset
names(combo)
summary(combo$PANEL)

#restrict to 2015 enrollees
only2015 <- combo %>% filter(PANEL=='2015')
nrow(only2015) #4096 participants
#restrict to ages 65+
only2015_65 <- only2015 %>% filter(H_AGE >= 65)
nrow(only2015_65) #3392 participants


only2014 <- combo %>% filter(PANEL=='2014')
nrow(only2014) #3936 participants

only2013 <- combo %>% filter(PANEL=='2013')
nrow(only2013) #2275 participants

only2012 <- combo %>% filter(PANEL=='2012')
nrow(only2012) #1990 participants


sum(!is.na(only2015$D_DOD)) #<11 people died from this cohort of 2015 panel


#### For beneficiaries who began in 2015 ####
##### demographics ####
###### age ####

summary(only2015$H_AGE)
only2015$age_stratum <- as.factor(only2015$D_STRAT)
only2015$age_stratum <- recode_factor(only2015$age_stratum, "1"="0-44", "2" = "45-64", "3"= "65-69", "4"="70-74","5"="75-79","6"="80-84","7"="85 +")
ggplot(data=only2015, aes(x=age_stratum)) + 
  geom_bar() + 
  geom_text(stat='count', aes(label=..count..), vjust=-0.3) +
  labs(x="Beneficiary Age", y="Count of Beneficiaries", title="MCBS 2015 Enrollee Ages")
#4096 people in graph

###### race ####
summary(only2015$D_RACE2)
only2015$race <- as.factor(only2015$D_RACE2)
only2015$race <- recode_factor(only2015$race, "1"="Asian/Hawaiian/Pacific Islander", "2" = "African American", "3"= "Asian/Hawaiian/Pacific Islander", "4"="White","5"="American Indian or Alaska Native","6"="Other race","7"="More than one", "D"="Missing", "R"="Missing")
## NOTE: GROUPED HAWAIIAN/PACIFIC ISLANDER WITH ASIAN TO AVOID HAVING ANY CELL VALUES <10
ggplot(data=only2015, aes(x=race)) + 
  geom_bar() + 
  geom_text(stat='count', aes(label=..count..), vjust=-0.3) +
  labs(x="Beneficiary Race", y="Count of Beneficiaries", title="MCBS 2015 Enrollee Race")
#4096 people in graph

###### sex ####
summary(only2015$ROSTSEX)
only2015$sex <- as.factor(only2015$ROSTSEX)
only2015$sex <- recode_factor(only2015$sex, "1"="Male", "2" = "Female")
ggplot(data=only2015, aes(x=sex)) + 
  geom_bar() + 
  geom_text(stat='count', aes(label=..count..), vjust=-0.3) +
  labs(x="Beneficiary Sex", y="Count of Beneficiaries", title="MCBS 2015 Enrollee Sex")

##### drinking ####
###### drinks per day ####
only2015$drinks_per_day<- as.numeric(only2015$DRINKSPD)

#incorporate 0 days per month to 0 drinks per day (previously coded as NA)
for (ben in 1:nrow(only2015)){
  
  if(only2015[ben,]$DRINKDAY == 0){
    only2015[ben,]$drinks_per_day <- 0
  }
  if(!is.na(only2015[ben,]$drinks_per_day)){
    if(only2015[ben,]$drinks_per_day > 7){
      only2015[ben,]$drinks_per_day = 7 #this is really 7+ but need to regroup for privacy concerns
    }
  }
}
sum(!is.na(only2015$drinks_per_day)) #4055 have a non-NA value


only2015$drinks_per_day <- as.factor(only2015$drinks_per_day)
only2015$drinks_per_day <- recode_factor(only2015$drinks_per_day,"0"="0","1"="1","2"="2","3"="3","4"="4","5"="5","6"="6","7"="7+")

ggplot(data=only2015, aes(x=drinks_per_day)) + 
  geom_bar() + 
  geom_text(stat='count', aes(label=..count..), vjust=-0.3) +
  labs(x="Drinks Per Day", y="Count of Beneficiaries", title="MCBS 2015 Drinks Per Day")
#note that 7 here is really >=7

##### days drinking per month ####


only2015$DRINKDAY -> as.numeric(only2015$DRINKDAY)
only2015 <- only2015 %>% mutate(days_drinking = cut(as.numeric(DRINKDAY), breaks=c(-0.01,0,1,5,10,15,20,25,31)))

#need to clean up this graph

ggplot(data=only2015, aes(x=days_drinking)) + 
  geom_bar() + 
  geom_text(stat='count', aes(label=..count..), vjust=-0.3) +
  labs(x="Days Drinking Per Month", y="Count of Beneficiaries", title="MCBS 2015 Days Drinking Per Month")





##### smoking ####
###### ever smoked ####
only2015$ever_smoked <- as.factor(only2015$EVERSMOK)
only2015$ever_smoked <- recode_factor(only2015$ever_smoked,"1"="Yes","2"="No")

ggplot(data=only2015, aes(x=ever_smoked)) + 
  geom_bar() + 
  geom_text(stat='count', aes(label=..count..), vjust=-0.3) +
  labs(x="Ever smoked", y="Count of Beneficiaries", title="MCBS 2015 Ever Smoking") + xlim("Yes", "No")

###### number of years smoking ####
#96 means that they smoked for less than 1 year
#will recode this to 0.5 for the plot
for (ben in 1:nrow(only2015)){
  if(only2015[ben,]$DIDSMOKE == '96'){
    only2015[ben,]$DIDSMOKE <- '0.5'
  }
  #if they never smoked, they get a 0 value for years smoked
  if(only2015[ben,]$EVERSMOK == 2){
    only2015[ben,]$DIDSMOKE <- 0
  }
}
only2015$DIDSMOKE <- as.numeric(only2015$DIDSMOKE)
only2015 <- only2015 %>% mutate(smoking_years = cut(DIDSMOKE, breaks=c(-0.01,0,1,5,10,15,20,25,30,35,40,45,50)))
ggplot(data=only2015, aes(x=smoking_years)) + 
  geom_bar() + 
  geom_text(stat='count', aes(label=..count..), vjust=-0.3) +
  labs(x="Years Smoked", y="Count of Beneficiaries", title="MCBS 2015 Years Smoking") 


###### current smoking ####
#if they never smoked, they will get a no value for smoking now

for (ben in 1:nrow(only2015)){
  if(only2015[ben,]$EVERSMOK == 2){
    only2015[ben,]$SMOKNOW <- 2
  }
}
only2015$curr_smoke <- recode_factor(only2015$SMOKNOW,"1"="Yes","2"="No")

ggplot(data=only2015, aes(x=curr_smoke)) + 
  geom_bar() + 
  geom_text(stat='count', aes(label=..count..), vjust=-0.3) +
  labs(x="Current Smoker?", y="Count of Beneficiaries", title="MCBS 2015 Current Smokers") + xlim("Yes", "No")


