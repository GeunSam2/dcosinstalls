#!/bin/bash

#IP_LIST=`dcos node | grep -v HOSTNAME | awk '{print $2}'`
IP_LIST="192.168.0.181 192.168.0.182 192.168.0.183 192.168.0.184 192.168.0.185 192.168.0.186 192.168.0.187 192.168.0.188"
Password=kbsys1234
for Node_ip in ${IP_LIST}
do
	echo ${Node_ip}
	sshpass -p ${Password} ssh -oStrictHostKeyChecking=no root@${Node_ip} grep -c processor /proc/cpuinfo | awk '{print "Cpu_count : " $1}'
	sshpass -p ${Password} ssh -oStrictHostKeyChecking=no root@${Node_ip} grep MHz /proc/cpuinfo | head -1 | awk '{print "Cpu_MHz : " $4 "MHz"}'
	sshpass -p ${Password} ssh -oStrictHostKeyChecking=no root@${Node_ip} grep name /proc/cpuinfo | head -1 | awk -F: '{print "Cpu_name : " $2}'
	sshpass -p ${Password} ssh -oStrictHostKeyChecking=no root@${Node_ip} free -g | grep Mem | awk '{print "Mem_size : " $2 "G\n"}'
done

