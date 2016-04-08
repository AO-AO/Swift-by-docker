FROM ubuntu:update
MAINTAINER krystism "xuao@gmail.com"
# install packages
RUN set -x \
	&& apt-get -y install \
		swift-account \
	&& apt-get -y clean \
	&& rm -f /var/lib/keystone/keystone.db
VOLUME /swift/vdb
VOLUME /swift/vdc
#VOLUME /etc/swift/

#ADD etc/swift/account-server.conf /etc/swift/
#ADD etc/swift/swift.conf /etc/swift/

EXPOSE	6002
# copy sql script
# copy keystone config file

# add bootstrap script and make it executable
