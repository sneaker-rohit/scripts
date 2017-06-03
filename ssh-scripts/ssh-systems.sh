#!/bin/bash
# Script can be used to ssh into multiple systems and execute some command on it 

USERNAME=ubuntu
HOSTS="192.168.0.81"
TASKS="pwd; cat /etc/passwd"

# To disable host key checking add "-o StrictHostKeyChecking=no" 
for HOSTNAME in ${HOSTS} ; do
    ssh -o StrictHostKeyChecking=no -l ${USERNAME} ${HOSTNAME} "${TASKS}"
done

