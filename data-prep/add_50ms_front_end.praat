form Insert silence
comment Specify duration of silence (in milliseconds) to be added to both front and end of sound files
positive duration_of_silence 50
comment Specify directory of sound files (don't forget final slash)
sentence inputDir C:\Users\zhuzi\Downloads\ProsExp\converted_audio\
comment Specify directory where you want to save the finished files (don't forget final slash)
sentence saveDir C:\Users\zhuzi\Downloads\ProsExp\converted_audio\

endform

duration_of_silence = duration_of_silence/1000

Create Strings as file list... list 'inputDir$'*.wav
numberOfFiles = Get number of strings
for ifile to numberOfFiles
   select Strings list

   #open sound file	
   fileName$ = Get string... ifile
   Read from file... 'inputDir$''fileName$'
   mySound = selected("Sound")

   #get sampling frequency of sound and create silence based on that
   sampling_frequency = Get sampling frequency
   mySilence = Create Sound from formula... silence 1 0 duration_of_silence sampling_frequency 0
   
   #concatenate sound file and silence
   select mySound
   plus mySilence
   myNewSound = Concatenate

   #concatenate silence and sound file
   select mySilence
   plus myNewSound
   finalNewSound = Concatenate

   # save concatenated sound to save directory
   select finalNewSound
   Write to WAV file... 'saveDir$''fileName$'
   select all
   minus Strings list
   Remove
endfor

select all
Remove

writeInfoLine: "Files successfully created!"