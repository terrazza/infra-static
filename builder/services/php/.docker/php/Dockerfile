ARG PHP_IMAGE_NAME
ARG PHP_IMAGE_TAG
# ARG COMPOSER_VERSION
#
# FROM composer:${COMPOSER_VERSION} as build-stage
#
# WORKDIR /app
# COPY ../../composer.json ./composer.json
# COPY ../../composer.lock ./composer.lock

# ENV COMPOSER_CACHE_DIR=/app/.cache/composer

# RUN composer install \
#     --no-interaction \
#     --no-dev \
#     --optimize-autoloader

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
FROM ${PHP_IMAGE_NAME}:${PHP_IMAGE_TAG} as production-stage

#WORKDIR /app
#COPY --from=build-stage /app ./

