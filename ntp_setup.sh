#!/bin/bash

#IP_LIST=`dcos node | grep -v HOSTNAME | awk '{print $2}'`
IP_LIST="192.168.0.181 192.168.0.182 192.168.0.183 192.168.0.184 192.168.0.185 192.168.0.186 192.168.0.187 192.168.0.188"
Password=kbsys1234
for Node_ip in ${IP_LIST}
do
	echo ${Node_ip}
	sshpass -p ${Password} scp -oStrictHostKeyChecking=no ./rdate root@${Node_ip}:/etc/cron.daily/rdate
	sshpass -p ${Password} ssh -oStrictHostKeyChecking=no root@${Node_ip} chmod +x /etc/cron.daily/rdate
	sshpass -p ${Password} ssh -oStrictHostKeyChecking=no root@${Node_ip} /etc/cron.daily/rdate
	sshpass -p ${Password} ssh -oStrictHostKeyChecking=no root@${Node_ip} ln -sf /usr/share/zoneinfo/Asia/Seoul /etc/localtime
done

