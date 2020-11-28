FROM python:3.7.9-slim
LABEL maintainer="Jeronimo Diaz <jeronimo.telec@gmail.com>"

ENV DATA_DIR=/data \
    BIND_USER=bind \
    WEBMIN_VERSION=1.962

RUN rm -rf /etc/apt/apt.conf.d/docker-gzip-indexes \
    && apt-get -o Acquire::GzipIndexes=false update \
    && apt install -y unzip shared-mime-info wget bind9 perl libnet-ssleay-perl openssl libauthen-pam-perl libpam-runtime libio-pty-perl dnsutils apt-show-versions python \
    && wget "http://prdownloads.sourceforge.net/webadmin/webmin_${WEBMIN_VERSION}_all.deb" -P /tmp/ \
    && dpkg -i /tmp/webmin_${WEBMIN_VERSION}_all.deb \
    && rm -rf /tmp/webmin_${WEBMIN_VERSION}_all.deb

COPY entrypoint.sh /sbin/entrypoint.sh
RUN chmod 755 /sbin/entrypoint.sh

EXPOSE 53/udp 10000/tcp
VOLUME ["${DATA_DIR}"]
ENTRYPOINT ["/sbin/entrypoint.sh"]
CMD ["/usr/sbin/named"]
