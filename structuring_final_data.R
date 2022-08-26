#### Restructure of Data: https://docs.google.com/spreadsheets/d/1dksFJYBrjs6MSBigD3xyGbXMVW8iAtZHOo03rvbFo1M/edit#gid=0 ####
#### Combining MCBS 2015, MBSF 2015 and 2016, MedPar 2015 and 2016 ####


#load libraries
library(dplyr)
library(lubridate)
library(fst)
library(data.table)


####Load and Filter Data ####


##### MCBS #####
#load 2015 MCBS Data with QIDs from crosswalk
#contains nicotine and alcohol survey and continuously enrolled weights

mcbs <- fread("data/mcbs_xwalk.csv")
colnames(mcbs)[colnames(mcbs) == "QID"] <- "qid"
mcbs <- mcbs[,"VERSION.x":=NULL]
mcbs <- mcbs[,"VERSION.y":=NULL]
mcbs <- mcbs[,"SURVEYYR.y":=NULL]
mcbs <- mcbs[,1:=NULL] #removing repetitive columns (column 1 was an indexing column)
mcbs_indicator <- 1
mcbs <- cbind(mcbs_indicator, mcbs)

##### MBSF ##### 
#load MBSF data from 2015 and 2016--can take a long time to read
mbsf2015 <- fread("data/denom_by_year_csv/confounder_exposure_merged_nodups_health_2015.csv")
mbsf2016 <- fread("data/denom_by_year_csv/confounder_exposure_merged_nodups_health_2016.csv")

#filter to age 65+
mbsf2015 <- mbsf2015 %>% filter(age >= 65)
mbsf2016 <- mbsf2016 %>% filter(age >= 65)

#only include 2016 beneficiaries that were enrolled in 2015
mbsf2016 <- mbsf2016 %>% filter(qid %in% mbsf2015$qid)



#merge the two years together
mbsf <- rbind(mbsf2015,mbsf2016)
rm(mbsf2015,mbsf2016)



##### MedPar #####
#load medpar data
medpar2015 <- fread("data/cvd/medpar_2015.csv")
medpar2016 <- fread("data/cvd/medpar_2016.csv")
colnames(medpar2015) <- c("qid","cvd_date", "year", "cardio")
colnames(medpar2016) <- c("qid","cvd_date", "year", "cardio")
medpar2015$cvd_date <- dmy(medpar2015$cvd_date)
#get the first date of hospitalization and count of cvd events
medpar2015 <- medpar2015 %>%
  group_by(qid) %>%
  mutate(count_cvd_events = n()) %>%
  arrange(cvd_date, .by_group=TRUE) %>%
  slice(1) %>%
  ungroup() 
head(medpar2015)

medpar2016$cvd_date <- dmy(medpar2016$cvd_date)
#get the first date of hospitalization and count of cvd events
medpar2016 <- medpar2016 %>%
  group_by(qid) %>%
  mutate(count_cvd_events = n()) %>%
  arrange(cvd_date, .by_group=TRUE) %>%
  slice(1) %>%
  ungroup() 
head(medpar2016)

medpar <- rbind(medpar2015, medpar2016)
rm(medpar2015, medpar2016)
gc()
#### Dataset 1 #### 
# combining mbsf and mcbs


mbsf_mcbs <- merge(mbsf, mcbs, by="qid" ,all =TRUE)

#write dataset 1
fwrite(mbsf_mcbs, "data/final_outputs/mbsf_mcbs_2015_2016.csv")
write.fst(mbsf_mcbs, "data/final_outputs/mbsf_mcbs_2015_2016.fst")


#### Dataset 2 ####
#filter out HMO beneficiaries
mbsf_ffs <- mbsf %>% filter(hmo_mo =="0")
rm(mbsf, mbsf_mcbs)
#gc()
mbsf_ffs_medpar <- merge(mbsf_ffs, medpar, by=c("qid", "year"), all.x=TRUE)
mbsf_ffs_medpar_mcbs <- merge(mbsf_ffs_medpar, mcbs, by="qid", all.x=TRUE)


#write dataset 2
fwrite(mbsf_ffs_medpar_mcbs, "data/final_outputs/mbsf_medpar_mcbs_2015_2016.csv")
write.fst(mbsf_ffs_medpar_mcbs, "data/final_outputs/mbsf_medpar_mcbs_2015_2016.fst")

