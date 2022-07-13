#exploring weights
setwd("~/mcbs-mbsf-exploratory/data/csv")
continuous <- read.csv("cenwgts.csv")
ever <- read.csv("evrwgts.csv")
threeYears <- read.csv("lng3wgts.csv")
fourYears <- read.csv("lng4wgts.csv")
demo <- read.csv("demo.csv")
head(continuous) #12929 rows
head(ever)
head(threeYears)
head(fourYears)
names(continuous)
head(continuous$CS1YRWGT)
names(ever)
names(threeYears)
names(fourYears)
length(setdiff(threeYears$BASEID, fourYears$BASEID))

setwd("~/mcbs-mbsf-exploratory/data/")
data2015 <- read.csv("mcbs_demo_x_mbsf_15-16_allpanels.csv")

data2015andwgts <- merge(continuous, data2015, by="BASEID") #only 10839 weights?
setdiff(continuous$BASEID, data2015andwgts$BASEID) #2090 difference

names(data2015andwgts)

setwd("/n/dominici_nsaph_l3/data/mcbs/2015/cost_supplement/data/csv/")
inpatient <- read.csv("ipe.csv")
head(inpatient)