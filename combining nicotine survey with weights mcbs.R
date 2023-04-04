#merge the weights with nicotine and alcohol survey so we can run them through the crosswalk

#setwd("~/mcbs-mbsf-exploratory/data")
nicoalco <- read.csv("csv/nicoalco.csv")
continuously_enrolled_weights <- read.csv("csv/cenwgts.csv")

merged_wgts_survey <- merge(nicoalco, continuously_enrolled_weights, by= "BASEID", all.y = TRUE)
write.csv(merged_wgts_survey,"merged_weights_nicoalco_mcbs.csv")
