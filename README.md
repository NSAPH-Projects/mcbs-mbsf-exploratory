### MCBS Data Merged with MBSF Data
#### Performing Preliminary EDA


**Analysis Folder:**

`eda.R` uses the 2015 MCBS data restricted to the 2015 baseline panel (people who enrolled in the MCBS surveys in 2015), produces plots with several key variables such as age, drinks per day, etc. 

`eda_all_four_panels.R` replicates eda.R, but instead uses all four panels (people who enrolled in MCBS in 2012, 2013, 2014, and 2015)

`mcbs_mbsf_merge.ipynb` merges the 2015 MCBS with the 2015 and 2016 MBSF files and creates `mcbs_demo_x_mbsf_15-16.csv` and `mcbs_nicoalco_x_mbsf_15-16.csv` in the data folder which are restricted to ages 65+ and 2015 baseline MCBS enrollees, shows the number of deaths in 2015/2016

`mcbs_mbsf_merge-all-panels.ipynb` is a replicate of `mcbs_mbsf_merge.ipynb`, but it does not restrict the panel to 2015 and it produces `mcbs_demo_x_mbsf_15-16_allpanels.csv` and `mcbs_nicoalco_x_mbsf_15-16_allpanels.csv` in the data folder, shows the number of deaths in 2015/2016


**Data Folder:**

`mcbs_demo_x_mbsf_15-16.csv` combines data from the 2015 MCBS demographic file restricted to 2015 enrollees with the 2015 & 2016 MBSF denominator file


`mcbs_nicoalco_x_mbsf_15-16.csv` combines data from the 2015 MCBS nicotine and alcohol file restricted to 2015 enrollees with the 2015 & 2016 MBSF denominator file

`mcbs_demo_x_mbsf_15-16_allpanels.csv` combines data from the 2015 MCBS demographic file with the 2015 & 2016 MBSF denominator file; includes 2012-2015 panels


`mcbs_nicoalco_x_mbsf_15-16_allpanels.csv` combines data from the 2015 MCBS nicotine and alcohol file with the 2015 & 2016 MBSF denominator file; includes 2012-2015 panels


Note: A panel is the incoming cohort to the MCBS survey. Each year includes four panels of participants. The baseline panel is the panel which enters into the MCBS study that year (eg the baseline 2015 panel is the group of Medicare beneficiaries that enter MCBS in 2015). 
