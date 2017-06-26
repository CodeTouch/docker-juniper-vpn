#!/bin/bash

set -x

#if [ -z "$JUNIPER_HOST" ]; then
#	echo >&2 'error: missing JUNIPER_HOST environment variable'
#	exit 1
#fi

#if [ -z "$JUNIPER_USER" ]; then
#	echo >&2 'error: missing JUNIPER_USER environment variable'
#	exit 1
#fi

#if [ -z "$JUNIPER_PASSWORD" ]; then
#	echo >&2 'error: missing JUNIPER_PASSWORD environment variable'
#	exit 1
#fi

#sed 's/{{JUNIPER_HOST}}/'"${JUNIPER_HOST}"'/' -i /root/startup.sh
#sed 's/{{JUNIPER_USER}}/'"${JUNIPER_USER}"'/' -i /root/startup.sh
#sed 's/{{JUNIPER_PASSWORD}}/'"${JUNIPER_PASSWORD}"'/' -i /root/startup.sh

openssl s_client -showcerts -connect $JUNIPER_HOST:443 < /dev/null | openssl x509 -outform DER > /root/.juniper_networks/network_connect/config/cert.der

echo "host=$JUNIPER_HOST" > /root/.juniper_networks/network_connect/config/default.conf && \
echo "user=$JUNIPER_USER" >> /root/.juniper_networks/network_connect/config/default.conf && \
echo "password=$JUNIPER_PASSWORD" >> /root/.juniper_networks/network_connect/config/default.conf && \
echo "realm=Users" >> /root/.juniper_networks/network_connect/config/default.conf && \
echo "certfile=cert.der" >> /root/.juniper_networks/network_connect/config/default.conf

(crontab -l 2>/dev/null; echo "*/2 * * * * /usr/local/bin/jnc --nox") | crontab -

exec "$@"