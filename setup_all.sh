#!/bin/bash

IP_RANGE="192.168.0."
NODE_IP_LIST="187"
Password=kbsys1234

for Node_ip in ${NODE_IP_LIST}
do
        echo ${Node_ip}
        sshpass -p ${Password} scp -oStrictHostKeyChecking=no ./setup-env.sh root@${IP_RANG}${Node_ip}:/tmp/setup_env.sh
        sshpass -p ${Password} ssh -oStrictHostKeyChecking=no root@${IP_RANG}${Node_ip} chmod 775 /tmp/setup_env.sh
        sshpass -p ${Password} ssh -oStrictHostKeyChecking=no root@${IP_RANG}${Node_ip} bash /tmp/setup_env.sh > /tmp/setup${Node_ip}.log 2>&1&
        echo setup-env started at ${Node_ip}
done
