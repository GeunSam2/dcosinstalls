#!/bin/bash

MASTER_IP_LIST="187"
SLAVE_IP_LIST="185 186 246"
PUBLIC_IP_LIST="182"
Password=kbsys1234

for Node_ip in ${MASTER_IP_LIST}
do
        echo ${Node_ip}
        sshpass -p ${Password} scp -oStrictHostKeyChecking=no ./setup-env.sh root@192.168.0.${Node_ip}:/tmp/setup_env.sh
        sshpass -p ${Password} ssh -oStrictHostKeyChecking=no root@192.168.0.${Node_ip} chmod 775 /tmp/setup_env.sh
        sshpass -p ${Password} ssh -oStrictHostKeyChecking=no root@192.168.0.${Node_ip} /tmp/setup_env.sh
        sshpass -p ${Password} ssh -oStrictHostKeyChecking=no root@192.168.0.${Node_ip} bash /tmp/dcos_install.sh master>/tmp/install${Node_ip}.log 2>&1&
        echo install master started
done

for Node_ip in ${SLAVE_IP_LIST}
do
        echo ${Node_ip}
        sshpass -p ${Password} scp -oStrictHostKeyChecking=no ./setup-env.sh root@192.168.0.${Node_ip}:/tmp/setup_env.sh
        sshpass -p ${Password} ssh -oStrictHostKeyChecking=no root@192.168.0.${Node_ip} chmod 775 /tmp/setup_env.sh
        sshpass -p ${Password} ssh -oStrictHostKeyChecking=no root@192.168.0.${Node_ip} /tmp/setup_env.sh
        sshpass -p ${Password} ssh -oStrictHostKeyChecking=no root@192.168.0.${Node_ip} bash /tmp/dcos_install.sh slave>/tmp/install${Node_ip}.log 2>&1&
done

for Node_ip in ${PUBLIC_IP_LIST}
do
        echo ${Node_ip}
        sshpass -p ${Password} scp -oStrictHostKeyChecking=no ./setup-env.sh root@192.168.0.${Node_ip}:/tmp/setup_env.sh
        sshpass -p ${Password} ssh -oStrictHostKeyChecking=no root@192.168.0.${Node_ip} chmod 775 /tmp/setup_env.sh
        sshpass -p ${Password} ssh -oStrictHostKeyChecking=no root@192.168.0.${Node_ip} /tmp/setup_env.sh
        sshpass -p ${Password} ssh -oStrictHostKeyChecking=no root@192.168.0.${Node_ip} bash /tmp/dcos_install.sh slave_public>/tmp/install.log 2>&1&
done
