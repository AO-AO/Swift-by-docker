#!/bin/bash
Nic=eth0
swift_ip=`docker inspect --format='{{.NetworkSettings.IPAddress}}' swift`
set -x
#get the host_ipaddress
host_ip=`ifconfig ${Nic} | grep 'inet addr:' | cut -d: -f2 | awk '{print $1}'`
sed -i "s/`cat docker-keystone/bootstrap/bootstrap.sh | grep 'host_ip='`/host_ip=${host_ip}/g" docker-keystone/bootstrap/bootstrap.sh

sed -i "s/'`cat docker-swift/bootstrap/bootstrap.sh | grep 'host_ip='`'/host_ip=${host_ip}/g" docker-swift/bootstrap/bootstrap.sh

sed -i "s/`cat docker-keystone/etc/openstack-dashboard/local_settings.py | grep 'OPENSTACK_HOST ='`/OPENSTACK_HOST = \"${host_ip}\"/g" docker-keystone/etc/openstack-dashboard/local_settings.py

#sed -i "s/`grep OS_AUTH_URL docker-keystone/admin-openrc.sh | awk -F '[:/]' '{print $4}'`/${host_ip}/" docker-keystone/admin-openrc.sh

#sed -i "s/`grep auth_uri config/proxy-server.conf | awk -F '[:/]' '{print $4}'`/${host_ip}/" config/proxy-server.conf

#sed -i "s/`grep auth_url config/proxy-server.conf | awk -F '[:/]' '{print $4}'`/${host_ip}/" config/proxy-server.conf
# create database for keystone

#sed -i "s/`grep address= swift-rsync/etc/rsyncd.conf`/adress=${host_ip}/" swift-rsync/etc/rsyncd.conf 
# keystone init
# FIXME I need restart
docker run -d -e MYSQL_ROOT_PASSWORD=awcloud -h mysql --name mysql -d mariadb:10.1.12
sleep 20
docker run -itd  -p  5000:5000 -p 35357:35357 -p 80:80 --link mysql:mysql -v /opt/docker/docker-keystone/openstack-dashboard:/usr/share/openstack-dashboard/ -v /opt/docker/docker-keystone/bootstrap/:/root/bootstrap/ -v /opt/docker/docker-keystone/etc/openstack-dashboard/:/etc/openstack-dashboard/ --name keystone -h keystone keystone-horizon

docker run -itd --name swift -h swift -p 4040:4040   -v /opt/docker/config/:/etc/swift/ --link keystone:keystone swift-proxy

docker run --privileged=true -itd  --name swift-rsync -h swift-rsync -p  873:873 -v /opt/docker/data/vdb:/swift/vdb -v /opt/docker/data/vdc:/swift/vdc    swift-rsync

docker run --privileged=true  -p 6000:6000 -itd --name swift-object -h swiftdoc-object -v /opt/docker/config/:/etc/swift/ -v /opt/docker/data/vdb:/swift/vdb -v /opt/docker/data/vdc:/swift/vdc swift-object 

docker run --privilesged=true -p 6001:6001 -itd --name swift-container -h swift-container -v /opt/docker/config/:/etc/swift/ -v /opt/docker/data/vdb:/swift/vdb -v /opt/docker/data/vdc:/swift/vdc swift-container 

docker run --privileged=true  -p 6002:6002 -itd --name swift-account -h swift-acount -v /opt/docker/config/:/etc/swift/ -v /opt/docker/data/vdb:/swift/vdb -v /opt/docker/data/vdc:/swift/vdc swift-account 

docker cp keystone:/etc/hosts docker-keystone/etc/hosts
echo "${swift_ip} swfit" >> docker-keystone/etc/hosts
docker cp docker-keystone/etc/hosts keystone:/etc/hosts
set +x
echo "OK"
