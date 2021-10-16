# -*- coding: utf-8 -*-
"""
Created on Sat Oct  2 22:51:13 2021

Defines functions helpful for main prosody analysis 
(should be called in the following order)
    get_wh_interval()
    get_wh_pitch()
    get_vowel_interval()
    get_vowel_pitch()

After calling the two functions in this file, for each audio file, there will 
be the following new features in order:
    [wh-word, wh_start_time, wh_end_time, wh_duration, wh_position, 
     wh_start_pitch, wh_end_pitch, wh_delta_pitch,
     vowel_start_time, vowel_end_time, vowel_duration,
     vowel_start_pitch, vowel_end_pitch, vowel_delta_pitch]

@author: zhuzi
"""

import tgt
import parselmouth as psm

"""
 Extracts the wh-word from a certain textgrid; also records its start/end 
     times, duration, position in sentence
 
 After get_interval(), data will be extended by the following in order:
     [wh-word, wh_start_time, wh_end_time, wh_duration, wh_position]
 
 textgrid_filename: a string of the textgrid file directory 
 
 data: a list to store relevant info for a specific audio file
"""
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
            data.extend([curr_word, start_time, end_time, end_time - start_time])
            
            # Records the position of the wh-word in the sentence
            if i == len(wordTierInt) - 2: # last word in the sentence
                data.append("end")
            else:
                data.append("mid")
                
            break
        

"""
 Extracts the start pitch, end pitch, and change in pitch for the wh-word in a 
 given audio file 
 
 The time interval of interest is given by (call after get_wh_interval()！！):
     start_time = data[-4]
     end_time = data[-3]
 
 After calling get_wh_pitch(), data will be extended by the following in order:
     [ wh_start_pitch, wh_end_pitch, wh_delta_pitch,]
 
 audio_filename: a string of the audio file directory 
 
 data: a list to store relevant info for a specific audio file
"""
def get_wh_pitch(audio_filename, data):
    
    # Read the audio file from the given directory
    sound = psm.Sound(audio_filename)
    # Convert .wav file to a Praat Pitch object
    pitch = sound.to_pitch()
    
    # Get start/end indices based on start/end times 
    # Indices are used to select pitch contour in desired time interval 
    start_time = data[-4]
    end_time = data[-3]
    start_index = round((start_time - pitch.x1) / pitch.dx)
    end_index = round((end_time - pitch.x1) / pitch.dx)
    # Array of pitch values at different indices (corresponding to time points)
    pitch_slice = pitch.selected_array["frequency"][max(0, start_index):end_index+1]
       
    # Get start/end pitches and the difference
    # start_pitch = first non-zero pitch value 
    # end_pitch = last non-zero value
    pitch_slice = [i for i in pitch_slice if i != 0]
    
    if len(pitch_slice) == 0:
        start_pitch = end_pitch = 0
    else:
        start_pitch = pitch_slice[0]
        end_pitch = pitch_slice[-1]
    delta_pitch = end_pitch - start_pitch
    
    # start = end = start_pitch = end_pitch = delta_pitch = 0
    # while start < len(pitch_slice) - end <= len(pitch_slice):
    #     start_pitch = pitch_slice[0 + start]
    #     end_pitch = pitch_slice[-(1+end)]
    #     delta_pitch = end_pitch - start_pitch
    #     if delta_pitch >= 200:
    #         end += 1
    #     elif delta_pitch <= -200:
    #         start += 1
    #     else: 
    #         break
    
    data.extend([start_pitch, end_pitch, delta_pitch])



"""
 Extracts the wh-word vowel from a certain textgrid; also records its start/end 
     times, duration.
 
 After get_vowel_interval(), data will be extended by the following in order:
     [vowel_start_time, vowel_end_time, vowel_duration]
 
    
 The start time of the wh-interval is given by (call after get_wh_pitch()！！):
     wh_start_time = data[-7]
 
textgrid_filename: a string of the textgrid file directory 
 
 data: a list to store relevant info for a specific audio file
"""
def get_vowel_interval(textgrid_filename, data):
    # Read the grid from given directory 
    grid = tgt.io.read_textgrid(textgrid_filename, include_empty_intervals=True)
    
    # Extract the tier that contains phones
    phoneTierInt = grid.get_tiers_by_name("phones")[0].intervals
    
    # Get the wh-word start time for the present sample
    # Make sure to run after get_wh_word()!!!
    wh_start_time = data[-7]
    
    # Iterate through the list of all phones to find the wh-word vowel
    for i in range(0, len(phoneTierInt), 1):
        
        # Record the start time of the current phone
        curr_start_time = phoneTierInt[i].start_time
        
        # If the current phone has the same start time as the wh-word,
        # then the next phone will be the vowel in the wh-word
        if curr_start_time == wh_start_time:
            
            # Records the wh-word vowel, start/end time, duration
            start_time = phoneTierInt[i + 1].start_time
            end_time = phoneTierInt[i + 1].end_time
            data.extend([start_time, end_time, end_time - start_time])
            
            break




"""
 Extracts the start pitch, end pitch, and change in pitch for the wh-word vowel 
 in a given audio file 
 
 The time interval of interest is given by (call after get_vowel_interval()！！):
     start_time = data[-3]
     end_time = data[-2]
 
 After calling get_wh_pitch(), data will be extended by the following in order:
     [vowel_start_pitch, vowel_end_pitch, vowel_delta_pitch,]
 
 audio_filename: a string of the audio file directory 
 
 data: a list to store relevant info for a specific audio file
"""
def get_vowel_pitch(audio_filename, data):
    
    # Read the audio file from the given directory
    sound = psm.Sound(audio_filename)
    # Convert .wav file to a Praat Pitch object
    pitch = sound.to_pitch()
    
    # Get start/end indices based on start/end times 
    # Indices are used to select pitch contour in desired time interval 
    start_time = data[-3]
    end_time = data[-2]
    start_index = round((start_time - pitch.x1) / pitch.dx)
    end_index = round((end_time - pitch.x1) / pitch.dx)
    # Array of pitch values at different indices (corresponding to time points)
    pitch_slice = pitch.selected_array["frequency"][start_index:end_index+1]
        
    # Get start/end pitches and the difference
    # start_pitch = first non-zero pitch value 
    # end_pitch = last non-zero value

    pitch_slice = [i for i in pitch_slice if i != 0]
    
    
    if len(pitch_slice) == 0:
        start_pitch = end_pitch = 0
    else:
        start_pitch = pitch_slice[0]
        end_pitch = pitch_slice[-1]
    delta_pitch = end_pitch - start_pitch
    
    # start = end = start_pitch = end_pitch = delta_pitch = 0
    # while start < len(pitch_slice) - end <= len(pitch_slice):
    #     start_pitch = pitch_slice[0 + start]
    #     end_pitch = pitch_slice[-(1+end)]
    #     delta_pitch = end_pitch - start_pitch
    #     if delta_pitch >= 200:
    #         end += 1
    #     elif delta_pitch <= -200:
    #         start += 1
    #     else: 
    #         break
    
    data.extend([start_pitch, end_pitch, delta_pitch])


### For testing only:
# txtgrid = r"C:\Users\zhuzi\Downloads\ProsExp\matching_grid_wav\8Znenn_8_FQ.TextGrid"
# audio = r"C:\Users\zhuzi\Downloads\ProsExp\matching_grid_wav\8Znenn_8_FQ.wav"

# data = []

# get_wh_interval(txtgrid, data)
# get_wh_pitch(audio, data)
# get_vowel_interval(txtgrid, data)
# get_vowel_pitch(audio, data)

# print(data)
# import pandas as pd
# df = pd.DataFrame([data])
# df.to_csv('batch1&2_whword_vowel_f0_duration_data.csv', mode='a', header=False)
