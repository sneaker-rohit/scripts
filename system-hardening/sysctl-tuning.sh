#!/bin/bash

# Author: Rohit P. Tahiliani
# Script has been tested on Debian 

#sysctl in debian machines is used to modify the kernel parameters at run time. In this shell script we enable protection 
#for some of the basic attacks by modifying the kernel params  
# 1. Protection against ICMP attacks.
# 2. Enable protection against TCP SYN Flooding attacks.
# 3. Disable IP forwarding

# check if the user executing the script is root or not  
if ! [ $(id -u) = 0 ]; then
   echo "Please execute this script as root!!"
   exit 1
else
	# Enable protection against ICMP attacks.
	sysctl -w net.ipv4.icmp_echo_ignore_all=1

	# Enable protection against SYN Flooding attacks
	sysctl -w net.ipv4.tcp_syncookies=1
	sysctl -w net.ipv4.tcp_max_syn_backlog=2048
	# The tcp_synack_retries setting tells the kernel how many times to retransmit the SYN,ACK reply to an SYN request. 
	# In other words, this tells the system how many times to try to establish a passive TCP connection that was started 
	# by another host. Setting the tcp_synack_retries variable to 3, will have the default timeout of passive TCP connections 
	# to be  approximately 90 seconds. 
	sysctl -w net.ipv4.tcp_synack_retries=3
	
	# Disable IP Forwarding if it's a non-routing system
	sysctl -w net.ipv4.ip_forward=0
fi