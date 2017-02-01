#!/bin/bash

#This code works with 4 different pieces of code:
#   First:   1) copy the hemispherical photographs you want to treat to this folder in .JPG format.
#            2) The code treat.sh is called and the user is asked to select one threshold method between 3 different methods.
#         
#             note: gimp, imagemagick, otsuthresh_renato and localthresh_renato are needed to run this bit!
#
#   Second:  1) At this stage you have all thresholded hemispherical photographs, ready to have the gap fraction calculated.
#            2) The code runCIMES.sh is called  and the user is supposed to give the details for the runs.
#
#             note: GFALIN is needed to run this bit!
#
#   Third:   1) This part of the code calculates the azimuthal average of gap fractions.
#            
#              note: OPENNESS and parameter_file_openness.dat are needed to run this bit!
# 
#   Fourth:  1) This part plots all the Pgaps and calculates the average Pgap and the 95% confidence interval.
#               Of course if you have a unique photo, you won't have 95% confidence interval. Be smart! ;)
#
#              note: this part is written in python!
#
#    Open input folder:
     
     input_command="cd input/"
     eval $input_command


     treat_command="../src/treat.sh"
     eval $treat_command


     runCIMES_command="../src/runCIMES.sh"
     eval $runCIMES_command

     runOPENNESS_command="../src/runOPENNESS.sh"
     eval $runOPENNESS_command

     coping_command="cp *.txt ../output/"
     eval $coping_command

     removing_command="rm -rf *.txt"
     eval $removing_command


    #    Open output folder: 

     output1_command="cd .."
     eval $output1_command
     output2_command="cd output/"
     eval $output2_command
    
     openaveg_command="python ../src/openaveg.py"
     eval $openaveg_command

     eval $removing_command

     copying_command="cp ../input/*.bmp ."
     eval $copying_command

     removing_command="rm -rf ../input/*.bmp"
     eval $removing_command

    

exit 0
