FROM bitnami/nginx:1.16.0

LABEL maintainer="Jerome Mac Lean"
LABEL description="Small hello-world application to test Cloud and CICD solutions"

USER root
RUN mkdir -p /var/lib/apt/lists/partial && \
    apt-get update && \
    apt-get -y upgrade && \
    apt-get -y install \
      gosu \
      php7.0-fpm && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives

RUN mkdir /data && \
    chmod 777 /data
    # chmod -R 777 /var/log

USER 1001
ADD www /app
ADD nginx.conf /opt/bitnami/nginx/conf/server_blocks/
ADD php-fpm.conf /etc/php/7.0/fpm/
ADD ssl/certs/* /opt/bitnami/nginx/conf/server_blocks/ssl/certs/
ADD run.sh /run.sh


EXPOSE 8080 8443
CMD /run.sh
