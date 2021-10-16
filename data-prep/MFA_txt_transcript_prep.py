# -*- coding: utf-8 -*-
"""
Created on Sat Sep 25 21:57:25 2021

@author: zhuzi
"""

import os


parentPath = r"C:\Users\zhuzi\Downloads\ProsExp\TheInput"

childPaths = [] # to store "1_PQ", etc. 
transcript = {} # to store the question-transcript pair
wavPaths = [] # to store all wav file directories

# Creating strings like "1_PQ"
for i in range(1, 7, 1):
    childPaths.append(str(i) + '_' + "filler" )

for i in range(1, 10, 1):
    for j in ["PQ", "EQ", "FQ"]:
        childPaths.append(str(i) + '_' + j)

# Write 1_PQ etc. to a txt file
# textfile = open(r"C:\Users\zhuzi\Downloads\ProsExp\Q-transcript_pairs.txt", "w")
# for element in childPaths:
#     textfile.write(element + "\n")
# textfile.close()

# Create a dictionary with Q-transcript pairs
with open(r"C:\Users\zhuzi\Downloads\ProsExp\Q-transcript_pairs.txt") as f:
    for line in f:
       key, sep, val = line.strip().partition(" ")
       transcript[key] = val

# Creating strings like "AT2H4e_1_EQ.wav"
#userNames = ["AT2H4e", "BFZhXx", "CX148r", "eE5EZc", "ixPF2w", "lziEnO", "yWTbMM"]
userNames = ["2GmIy6", "8Znenn", "fK27Kq", "hfiSaS", "kzwNIo", "CX148r"]


# Create transcript for each Q in txt format
for user in userNames:
    for key in transcript:
        fileName = user + '_' + key + '.wav'
        wavPath = os.path.join(parentPath, fileName)
        txtPath = os.path.join(parentPath, user + '_' + key + '.txt')
        if os.path.exists(wavPath):
            wavPaths.append(wavPath)
            textfile = open(txtPath, "w")
            textfile.write(transcript[key])
            textfile.close()



# for i in range(0, len(fillerChildPaths), 1):
#     newPath = os.path.join(parentPath, fillerChildPaths[i])
#     if not os.path.exists(newPath):
#         os.makedirs(newPath)

# def move(filename, childPath):
#     desFolder = os.path.join(parentPath, childPath)
#     currFolder = os.path.join(parentPath, filename)
#     if not os.path.exists(os.path.join(desFolder, filename)):
#         if os.path.exists(currFolder):
#             shutil.move(currFolder, desFolder)

# for i in userNames:
#     for j in fillerChildPaths:
#         fillerFileNames.append(i + '_' + j + ".wav")
#         move(fillerFileNames[-1], j)




# for i in range(0, len(childPaths), 1):
#     newPath = os.path.join(parentPath, childPaths[i])
#     if not os.path.exists(newPath):
#         os.makedirs(newPath)


# for i in userNames:
#     for j in childPaths:
#         fileNames.append(i + '_' + j + ".wav")
#         move(fileNames[-1], j)

