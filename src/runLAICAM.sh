#!/bin/bash

for i in gapfract_*.txt; do 

input="/home/mn811042/obs_data/CIMESLNX/STRUCTFILES/LAICAM /home/mn811042/obs_data/CIMESLNX/STRUCTFILES/parameter_file_laicam.dat $i laicam_$i.txt"

echo "The file laicam_$i.txt was successfully calculated!"

eval $input
  
done

