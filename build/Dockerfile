FROM alpine:3.4

RUN apk --update add \
    nginx \
    php5-fpm \
    net-tools \
    bind-tools \
    bash && \
    mkdir -p /run/nginx

ADD www /www
ADD nginx.conf /etc/nginx/
ADD php-fpm.conf /etc/php5/php-fpm.conf
ADD run.sh /run.sh
ADD ssl /ssl

ENV LISTEN_PORT=80

EXPOSE 80 443
CMD /run.sh

ENV VERSION=v3
