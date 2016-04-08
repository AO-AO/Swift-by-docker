FROM ubuntu:update
MAINTAINER krystism "xuao@gmail.com"
# install packages
RUN set -x \
	&& apt-get -y install \
		swift \
		swift-proxy \
		python-swiftclient \
		python-keystoneclient \
		python-keystonemiddleware \
		rsync \
		swift-account \
		swift-container \
		swift-object \
	&& apt-get -y clean \
	&& rm -f /var/lib/keystone/keystone.db
VOLUME /etc/keystone
VOLUME /swift/vdb/
VOLUME /swift/vdc/
VOLUME /var/log/
ADD admin-openrc.sh /root/admin-openrc.sh
ADD etc/rsyncd.conf /etc/rsyncd.conf
ADD etc/swift/proxy-server.conf /etc/swift/
ADD etc/swift/account-server.conf /etc/swift/
ADD etc/swift/container-server.conf /etc/swift/
ADD etc/swift/object-server.conf /etc/swift/
ADD etc/swift/swift.conf /etc/swift/
ADD etc/default/rsync /etc/default/rsync
EXPOSE 9090
# copy sql script
# copy keystone config file

# add bootstrap script and make it executable
