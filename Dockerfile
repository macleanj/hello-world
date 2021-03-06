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

USER 1001
ADD build/app/www /app
ADD config /config
ADD build/app/nginx.conf /opt/bitnami/nginx/conf/server_blocks/
ADD build/app/php-fpm.conf /etc/php/7.0/fpm/
ADD build/app/ssl/certs/* /opt/bitnami/nginx/conf/server_blocks/ssl/certs/
ADD build/app/run.sh /run.sh

EXPOSE 8080 8443
CMD /run.sh
