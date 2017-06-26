FROM ubuntu:16.04
MAINTAINER Code Touch <info@jamgo.coop>

ENV DEBIAN_FRONTEND noninteractive	

COPY jnc /usr/local/bin/jnc
COPY ncLinuxApp.jar /root/ncLinuxApp.jar

# Install required packages
RUN set -x; \
    apt-get update && \
	apt-get install  --no-install-recommends  -y apt-utils && \
    apt-get install  --no-install-recommends  -y iptables && \
    apt-get install  --no-install-recommends  -y openssl unzip cron && \
	dpkg --add-architecture i386 && \
	apt-get  --no-install-recommends  -y install libc6-i386 lib32z1 lib32gcc1 && \
	mkdir -p /root/.juniper_networks/network_connect/config && \
	unzip /root/ncLinuxApp.jar -d /root/.juniper_networks/network_connect/ && \
	chown root:root /root/.juniper_networks/network_connect/ncsvc && \
	chmod 6711 /root/.juniper_networks/network_connect/ncsvc && \
	chmod 744 /root/.juniper_networks/network_connect/ncdiag && \
    rm -rf /var/lib/apt/lists/*    

COPY startup.sh /root/startup.sh
COPY docker-entrypoint.sh /entrypoint.sh



#ENTRYPOINT ["/entrypoint.sh"]
CMD ["/bin/bash"]