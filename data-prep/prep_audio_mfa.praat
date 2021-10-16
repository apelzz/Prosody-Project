# prep_audio_mfa.praat
# Written by E. Chodroff
# Oct 23 2018
# extract left channel and resample to 16 kHz for all wav files in a directory

### CHANGE ME! 
# don't forget the slash at the end of the path
dir$ = "C:\Users\zhuzi\Downloads\ProsExp\converted_audio\"

Create Strings as file list: "files", dir$ + "*.wav"
nFiles = Get number of strings

for i from 1 to nFiles
	selectObject: "Strings files"
	filename$ = Get string: i
	Read from file: dir$ + filename$
	Extract one channel: 1
	Resample: 16000, 50
	Save as WAV file: dir$ + filename$
	select all
	minusObject: "Strings files"
	Remove
endfor
