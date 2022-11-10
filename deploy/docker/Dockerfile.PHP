
# -----------------------------------------------------
# Composer Part
# -----------------------------------------------------
# ARG COMPOSER_TAG
# FROM composer:2.0 as build-stage
# ARG WORK_DIR
# WORKDIR ${WORK_DIR}
# COPY composer.json ./composer.json
# COPY composer.lock ./composer.lock
# ENV COMPOSER_CACHE_DIR=${WORK_DIR}/.cache/composer
# RUN composer install \
#     --ignore-platform-reqs \
#     --no-interaction \
#     --no-plugins \
#     --no-scripts \
#     --prefer-dist

# -----------------------------------------------------
# PHP Part
# -----------------------------------------------------
ARG IMAGE_NAME
ARG IMAGE_TAG
FROM ${IMAGE_NAME}:${IMAGE_TAG} as app_php
ARG WORK_DIR
WORKDIR ${WORK_DIR}

ARG APK_TMP_ADD
ARG APK_ADD
ARG EXT_CONFIG
ARG EXT_INSTALL
ARG PLUGIN_MYSQL
ARG PLUGIN_YAML_VERSION
ARG PLUGIN_REDIS_VERSION

RUN apk update \
    && if [[ -n "${APK_TMP_ADD}" ]]; then apk --no-cache --virtual .build-deps add ${APK_TMP_ADD};fi \
    && apk --update --no-cache add autoconf ${APK_ADD} \
    && if [[ -n "${EXT_CONFIG}" ]]; then docker-php-ext-configure ${EXT_CONFIG};fi \
    && if [[ -n "${EXT_INSTALL}" ]]; then docker-php-ext-install ${EXT_INSTALL};fi \
    && if [[ -n "${PLUGIN_MYSQL}" ]]; then apk --update --no-cache add mysql-client && docker-php-ext-install mysqli pdo_mysql;fi \
    && if [[ -n "${PLUGIN_YAML_VERSION}" ]]; then apk --update --no-cache add yaml && pecl install yaml-${PLUGIN_YAML_VERSION} && docker-php-ext-enable yaml;fi \
    && if [[ -n "${PLUGIN_REDIS_VERSION}" ]]; then pecl install redis-${PLUGIN_REDIS_VERSION} && docker-php-ext-enable redis;fi \
    && if [[ -n "${APK_TMP_ADD}" ]]; then apk del --purge .build-deps;fi
RUN rm -rf /var/cache/apk/* /tmp/* /var/tmp/* /usr/share/doc/* /usr/share/man/*
ENV TZ Europe/Vienna