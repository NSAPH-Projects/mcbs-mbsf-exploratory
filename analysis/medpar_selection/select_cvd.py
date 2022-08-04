""" 
Identifies diagnoses of interest and adds them as new variables. 
"""

import sys
import pandas as pd
import numpy as np
import json


def get_outcomes(path=None):
    """ Get and return ICD codes """""
    read_path = 'icd_codes.json'
    f = open(read_path)
    res_dict = json.load(f)
    f.close()
    res_dict = json.loads(res_dict[0])    
    return res_dict


def read_admissions(year):
    """ Reads MedPar dataset """
    admissions_path = "medpar/medpar2_" + str(year) + ".csv" 
    cols = ['QID','ADATE','YEAR','DIAG1','DIAG2','DIAG3','DIAG4', \
            'DIAG5','DIAG6','DIAG7','DIAG8','DIAG9','DIAG10']
    df = pd.read_csv(admissions_path, usecols=cols)
    return df


def get_outcomes_set(outcome=None, year=None):
    """ Uses ICD9 for years prior 2015 and ICD10 otherwise """
    if year < 2015:
        outcomes_set = outcomes[outcome]["icd9"]
    elif year > 2015:
        outcomes_set = outcomes[outcome]["icd10"]
    else:
        outcomes_set = outcomes[outcome]["icd10"] + \
            outcomes[outcome]["icd9"]
    return set(outcomes_set)

        
def get_diags(diags=None, outcomes_set=None):
    """ Get True/False diagnosis for an outcome """
    return_col = pd.Series([False] * len(admissions))
    for col in diags:
        return_col = return_col | admissions[col].isin(outcomes_set)
    return return_col
    

outcomes = get_outcomes()
diags = ["DIAG" + str(num) for num in range(1, 11)]

if __name__ == '__main__':
    outcome = "cardio"
    
    for year in [2015, 2016]:
        outcomes_set = get_outcomes_set(outcome, year)
        admissions = read_admissions(year)
        admissions[outcome]=get_diags(
            diags=diags, outcomes_set=outcomes_set)

        # drop rows that are not of interest
        admissions = admissions[admissions[outcome]]

        # drop diag cols
        admissions = admissions.drop(columns=diags)
        OUTPATH = "../../data/cvd/medpar_"+str(year)+".csv"
        admissions.to_csv(OUTPATH, index = False)
