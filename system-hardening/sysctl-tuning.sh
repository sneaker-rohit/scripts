#!/bin/bash

# Author: Rohit P. Tahiliani
# Script has been tested on Debian 

# sysctl in debian machines is used to modify the kernel parameters at run time. In this shell script we enable protection 
# for some of the basic attacks by modifying the kernel params.

# 1. Protection against ICMP attacks.
# 2. Enable protection against TCP SYN Flooding attacks.
# 3. Disable IP forwarding
# 4. Enable protection against IP Spoofing
# 5. Disable IP Source Routing
# 6. Refuse responding to broadcast requests
# 7. Disable ICMP Redirect Acceptance
# 8. Log Spoofed, Source Routed and Redirect Packets

# check if the user executing the script is root or not  
if ! [ $(id -u) = 0 ]; then
   echo "Please execute this script as root!!"
   exit 1
else
	# 1. Enable protection against ICMP attacks. With this config, the server will not respond to any ping requests.
	sysctl -w net.ipv4.icmp_echo_ignore_all=1

	# 2. Enable protection against SYN Flooding attacks
	sysctl -w net.ipv4.tcp_syncookies=1
	sysctl -w net.ipv4.tcp_max_syn_backlog=2048
	# The tcp_synack_retries setting tells the kernel how many times to retransmit the SYN,ACK reply to an SYN request. 
	# In other words, this tells the system how many times to try to establish a passive TCP connection that was started 
	# by another host. Setting the tcp_synack_retries variable to 3, will have the default timeout of passive TCP connections 
	# to be  approximately 90 seconds. 
	sysctl -w net.ipv4.tcp_synack_retries=3
	
	# 3. Disable IP Forwarding if it's a non-routing system
	sysctl -w net.ipv4.ip_forward=0

	# 4. Set up the reverse path filtering for source address verification
	for i in /proc/sys/net/ipv4/conf/*/rp_filter ; do
	 echo 1 > $i 
	done

	# 5. The IP source routing, where an IP packet contains details of the path to its intended destination, is dangerous because according 
	# to RFC 1122 the destination host must respond along the same path. If an attacker was able to send a source routed packet into your 
	# network, then he would be able to intercept the replies and fool your host into thinking it is communicating with a trusted host.
	for f in /proc/sys/net/ipv4/conf/*/accept_source_route; do
        echo 0 > $f
    done

    # 6. When a packet is sent to an IP broadcast address (i.e. 192.168.1.255) from a machine on the local network, that packet is delivered 
    # to all machines on that network. Then all the machines on a network respond to this ICMP echo request and the result can be severe network 
    # congestion or outages -denial-of-service attacks. See the RFC 2644 for more information.
    sysctl -w net.ipv4.icmp_echo_ignore_broadcasts=1

    # 7. When hosts use a non-optimal or defunct route to a particular destination, an ICMP redirect packet is used by routers to inform the hosts 
    # what the correct route should be. If an attacker is able to forge ICMP redirect packets, he or she can alter the routing tables on the host and 
    # possibly subvert the security of the host by causing traffic to flow via a path you didn't intend. It's strongly recommended to disable ICMP Redirect 
    # Acceptance to protect your server from this hole. 
    sysctl -w net.ipv4.conf.all.accept_redirects=0

    # 8. Log everything 
    sysctl -w net.ipv4.conf.all.log_martians=1

    # Restart all the networking services for the changes to take effect 
    /etc/init.d/networking restart
fi