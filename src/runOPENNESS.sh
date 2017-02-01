#!/bin/bash

for i in gapfract_*.txt; do 

input="/home/mn811042/obs_data/CIMESLNX/OPENNESS /home/mn811042/obs_data/CIMESLNX/STRUCTFILES/parameter_file_openness.dat $i openness_$i.txt"

echo "The file openness_$i.txt was successfully calculated!"

eval $input
  
done

