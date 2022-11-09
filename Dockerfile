
#
# build bginx
#
ARG NGINX_IMAGE_NAME
ARG NGINX_IMAGE_TAG

FROM ${NGINX_IMAGE_NAME}:${NGINX_IMAGE_TAG} as app_nginx

#
# build php
#

ARG PHP_IMAGE_NAME
ARG PHP_IMAGE_TAG

FROM ${PHP_IMAGE_NAME}:${PHP_IMAGE_TAG} as app_php

ARG PHP_APK_TMP_EXT
ARG PHP_APK_EXT
ARG PHP_USE_COMPOSER

RUN apk update \
    && if [[ -z "${PHP_APK_TMP_EXT}" ]]; then echo " ---> no temp apk extensions"; else apk --no-cache --virtual .build-deps add ${PHP_APK_TMP_EXT}; fi \
    && if [[ -z "${PHP_APK_EXT}" ]]; then echo " ---> no apk extensions"; else apk --update --no-cache add ${PHP_APK_EXT}; fi \
# cleanups
    && if [[ -z "${PHP_APK_TMP_EXT}" ]]; then echo " ---> no temp apk extensions, no del .build-deps"; else apk del --purge .build-deps; fi \
    && rm -rf /var/cache/apk/* /tmp/* /var/tmp/* /usr/share/doc/* /usr/share/man/*

# create symlink so programs depending on `php` still function
#RUN ln -s /usr/bin/php8 /usr/bin/php \
# create default workdir
#    && mkdir -p /var/www/html

#WORKDIR /var/www/html
