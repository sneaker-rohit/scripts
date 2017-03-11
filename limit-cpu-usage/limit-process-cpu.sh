#!/bin/bash

# Author: Rohit P. Tahiliani
# Script has been tested on Ubuntu 14.04 
# check if the user executing the script is root or not 
 
if ! [ $(id -u) = 0 ]; then
   echo "Please execute this script as root!!"
   exit 1
else
	# check if the required packages are present; else install them
	dpkg -s cpulimit
	if [ $? -ne 0 ]; then 
		apt-get update		
		apt-get install -y cpulimit
		print "Installed necessary packages ...."
	fi
  echo "Enter the percentage to which you wish to limit the CPU:"
  read process_cpu	  
  if [ $process_cpu -gt 100 ] || [ $process_cpu -lt 1 ]; then 
	echo "Invalid Input!!"
	exit 2
  fi
  echo "Enter the process name:"
  read process_name
  cpulimit -l $process_cpu $process_name &
fi
