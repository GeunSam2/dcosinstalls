#!/bin/bash

Master_ip='192.168.0.181'
Private_ip='192.168.0.182 192.168.0.183 192.168.0.184 192.168.0.185'
Public_ip='192.168.0.187'
Bootst_ip='192.168.0.188'
Docker_pt='80'
Password='kbsys1234'

#Master script
echo "Master Job Start!"
sshpass -p ${Password} ssh root@${Master_ip} yum -y install ntp
sshpass -p ${Password} ssh root@${Master_ip} systemctl disable firewalld
sshpass -p ${Password} ssh root@${Master_ip} systemctl stop firewalld
sshpass -p ${Password} ssh root@${Master_ip} systemctl stop dnsmasq
sshpass -p ${Password} ssh root@${Master_ip} systemctl disable dnsmasq.service
sshpass -p ${Password} ssh root@${Master_ip} systemctl stop ntpd
xterm -e "sshpass -p ${Password} ssh root@${Master_ip} ntpdate 0.rhel.pool.ntp.org"&
xterm -e "sleep 10; sshpass -p ${Password} ssh root@${Master_ip} ntpdate 0.rhel.pool.ntp.org"&
xterm -e "sleep 20; sshpass -p ${Password} ssh root@${Master_ip} ntpdate 0.rhel.pool.ntp.org"&
sshpass -p ${Password} ssh root@${Master_ip} systemctl start ntpd
sshpass -p ${Password} ssh root@${Master_ip} systemctl enable ntpd
sshpass -p ${Password} ssh root@${Master_ip} mkdir -p /tmp/dcos
sshpass -p ${Password} ssh root@${Master_ip} cd /tmp/dcos
sshpass -p ${Password} ssh root@${Master_ip} curl -O http://${Bootst_ip}:${Docker_pt}/dcos_install.sh
xterm -e "echo 'Master Job'; sshpass -p ${Password} ssh root@${Master_ip} bash dcos_install.sh master; read -p 'Press... RETURN'"&

#Private_Agent script
echo "Private Job Start!"
for ip in $Private_ip
do
	echo Private ${ip} Job start!
	sshpass -p ${Password} ssh root@${Master_ip} yum -y install ntp
	sshpass -p ${Password} ssh root@${ip} systemctl disable firewalld
	sshpass -p ${Password} ssh root@${ip} systemctl stop firewalld
	sshpass -p ${Password} ssh root@${ip} systemctl stop dnsmasq
	sshpass -p ${Password} ssh root@${ip} systemctl disable dnsmasq.service
	sshpass -p ${Password} ssh root@${ip} systemctl stop ntpd
	xterm -e "sshpass -p ${Password} ssh root@${ip} ntpdate 0.rhel.pool.ntp.org"&
	xterm -e "sleep 10; sshpass -p ${Password} ssh root@${ip} ntpdate 0.rhel.pool.ntp.org"&
	xterm -e "sleep 20; sshpass -p ${Password} ssh root@${ip} ntpdate 0.rhel.pool.ntp.org"&
	sshpass -p ${Password} ssh root@${ip} ntpdate 0.rhel.pool.ntp.org
	sshpass -p ${Password} ssh root@${ip} systemctl start ntpd
	sshpass -p ${Password} ssh root@${ip} systemctl enable ntpd
	sshpass -p ${Password} ssh root@${ip} mkdir -p /tmp/dcos
	sshpass -p ${Password} ssh root@${ip} cd /tmp/dcos
	sshpass -p ${Password} ssh root@${ip} curl -O http://${Bootst_ip}:${Docker_pt}/dcos_install.sh
	xterm -e "echo ${ip}start ;sshpass -p ${Password} ssh root@${ip} bash dcos_install.sh slave; read -p 'Press... RERTURN'"&
done

#Public_Agent scirp
echo "Public Job start!"
sshpass -p ${Password} ssh root@${Public_ip} yum -y install ntp
sshpass -p ${Password} ssh root@${Public_ip} systemctl disable firewalld
sshpass -p ${Password} ssh root@${Public_ip} systemctl stop firewalld
sshpass -p ${Password} ssh root@${Public_ip} systemctl stop dnsmasq
sshpass -p ${Password} ssh root@${Public_ip} systemctl disable dnsmasq.service
sshpass -p ${Password} ssh root@${Public_ip} systemctl stop ntpd
xterm -e "sshpass -p ${Password} ssh root@${Public_ip} ntpdate 0.rhel.pool.ntp.org"&
xterm -e "sleep 10; sshpass -p ${Password} ssh root@${Public_ip} ntpdate 0.rhel.pool.ntp.org"&
xterm -e "sleep 20; sshpass -p ${Password} ssh root@${Public_ip} ntpdate 0.rhel.pool.ntp.org"&
sshpass -p ${Password} ssh root@${Public_ip} systemctl start ntpd
sshpass -p ${Password} ssh root@${Public_ip} systemctl enable ntpd
sshpass -p ${Password} ssh root@${Public_ip} mkdir /tmp/dcos
sshpass -p ${Password} ssh root@${Public_ip} cd /tmp/dcos
sshpass -p ${Password} ssh root@${Public_ip} curl -O http://${Bootst_ip}:${Docker_pt}/dcos_install.sh
xterm -e "echo 'Public start'; sshpass -p ${Password} ssh root@${Public_ip} bash dcos_install.sh slave_public; read -p 'Press... RETURN'"&

echo wait for xterm end
