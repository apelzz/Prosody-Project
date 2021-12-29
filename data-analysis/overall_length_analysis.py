# -*- coding: utf-8 -*-
"""
Created on Tue Dec 28 23:03:34 2021

@author: zhuzi
"""

import tgt
import parselmouth as psm
import pandas as pd
import os
#24679

def get_wh_interval(textgrid_filename, data):
    # Read the grid from given directory 
    grid = tgt.io.read_textgrid(textgrid_filename, include_empty_intervals=True)
    
    # Extract the tier that contains words
    wordTierInt = grid.get_tiers_by_name("words")[0].intervals
    
    # Iterate through the list of all words to find the wh-word
    # The wh-word is "what", "who", or "where"
    for i in range(0, len(wordTierInt), 1):
        curr_word = wordTierInt[i].text # The current word being examined
        
        if curr_word == "what" or curr_word == "who" or curr_word == "where":
            
            # Records the wh-word, start/end time, duration
            start_time = wordTierInt[i].start_time
            end_time = wordTierInt[i].end_time
            data.append(end_time - start_time)


def get_overall_length(textgrid_filename, data):
    # Read the grid from given directory 
    grid = tgt.io.read_textgrid(textgrid_filename, include_empty_intervals=True)
    
    # Get the interval tier
    wordTierInt = grid.get_tiers_by_name("words")[0].intervals
    
    # Get the start time, end time, subtract and get duration
    start_time = wordTierInt[1].start_time # index 1 since 1st object is silence
    end_time = wordTierInt[-2].end_time # index -2 since last object is silence
    duration = end_time - start_time
    
    # Record the duration
    data.append(duration)


gridParentPath =  r"C:\Users\zhuzi\Downloads\ProsExp\NA_grid_IPA"

userNames = ["7DezdT", "BKtDpf", "bmAO91", "D29JZp", "edk71W", "eQ8RH7", 
             "Fy9JQO", "JTdfKk", "KUoCnT", "pBBhf5", "SvFfvv", "Msv6IL",
             "sxvwco", "W5bsP5", "ixPF2w", "2GmIy6", "8Znenn", "fK27Kq", 
             "kzwNIo"]

colNames = ["filename", "participant_ID", "stimuli_#", "context_#", "q_type", 
            "wh_duration", "overall_length", "length_no_wh"]

df = pd.DataFrame(columns=colNames)

for user in userNames:
    for i in [2,4,6,7,9]:
        for q in ["PQ", "EQ"]:
            
            # List for temporary storage (will become a row in df)
            data = []
            
            # filename to be stored in df[0]
            fileName =  user + '_' + str(i) + '_' + q
            
            # Create paths to both the audio and textgrid files
            gridPath = os.path.join(gridParentPath, fileName + '.TextGrid')
            
            # Only proceed to analysis if both paths exist
            if os.path.exists(gridPath):
                data.extend([fileName, user, i, str(i) + '_' + q, q])
            
                get_wh_interval(gridPath, data)
                get_overall_length(gridPath, data)
                
                length_no_wh= data[-1] - data[-2]
                data.append(length_no_wh)
            
                # Add each row "data" for each file into the dataframe
                df.loc[len(df.index)] = data
                
df.to_csv('NA_length_analysis.csv', encoding = 'utf-8')