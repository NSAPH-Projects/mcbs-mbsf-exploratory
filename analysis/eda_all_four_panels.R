library(ggplot2)
library(dplyr)
#read in files
#setwd("~/mcbs-mbsf-exploratory/")

demo <- read.csv("~/mcbs-mbsf-exploratory/data/mcbs_demo_x_mbsf_2015.csv")
nicoalco <- read.csv("~/mcbs-mbsf-exploratory/data/mcbs_nicoalco_x_mbsf_2015.csv")
combined <- merge(demo, nicoalco, by='BASEID')

#filter to people ages 65 and older
over65 <- combined %>% filter(H_AGE >=65)
nrow(over65) #10250 participants
summary(over65$PANEL)
ggplot(data=over65, aes(x=over65$PANEL)) + 
  geom_bar() + 
  geom_text(stat='count', aes(label=..count..), vjust=-0.3) +
  labs(x="Panel Enrollment Year", y="Count of Beneficiaries", title="MCBS 2015 Panels")

sum(!is.na(over65$D_DOD)) #18 people died based on the date of death criteria
#want to look into this based on MBSF criteria


#### Zipcodes Represented ####
zipcodes <- unique(over65$H_ZIP)
length(zipcodes) #2255 zipcodes represented
library(maps)
us_states <- map_data("state")
us_states %>% ggplot(aes(x = long, y = lat, fill = "none", group = group)) + 
  geom_polygon(color = "black") + 
  coord_fixed(1.3) +
  guides(fill = FALSE)


#### Demographics ####
##### Age ####
over65$age_stratum <- as.factor(over65$D_STRAT)
over65$age_stratum <- recode_factor(over65$age_stratum, "1"="0-44", "2" = "45-64", "3"= "65-69", "4"="70-74","5"="75-79","6"="80-84","7"="85 +")
ggplot(data=over65, aes(x=age_stratum)) + 
  geom_bar() + 
  geom_text(stat='count', aes(label=..count..), vjust=-0.3) +
  labs(x="Beneficiary Age", y="Count of Beneficiaries", title="MCBS 2015 Enrollee Ages All Four Panels")
#10250 people in graph

##### Race ####
over65$race <- as.factor(over65$D_RACE2)
over65$race <- recode_factor(over65$race, "1"="Asian", "2" = "African American", "3"= "Native Hawaiian or Pacific Islander", "4"="White","5"="American Indian or Alaska Native","6"="Other race","7"="More than one", "D"="Missing", "R"="Missing")
## NOTE: GROUPED HAWAIIAN/PACIFIC ISLANDER WITH ASIAN TO AVOID HAVING ANY CELL VALUES <10
ggplot(data=over65, aes(x=race)) + 
  geom_bar() + 
  geom_text(stat='count', aes(label=..count..), vjust=-0.3) +
  labs(x="Beneficiary Race", y="Count of Beneficiaries", title="MCBS 2015 Enrollee Race All Four Panels")

##### Sex ####
over65$sex <- as.factor(over65$ROSTSEX)
over65$sex <- recode_factor(over65$sex, "1"="Male", "2" = "Female")
ggplot(data=over65, aes(x=sex)) + 
  geom_bar() + 
  geom_text(stat='count', aes(label=..count..), vjust=-0.3) +
  labs(x="Beneficiary Sex", y="Count of Beneficiaries", title="MCBS 2015 Enrollee Sex All Four Panels")



##### drinking ####
###### drinks per day ####
over65$drinks_per_day<- as.numeric(over65$DRINKSPD)

#incorporate 0 days per month to 0 drinks per day (previously coded as NA)
for (ben in 1:nrow(over65)){
  
  if(over65[ben,]$DRINKDAY == 0){
    over65[ben,]$drinks_per_day <- 0
  }
  if(!is.na(over65[ben,]$drinks_per_day)){
    if(over65[ben,]$drinks_per_day > 7){
      over65[ben,]$drinks_per_day = 7 #this is really 7+
    }
  }
}
sum(!is.na(over65$drinks_per_day)) #4055 have a non-NA value


over65$drinks_per_day <- as.factor(over65$drinks_per_day)
over65$drinks_per_day <- recode_factor(over65$drinks_per_day,"0"="0","1"="1","2"="2","3"="3","4"="4","5"="5","6"="6","7"="7+")

ggplot(data=over65, aes(x=drinks_per_day)) + 
  geom_bar() + 
  geom_text(stat='count', aes(label=..count..), vjust=-0.3) +
  labs(x="Drinks Per Day", y="Count of Beneficiaries", title="MCBS 2015 Drinks Per Day All Four Panels")


##### days drinking per month ####


over65$DRINKDAY -> as.numeric(over65$DRINKDAY)
over65 <- over65 %>% mutate(days_drinking = cut(as.numeric(DRINKDAY), breaks=c(-0.01,0,1,5,10,15,20,25,31)))


ggplot(data=over65, aes(x=days_drinking)) + 
  geom_bar() + 
  geom_text(stat='count', aes(label=..count..), vjust=-0.3) +
  labs(x="Days Drinking Per Month", y="Count of Beneficiaries", title="MCBS 2015 Days Drinking Per Month All Four Panels")





##### smoking ####
###### ever smoked ####
over65$ever_smoked <- as.factor(over65$EVERSMOK)
over65$ever_smoked <- recode_factor(over65$ever_smoked,"1"="Yes","2"="No")

ggplot(data=over65, aes(x=ever_smoked)) + 
  geom_bar() + 
  geom_text(stat='count', aes(label=..count..), vjust=-0.3) +
  labs(x="Ever smoked", y="Count of Beneficiaries", title="MCBS 2015 Ever Smoking All Four Panels") + xlim("Yes", "No")

###### number of years smoking ####
#96 means that they smoked for less than 1 year
#will recode this to 0.5 for the plot
for (ben in 1:nrow(over65)){
  if(over65[ben,]$DIDSMOKE == '96'){
    over65[ben,]$DIDSMOKE <- '0.5'
  }
  #if they never smoked, they get a 0 value for years smoked
  if(over65[ben,]$EVERSMOK == 2){
    over65[ben,]$DIDSMOKE <- 0
  }
}
over65$DIDSMOKE <- as.numeric(over65$DIDSMOKE)
over65 <- over65 %>% mutate(smoking_years = cut(DIDSMOKE, breaks=c(-0.01,0,1,5,10,15,20,25,30,35,40,45,50)))
ggplot(data=over65, aes(x=smoking_years)) + 
  geom_bar() + 
  geom_text(stat='count', aes(label=..count..), vjust=-0.3) +
  labs(x="Years Smoked", y="Count of Beneficiaries", title="MCBS 2015 Years Smoking All Four Panels") 


###### current smoking ####
#if they never smoked, they will get a no value for smoking now

for (ben in 1:nrow(over65)){
  if(over65[ben,]$EVERSMOK == 2){
    over65[ben,]$SMOKNOW <- 2
  }
}
over65$curr_smoke <- recode_factor(over65$SMOKNOW,"1"="Yes","2"="No")

ggplot(data=over65, aes(x=curr_smoke)) + 
  geom_bar() + 
  geom_text(stat='count', aes(label=..count..), vjust=-0.3) +
  labs(x="Current Smoker?", y="Count of Beneficiaries", title="MCBS 2015 Current Smokers All Four Panels") + xlim("Yes", "No")






