ARG IMAGE_NAME
ARG IMAGE_TAG
ARG COMPOSER_VERSION

FROM composer:${COMPOSER_VERSION} as build-stage

# WORKDIR /app
COPY ./composer.json ./composer.json
# COPY ../../composer.lock ./composer.lock

ENV COMPOSER_CACHE_DIR=/app/.cache/composer

RUN composer install \
    --no-interaction \
    --no-dev \
    --optimize-autoloader

# RUN mkdir /prod \
#    && mkdir -p /app/var/log \
#    && cp -r bin config migrations public src templates var vendor .env /prod \
#    && mv .env.local.php /prod

# RUN cp -r migrations public src vendor .env /prod

# FROM ${PHP_IMAGE_NAME}-xdebug:${PHP_IMAGE_TAG} as test-stage
#
# WORKDIR /app
# COPY --from=build-stage /app ./
#
FROM ${IMAGE_NAME}:${IMAGE_TAG} as production-stage

ARG EXPOSE_PORT
ARG SERVICE_NAME
ENV PHP_FPM_PM_LISTEN="${SERVICE_NAME}:${EXPOSE_PORT}"
ENV PHP_FPM_INI_DIR="/usr/local/etc/php-fpm.d"
COPY fpm-conf/*.conf ${PHP_FPM_INI_DIR}/

EXPOSE ${EXPOSE_PORT}
#WORKDIR /app
#COPY --from=build-stage /app ./

