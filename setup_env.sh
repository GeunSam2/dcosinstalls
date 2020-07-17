#!/bin/bash

echo #########################
echo #install require packages
echo #########################


echo #install process 1
yum groupinstall -y "Development Tools"
yum -y --tolerant install perl tar xz unzip curl bind-utils net-tools ipset libtool-ltdl rsync nfs-utils kernel-devel pciutils


echo #check docker install
docker --version > /dev/null 2>&1
if [ $? -eq 0 ]; then
  echo #remove docker-ce
  yum remove docker-ce
fi


echo #install docker 1.13 version
curl -fLsSv --retry 20 -Y 100000 -y 60 -o /tmp/containerd.io-1.2.6-3.3.el7.x86_64.rpm \
  https://download.docker.com/linux/centos/7/x86_64/stable/Packages/containerd.io-1.2.6-3.3.el7.x86_64.rpm
curl -fLsSv --retry 20 -Y 100000 -y 60 -o /tmp/docker-ce-19.03.9-3.el7.x86_64.rpm \
  https://download.docker.com/linux/centos/7/x86_64/stable/Packages/docker-ce-19.03.9-3.el7.x86_64.rpm
curl -fLsSv --retry 20 -Y 100000 -y 60 -o /tmp/docker-ce-cli-19.03.9-3.el7.x86_64.rpm \
  https://download.docker.com/linux/centos/7/x86_64/stable/Packages/docker-ce-cli-19.03.9-3.el7.x86_64.rpm
  
yum -y localinstall /tmp/containerd.io-1.2.6-3.3.el7.x86_64.rpm
yum -y localinstall /tmp/docker-ce-19.03.9-3.el7.x86_64.rpm
yum -y localinstall /tmp/docker-ce-cli-19.03.9-3.el7.x86_64.rpm



echo #########################
echo #setup env
echo #########################


echo #disabling selinux
sed -i 's/SELINUX=enforcing/SELINUX=permissive/g' /etc/selinux/config
setenforce permissive


echo #change setting sshd
sed -i '/^\s*UseDNS /d' /etc/ssh/sshd_config
echo -e "\nUseDNS no" >> /etc/ssh/sshd_config 


echo #set journald limits
mkdir -p /etc/systemd/journald.conf.d/
echo -e "[Journal]\nSystemMaxUse=15G" > /etc/systemd/journald.conf.d/dcos-el7-ami.conf


echo #Removing tty requirement for sudo
sed -i'' -E 's/^(Defaults.*requiretty)/#\1/' /etc/sudoers


echo #setup docker
systemctl enable docker
/usr/sbin/groupadd -f docker
/usr/sbin/groupadd -f nogroup


echo #Customizing Docker storage driver to use Overlay
docker_service_d=/etc/systemd/system/docker.service.d
mkdir -p "$docker_service_d"
cat << 'EOF' > "${docker_service_d}/execstart.conf"
[Service]
Restart=always
StartLimitInterval=0
RestartSec=15
ExecStartPre=-/sbin/ip link del docker0
ExecStart=
ExecStart=/usr/bin/dockerd --graph=/var/lib/docker --storage-driver=overlay
EOF
systemctl restart docker


#disable firewalld
sudo systemctl stop firewalld
sudo systemctl disable firewalld


#disable dnsmasq
systemctl stop dnsmasq
systemctl disable dnsmasq.service


#locale set
localectl set-locale LANG=en_US.utf8


echo #clean up
yum clean all
rm -rf /tmp/* /var/tmp/*

echo #########################
echo #END OF SCRIPT
echo #########################

