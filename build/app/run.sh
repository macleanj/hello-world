#!/bin/sh
php-fpm7.0 -d variables_order="EGPCS" && exec nginx -g "daemon off;"