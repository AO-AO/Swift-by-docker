#!/bin/bash

set -x
#get the host_ipaddress
docker kill mysql
docker rm mysql
docker kill keystone
docker rm keystone
docker kill swift-account
docker rm swift-account
docker kill swift-container
docker rm swift-container
docker kill swift-object
docker rm swift-object
docker kill swift-rsync
docker rm swift-rsync
docker kill swift
docker rm swift
rm config/*.ring.gz
rm -rf config/backups
rm config/*.builder
# keystone init
# FIXME I need restart
set +x
echo "OK"
