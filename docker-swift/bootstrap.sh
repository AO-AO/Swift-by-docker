#!/bin/bash

set -x
#get the host_ipaddress
host_ip=192.168.139.201
# create database for keystone
mysql -uroot -pawcloud -hmysql

CREATE DATABASE keystone;
GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'localhost' IDENTIFIED BY 'awcloud';
GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'%' IDENTIFIED BY 'awcloud';
su -s /bin/sh -c "keystone-manage db_sync" keystone
service apache2 restart
source /root/admin-openrc.sh
openstack service create   --name keystone --description "OpenStack Identity" identity
openstack endpoint create --region RegionOneidentity public http://${host_ip}:5000/v2.0
openstack endpoint create --region RegionOne   identity internal http://${host_ip}:5000/v2.0
openstack endpoint create --region RegionOne   identity admin http://${host_ip}:35357/v2.0

openstack project create --domain default   --description "Admin Project" admin
openstack user create --domain default   --password-prompt admin
openstack role create admin
openstack role add --project admin --user admin admin
openstack project create --domain default   --description "Service Project" service
openstack project create --domain default   --description "Demo Project" demo
openstack user create --domain default   --password-prompt demo
openstack role create user
openstack role add --project demo --user demo user

openstack user create --domain default --password-prompt swift
openstack role add --project service --user swift admin
openstack service create --name swift   --description "OpenStack Object Storage" object-store
openstack endpoint create --region RegionOne  object-store public http://${host_ip}:4040/v1/AUTH_%\(tenant_id\)s
openstack endpoint create --region RegionOne   object-store internal http://${host_ip}:4040/v1/AUTH_%\(tenant_id\)s
openstack endpoint create --region RegionOne   object-store admin http://${host_ip}:4040/v1
# it may take some time to start keystone service, waiting for it.
sleep 5

# keystone init
service apache2 restart
# FIXME I need restart
set +x
echo "OK"
