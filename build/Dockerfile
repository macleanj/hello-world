FROM alpine:3.4

RUN apk --update add \
    nginx \
    php5-fpm \
    net-tools \
    bind-tools \
    bash && \
    mkdir -p /run/nginx

# # Add Mongo (180MB)
# RUN \
#   echo 'http://dl-cdn.alpinelinux.org/alpine/v3.6/main' >> /etc/apk/repositories && \
#   echo 'http://dl-cdn.alpinelinux.org/alpine/v3.6/community' >> /etc/apk/repositories && \
#   apk update && \
#   apk add mongodb=3.4.4-r0 && \
#   rm -rf /var/cache/apk/*

ADD www /www
ADD nginx.conf /etc/nginx/
ADD php-fpm.conf /etc/php5/php-fpm.conf
ADD run.sh /run.sh
ADD ssl /ssl

ENV LISTEN_PORT=80

EXPOSE 80 443
CMD /run.sh

ENV VERSION=v3
