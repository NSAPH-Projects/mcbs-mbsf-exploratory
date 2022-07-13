#exploring weights
setwd("~/mcbs-mbsf-exploratory/data/csv")
continuous <- read.csv("cenwgts.csv")
ever <- read.csv("evrwgts.csv")
head(continuous) #12929 rows
head(ever)
names(continuous)
names(ever)

setwd("~/mcbs-mbsf-exploratory/data/")
data2015 <- read.csv("mcbs_demo_x_mbsf_15-16_allpanels.csv")

data2015andwgts <- merge(continuous, data2015, by="BASEID") #only 10839 weights?
setdiff(continuous$BASEID, data2015andwgts$BASEID) #2090 difference

names(data2015andwgts)