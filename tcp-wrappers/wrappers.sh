#!/bin/bash
# Author: Rohit P. Tahiliani
# Script has been tested on Debian
# ldd  prints  the  shared  objects  (shared  libraries) required by each program or shared
# object specified on the command line.

for wrappers in /usr/bin /usr/sbin
do
	for objects in $wrappers/*
	do
		if ldd $objects | grep libwrap.so
		then 
			echo $objects
		fi 
	done
done



	
