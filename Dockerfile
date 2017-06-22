FROM ubuntu:16.04
MAINTAINER Jamgo Coop <info@jamgo.coop>

ARG JUNIPER_HOST
ARG JUNIPER_USER
ARG JUNIPER_PASSWORD

ENV JUNIPER_HOST=$JUNIPER_HOST
ENV JUNIPER_USER=$JUNIPER_USER
ENV JUNIPER_PASSWORD=$JUNIPER_PASSWORD

COPY jnc /usr/local/bin/jnc
COPY ncLinuxApp.jar ~/ncLinuxApp.jar

# Install required packages
RUN set -x; \
    apt-get update && \
    apt-get install -y --no-install-recommends git openconnect python-mechanize iptables supervisor && \
    apt-get install -y --no-install-recommends openssl unzip && \
	mkdir -p ~/.juniper_networks/network_connect/config && \
	unzip ~/ncLinuxApp.jar -d ~/.juniper_networks/network_connect/ && \
	chown root:root ~/.juniper_networks/network_connect/ncsvc && \
	chmod 6711 ~/.juniper_networks/network_connect/ncsvc && \
	chmod 744 ~/.juniper_networks/network_connect/ncdiag && \
	dpkg --add-architecture i386 && \
	apt-get -y install libc6-i386 lib32z1 && \
	openssl s_client -showcerts -connect csionet.com:443 < /dev/null | openssl x509 -outform DER > ~/.juniper_networks/network_connect/config/cert.der && \
	
    rm -rf /var/lib/apt/lists/* && \
	apt-get purge --auto-remove -y git 


COPY startup.sh /root/startup.sh
COPY docker-entrypoint.sh /entrypoint.sh



ENTRYPOINT ["/entrypoint.sh"]
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]