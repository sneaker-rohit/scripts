#!/bin/bash

# Author: Rohit P. Tahiliani
# Script has been tested on Ubuntu 14.04 

# check if the user executing the script is root or not  
if ! [ $(id -u) = 0 ]; then
   echo "Please execute this script as root!!"
   exit 1
else
	apt-get update 
	#  If a new version of a package needs a new dependency, 
	# apt-get dist-upgrade will upgrade and install the dependency, apt-get upgrade won't.
	apt-get -y dist-upgrade
	apt-get -y autoclean
	# autoremove: is used to remove packages that were 
	# automatically installed to satisfy dependencies for some package and that are no more needed.
	apt-get -y autoremove
fi 
