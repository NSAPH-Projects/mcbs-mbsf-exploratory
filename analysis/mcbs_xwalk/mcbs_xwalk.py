import pandas as pd

## Get MCBS

mcbs = pd.read_csv("../../data/csv/nicoalco.csv")

## Get the MCBS-MBSF cross-walk

xwalk = pd.read_csv("../../data/mcbs-xwalk/mcbs_xwalk_file_res000017155_req010441_2018.dat", names=["xwalk"])

# get MCBS ids from xwalk
xwalk["mcbs"]=xwalk["xwalk"].str[:8]
# get MBSF ids
xwalk["mbsf"]=xwalk["xwalk"].str[8:]
xwalk["mcbs"]=xwalk["mcbs"].astype(int)


xwalk=xwalk.drop(columns=['xwalk'])


## Merge MCBS and MBSF cross-walk

mcbs_x = mcbs.merge(xwalk, left_on='BASEID', right_on='mcbs', how='inner')


## Cleanup and save

mcbs_x = mcbs_x.rename(columns={'mbsf': 'QID'})
mcbs_x = mcbs_x.drop(columns=['mcbs'])
mcbs_x.to_csv("../../data/mcbs_xwalk.csv", index=False)
