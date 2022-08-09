#Combining 2015 MCBS Nicotine/Alcohol Survey, Continuously Enrolled Weights, 2015/2016 MBSF Data, 2015/2016 MedPar Data
#load libraries
library(dplyr)
library(lubridate)
library(fst)


####Load and Filter Data ####

#load 2015 MCBS Data with QIDs from crosswalk
#contains nicotine and alcohol survey and continuously enrolled weights
#just for those who are continuously enrolled
mcbs <- read.csv("data/mcbs_xwalk.csv")
colnames(mcbs)[colnames(mcbs) == "QID"] <- "qid"


#load MBSF data from 2015 and 2016--can take a long time to read
mbsf2015 <- read.csv("data/denom_by_year_csv/confounder_exposure_merged_nodups_health_2015.csv")
# Select Columns and Filter
mbsf2015 <- mbsf2015 %>% select("qid", "dodflag", "sex", "race", "hmo_mo", "age", "zip","pm25_ensemble", "hispanic","smoke_rate") %>% filter(hmo_mo=="0", age >= 65)
original_cols <- colnames(mbsf2015)
colnames(mbsf2015) <- paste(original_cols,"2015",sep="_")
colnames(mbsf2015)[colnames(mbsf2015) == "qid_2015"] <- "qid"

mbsf2016 <- read.csv("data/denom_by_year_csv/confounder_exposure_merged_nodups_health_2016.csv")
mbsf2016 <- mbsf2016 %>% select("qid", "dodflag", "sex", "race", "hmo_mo", "age", "zip","pm25_ensemble", "hispanic","smoke_rate") %>% filter(hmo_mo=="0", age >= 65)
colnames(mbsf2016) <- paste(original_cols,"2016",sep="_")
colnames(mbsf2016)[colnames(mbsf2016) == "qid_2016"] <- "qid"
mbsf <- merge(mbsf2015, mbsf2016, by="qid", all=TRUE)
write_fst(mbsf, "data/mbsf_filtered_15-16.fst") #save as an fst for faster loading in the future
#if rerunning this script, you can just read in the fst below for mbsf
#mbsf <- read_fst("data/mbsf_filtered_15-16.fst")




#load MedPar data
medpar2015 <- read.csv("data/cvd/medpar_2015.csv")
colnames(medpar2015) <- c("qid","cvd_date_2015", "year", "cardio_2015")
medpar2015 <- medpar2015 %>% select("qid", "cvd_date_2015", "cardio_2015")
medpar2016 <- read.csv("data/cvd/medpar_2016.csv")
colnames(medpar2016) <- c("qid","cvd_date_2016", "year", "cardio_2016")
medpar2016 <- medpar2016 %>% select("qid", "cvd_date_2016", "cardio_2016")


#extract just the first CVD hospitalization for each year
mp2015 <- medpar2015 
mp2015$cvd_date_2015 <- dmy(mp2015$cvd_date_2015)
#get the first date of hospitalization
mp2015 <- mp2015 %>%
  group_by(qid) %>%
  arrange(cvd_date_2015, .by_group=TRUE) %>%
  slice(1) %>%
  ungroup() 
head(mp2015)

mp2016 <- medpar2016 
mp2016$cvd_date_2016 <- dmy(mp2016$cvd_date_2016)
mp2016 <- mp2016 %>%
  group_by(qid) %>%
  arrange(cvd_date_2016, .by_group = TRUE) %>%
  slice(1) %>%
  ungroup() 
head(mp2016)

medpar <- merge(mp2015, mp2016, by="qid", all=TRUE)
write_fst(medpar, "data/medpar_first_cvd_15-16.fst") #save as an fst for faster loading in the future
#medpar <- read_fst("data/medpar_first_cvd_15-16.fst")



#### Merge ####
medpar_mcbs <- merge(medpar, mcbs, by="qid", all=TRUE)

mcbs_mbsf_medpar <- merge(medpar_mcbs, mbsf, by="qid", all=TRUE)

#save the final files; fst is 3.3 GB and csv is 15.3 GB
write_fst(mcbs_mbsf_medpar, "data/mcbs_medpar_mbsf_2015-2016.fst")
write.csv(mcbs_mbsf_medpar, "data/mcbs_medpar_mbsf_2015-2016.csv")

