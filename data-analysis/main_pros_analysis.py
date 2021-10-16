# -*- coding: utf-8 -*-
"""
Created on Sat Oct  2 23:54:56 2021

Carries out main prosody analysis on the wh-word

All data will be stored in panda dataframe and exported as csv

@author: zhuzi
"""

import pandas as pd
import os
from pros_analysis_supplementary_functions import get_wh_interval, get_wh_pitch, get_vowel_interval, get_vowel_pitch

# Preparation 
wavParentPath = r"C:\Users\zhuzi\Downloads\ProsExp\matching_grid_wav"
gridParentPath =  r"C:\Users\zhuzi\Downloads\ProsExp\matching_grid_wav"
#userNames = ["AT2H4e", "BFZhXx", "CX148r", "eE5EZc", "ixPF2w", "lziEnO", "yWTbMM"]
#userNames = ["2GmIy6", "8Znenn", "fK27Kq", "kzwNIo"]

userNames = {"AT2H4e":"Non-NA", "BFZhXx":"Non-NA", "CX148r":"Non-NA", 
             "eE5EZc":"Non-NA", "ixPF2w":"Yes-NA", "lziEnO":"Non-NA", 
             "yWTbMM":"Non-NA", "2GmIy6":"Yes-NA", "8Znenn":"Yes-NA", 
             "fK27Kq":"Yes-NA", "kzwNIo":"Yes-NA"}

# Create blank dataframe with only column names 
# Sample row: 
#   E.g. ["AT2H4e_1_EQ", "AT2H4e", "Non-NA", "1_EQ", 1, "EQ", "what", 1.17, 
#           1.44, 0.27, "end", 200.14148267805857, 284.9370402944771, 
#           84.7955576164185]
colNames = ["filename", "participant_ID", "accent", "stimuli_#", "context_#", "q_type", 
            "wh-word", "wh_start_time", "wh_end_time", "wh_duration", "wh_position", 
            "wh_start_pitch", "wh_end_pitch", "wh_delta_pitch",
            "vowel_start_time", "vowel_end_time", "vowel_duration",
            "vowel_start_pitch", "vowel_end_pitch", "vowel_delta_pitch",]
df = pd.DataFrame(columns=colNames)


### Processing the fillers first 
for user in userNames:
    for i in range(1, 7, 1):
        
        # List for temporary storage (will become a row in df)
        data = []
        
        # filename to be stored in df[0]
        fileName =  user + '_' + str(i) + '_' + "filler"
        
        # Create paths to both the audio and textgrid files
        wavPath = os.path.join(wavParentPath, fileName + '.wav')
        gridPath = os.path.join(gridParentPath, fileName + '.TextGrid')
        
        # Only proceed to analysis if both paths exist
        if os.path.exists(wavPath) and os.path.exists(gridPath):
            data.extend([fileName, user, userNames[user], i, 
                         str(i) + '_' + "filler", "filler"])
            
            get_wh_interval(gridPath, data)
            get_wh_pitch(wavPath, data)
            get_vowel_interval(gridPath, data)
            get_vowel_pitch(wavPath, data)
            
            # Add each row "data" for each file into the dataframe
            df.loc[len(df.index)] = data


### Now processing the EQ/FQ/PQ's
for user in userNames:
    for i in range(1, 10, 1):
        for q in ["PQ", "EQ", "FQ"]:
            
            # List for temporary storage (will become a row in df)
            data = []
            
            # filename to be stored in df[0]
            fileName =  user + '_' + str(i) + '_' + q
            
            # Create paths to both the audio and textgrid files
            wavPath = os.path.join(wavParentPath, fileName + '.wav')
            gridPath = os.path.join(gridParentPath, fileName + '.TextGrid')
            
            # Only proceed to analysis if both paths exist
            if os.path.exists(wavPath) and os.path.exists(gridPath):
                data.extend([fileName, user, userNames[user], i, 
                             str(i) + '_' + q, q])
            
                get_wh_interval(gridPath, data)
                get_wh_pitch(wavPath, data)
                get_vowel_interval(gridPath, data)
                get_vowel_pitch(wavPath, data)
            
                # Add each row "data" for each file into the dataframe
                df.loc[len(df.index)] = data
                
df.to_csv('batch1&2_whword_vowel_f0_duration_data.csv', encoding = 'utf-8')
