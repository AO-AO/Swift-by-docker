#!/bin/bash
Nic=eth0

set -x
#get the host_ipaddress
host_ip=`ifconfig ${Nic} | grep 'inet addr:' | cut -d: -f2 | awk '{print $1}'`
sed -i "s/`cat docker-keystone/bootstrap/bootstrap.sh | grep 'host_ip='`/host_ip=${host_ip}/g" docker-keystone/bootstrap/bootstrap.sh
# create database for keystone
sleep 5

# keystone init
# FIXME I need restart
set +x
echo "OK"
