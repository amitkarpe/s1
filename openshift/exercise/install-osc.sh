#!/bin/bash

echo "Following command will be use to install OSC on master and node"

nmtui

yum install -y dnsmasq bind-utils

cat "/etc/dnsmasq.conf" | egrep 'resolv-file=|address='
resolv-file=/etc/resolv.dnsmasq
address=/lab.example.com/10.168.119.110

"/etc/resolv.dnsmasq"
nameserver 10.168.116.1

"/etc/resolv.conf"
search sevone.com wifi.sevone.com wilm.sevone.com nwk.sevone.com lab.example.com
nameserver 10.168.0.50
nameserver 10.193.0.50
nameserver 192.168.10.50
nameserver 127.0.0.1

systemctl stop firewalld && systemctl disable firewalld && systemctl start dnsmasq && systemctl enable dnsmasq

systemctl restart dnsmasq

host $(hostname)
ping -c1 gnu.org
ping -c1 lab.example.com


"/etc/hosts"
10.168.117.78	node1		node1.lab.example.com
10.168.119.135	node2		node2.lab.example.com
10.168.116.204	node3		node3.lab.example.com
10.168.116.200	node4  node4.lab.example.com
10.168.116.224	master		master.lab.example.com
10.168.116.53	workstation		workstation.lab.example.com
#10.168.117.221          openshift39 console console.support.nip.io

yum -y install docker-1.12.6
vim /etc/sysconfig/docker
         --insecure-registry 172.30.0.0/16
echo "DEVS=/xvdb
VG=docker-vg"     > /etc/sysconfig/docker-storage-setup
cat /etc/sysconfig/docker-storage-setup

yum -y install centos-release-openshift-origin
yum -y install atomic-openshift-docker-excluder \
atomic-openshift-excluder atomic-openshift-utils \
bind-utils bridge-utils git \
iptables-services net-tools wget

yum -y install origin-excluder
origin-excluder unexclude

yum update --assumeyes && \
yum install tmux nano unzip wget git net-tools bind-utils yum-utils iptables-services bridge-utils bash-completion kexec-tools sos psacct docker ansible php php-pear --assumeyes && \
systemctl reboot
