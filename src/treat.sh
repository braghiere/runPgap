#!/bin/bash
#
# Developed by Renato Braghiere 01/10/2015 
#
# ------------------------------------------------------------------------------
# 
# Licensing:
# 
# Copyright © Renato Braghiere
# 
# My scripts are available free of charge for non-commercial use, ONLY.
# 
# For use of my scripts in commercial (for-profit) environments or 
# non-free applications, please contact me (Fred Weinhaus) for 
# licensing arrangements. My email address is fmw at alink dot net.
# 
# If you: 1) redistribute, 2) incorporate any of these scripts into other 
# free applications or 3) reprogram them in another scripting language, 
# then you must contact me for permission, especially if the result might 
# be used in a commercial or for-profit environment.
# 
# My scripts are also subject, in a subordinate manner, to the ImageMagick 
# license, which can be found at: http://www.imagemagick.org/script/license.php
# 
# ------------------------------------------------------------------------------
# 
# PRE USAGE: This code uses imagemagick to run. Make sure you have it available. 
#            This works based on three pieces of code:
#            1) The main code: treat.sh
#            2) The second method is on: otsuthresh_renato
#            3) The third method is on: localthresh_renato
#
#            Make sure all the three files are in the same folder with your DHPs.  
#            The original DHPs have to be in .JPG (capital letters matter in this case).
#            !!!! Otherwise you have to change the code!!!!!!
#            The output treatred images will be in .bmp. This format is compatible with 
#            CIMES-fisheye (http://jmnw.free.fr/).
#
#
# USAGE: 1) Enter the command: [./treat.sh]
#        2) The following message will show up:
#           "Please, enter the method you want to treat your DHPs, followed by [ENTER]:"
#        3) Select one of the following treatment methods.  
#
#
#
# INSIDE OPTIONS:
#
# -method	  1                 This thresholding method uses a two-colours 
#                                   quantisation. This function isolates the
#                                   blue channel of a RGB image, in order to
#                                   increase the contrast between the background
#                                   sky and the components of the vegetation 
#                                   canopy. It also turns off dithering, then
#                                   finds the best two grey level colors to 
#                                   represent the image, regardless of if the 
#                                   image is bright, dark or other. 
#                                   The two grey levels are then normalised to 
#                                   black and white.
#
#
#                                                     
#                  2                This thresholding method uses the Otsu's
#                                   clustering method. This function isolates the
#                                   blue channel of a RGB image, in order to
#                                   increase the contrast between the background
#                                   sky and the components of the vegetation 
#                                   canopy. It also automatically thresholds an 
#                                   image to binary (b/w) format. It assume the 
#                                   histogram is bimodal, i.e. is the composite
#                                   of two bell-shaped distributions representing 
#                                   the foreground and background classes. 
#                                   The Otsu appoach computes the Between Class 
#                                   Variance from the foreground (above threshold 
#                                   data) and background (at and below threshold 
#                                   value) for every possible threshold value. 
#                                   The optimal threshold is the one that maximizes 
#                                   the Between Class Variance. This is equivalent to 
#                                   finding the threshold that minimizes the overlap 
#                                   between the two bell-shaped class curves.
#
#                   3               This thresholding method uses a local threshold
#                                   method to build an image to binary (b/w) format
#                                   using a moving window adaptive thresholding 
#                                   approach. For each window placement compares 
#                                   the centre pixel to the window mean plus the bias 
#                                   times the square root of window mean absolute 
#                                   deviation and if the center pixel is larger, it is 
#                                   made white; therwise black.
#                                   The moving window is a circle with Gaussian profile. 
#                        
#                   0               All available methods.
#
#
# NAME: TREAT (Pre processing Digital Hemispherical Photographs) 
# 
# PURPOSE: To automatically thresholds an image to binary (b/w) format 
# using different techniques.
# 
# 
# NOTE: It is highly recommended that the output not be specified 
# as a JPG image as that will cause compression and potentially a 
# non-binary (i.e. a graylevel) result. BMP is the default
# output format.
# 
# REFERENCES: see the following:
# http://www.ph.tn.tudelft.nl/Courses/FIP/noframes/fip-Segmenta.html
# http://homepages.inf.ed.ac.uk/rbf/CVonline/LOCAL_COPIES/MORSE/threshold.pdf
# http://www.cse.unr.edu/~bebis/CS791E/Notes/Thresholding.pdf
# http://www.ifi.uio.no/in384/info/threshold.ps
# http://www.supelec.fr/ecole/radio/JPPS01.pdf
# 
# CAVEAT: No guarantee that this script will work on all platforms, 
# nor that trapping of inconsistent parameters is complete and 
# foolproof. Use At Your Own Risk. 
# 
#
#
# START

echo "Please, enter the method you want to treat your DHPs, followed by [ENTER]:"
echo "1) Type 1: Two-colours method"
echo "2) Type 2: Otsu's method"
echo "3) Type 3: Local Threshold method"
echo "Type 0: All available methods"


read method

if [ "$method" -ge "1" ] && [ "$method" -le "3" ] || [ "$method" -le "0" ]; then
   
     
     if [ "$method" -eq "1" ];then  

     echo "Method $method selected."

     for i in *.JPG; do 

     a="$(echo $i | sed s/DSCN/DHP/)"
     a="$(echo $a | sed s/.JPG//)"

     echo "Processing $a ..."
          
     convert $i -channel B -separate +dither -colors 2 -normalize -depth 8 -colorspace Gray -type Palette -compress rle  $a.met1.bmp;
     convert $a.met1.bmp -depth 8 -colorspace gray -resize 2272x1704 -type Palette -compress rle $a.met1.bmp;
     gimp_command="gimp -i -b '(simple-unsharp-mask \"$a.met1.bmp\" 5.0 0.5 0)' -b '(gimp-quit 0)'"
     eval $gimp_command

         
      
     echo "The file $i was successfully as $a.met1.bmp"
     
     done

     elif [ "$method" -eq "2" ];then  

     echo "Method $method selected."

     for i in *.JPG; do 

     a="$(echo $i | sed s/DSCN/DHP/)"
     a="$(echo $a | sed s/.JPG//)"

     input="/home/mn811042/Desktop/preprocess/otsuthresh_renato $i $a.met2.bmp"
     eval $input
     echo $a
     #otsuthresh_renato $a $a.met2.bmp; 
     #convert $a.met2.bmp -transpose -depth 8 -colorspace gray -resize 2272x1704 -type Palette -compress rle $a.met2.bmp;
     convert $a.met2.bmp -depth 8 -colorspace gray -resize 2272x1704 -type Palette -compress rle $a.met2.bmp;
     gimp_command="gimp -i -b '(simple-unsharp-mask \"$a.met2.bmp\" 5.0 0.5 0)' -b '(gimp-quit 0)'"
     eval $gimp_command

         
     echo "The DHP $i was successfully pre-processed and can be found as $a.met2.bmp"
     done

      elif [ "$method" -eq "3" ]; then  


      echo "Method $method selected."

      for i in *.JPG; do 

      a="$(echo $i | sed s/DSCN/DHP/)"
      a="$(echo $a | sed s/.JPG//)"

      input="/home/mn811042/Desktop/preprocess/localthresh_renato -m 3 -n yes $i $a.met3.bmp"
      eval $input
      echo $a

      #localthresh_renato -m 3 -n yes $i $a.met3.bmp; 
      #convert $a.met3.bmp -depth 8 -colorspace gray -type Palette -compress rle $a.met3.bmp;
      convert $a.met3.bmp -depth 8 -colorspace gray -resize 2272x1704 -type Palette -compress rle $a.met3.bmp;
      gimp_command="gimp -i -b '(simple-unsharp-mask \"$a.met3.bmp\" 5.0 0.5 0)' -b '(gimp-quit 0)'"
      eval $gimp_command

      echo "The DHP $i was successfully pre-processed and can be found as $a.met3.bmp"
      done

     elif [ "$method" -eq "0" ]; then  

      echo "All methods were selected."

      for i in *.JPG; do 
         a="$(echo $i | sed s/DSCN/DHP/)"
         a="$(echo $a | sed s/.JPG//)"

         convert $i -channel B -separate +dither -colors 2 -normalize -depth 8 -colorspace Gray -type Palette -compress rle  $a.met1.bmp;
         convert $a.met1.bmp -depth 8 -colorspace gray -resize 2272x1704 -type Palette -compress rle $a.met1.bmp;
         gimp_command="gimp -i -b '(simple-unsharp-mask \"$a.met1.bmp\" 5.0 0.5 0)' -b '(gimp-quit 0)'"
         eval $gimp_command
       
         echo "The DHP $i was successfully pre-processed and can be found as $a.met1.bmp"

         input="/home/mn811042/Desktop/preprocess/otsuthresh_renato $i $a.met2.bmp"
         eval $input
         echo $a
         #otsuthresh_renato $a $a.met2.bmp; 
         #convert $a.met2.bmp -transpose -depth 8 -colorspace gray -resize 2272x1704 -type Palette -compress rle $a.met2.bmp;
         convert $a.met2.bmp -depth 8 -colorspace gray -resize 2272x1704 -type Palette -compress rle $a.met2.bmp;
         gimp_command="gimp -i -b '(simple-unsharp-mask \"$a.met2.bmp\" 5.0 0.5 0)' -b '(gimp-quit 0)'"
         eval $gimp_command
         echo "The DHP $i was successfully pre-processed and can be found as $a.met2.bmp"

         input="/home/mn811042/Desktop/preprocess/localthresh_renato -m 3 -n yes $i $a.met3.bmp"
         eval $input
         echo $a

         #localthresh_renato -m 3 -n yes $i $a.met3.bmp; 
         #convert $a.met3.bmp -depth 8 -colorspace gray -type Palette -compress rle $a.met3.bmp;
         convert $a.met3.bmp -depth 8 -colorspace gray -resize 2272x1704 -type Palette -compress rle $a.met3.bmp;
         gimp_command="gimp -i -b '(simple-unsharp-mask \"$a.met3.bmp\" 5.0 0.5 0)' -b '(gimp-quit 0)'"
         eval $gimp_command

         echo "The DHP $i was successfully pre-processed and can be found as $a.met3.bmp"

      done
fi

else 

     echo "--- THE METHOD $method DOES NOT EXIST, NOT READABLE OR HAG ZERO SIZE ---"

fi
    

exit 0

