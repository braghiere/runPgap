#!/bin/bash

# 1) $i is the name of the picture .bmp;
 #
 # 2) Geometric distortion of the fish-eye lens: 
 #    1: Equidistant (or polar)
 #    2: Orthographic
 #
 # 3) the following 6 numbers are positions in pixels of three points in the outside circle of the hemispherical photograph in the form:
 #    A = {a1,a2}
 #    B = {b1,b2}
 #    C = {c1,c2}
 # 4) 'c' is the answer for the question: "Is the working image classified or grey-toned (c/g) ? "
 #
 # 5) Do you want to compute a clumping factor (y/n) ?
 #    first line: y (yes) -> Extracts gap size 
 #    second line: n (no) -> Extracts gap fraction
 #
 # 6) First line: Extracting Gap Size
 #                Min. zenith angle, degrees (float):  0.0
 #                Max. zenith angle, degrees (float): 90.0
 #                Step, degrees (float): 10
 #
 #   Second line: Extracting Gap Fraction
 #                Enter the number of zenith and azimuth divisions (integer integer): 9 10
 #                Enter the magnetic declination in degrees (float: - West, + East): 0.0

for i in *.bmp; do 

 echo "$i 1 1257 225 570 1212 1814 1501 c y 0.0 90.0 10" | /home/mn811042/Desktop/preprocess/GFALIN

 echo "$i 1 1257 225 570 1212 1814 1501 c n 9 10 0.0" | /home/mn811042/Desktop/preprocess/GFALIN

 mv gapfract.txt gapfract_$i.txt

 mv gapsize.txt gapsize_$i.txt
  
done


