
ARG IMAGE_NAME
ARG IMAGE_TAG

FROM ${IMAGE_NAME}:${IMAGE_TAG} as app_php

ARG APK_TMP_ADD
ARG APK_ADD
ARG EXT_CONFIG
ARG EXT_INSTALL
ARG YAML_VERSION
ARG REDIS_VERSION

RUN apk update
RUN if [ ! -z "${APK_TMP_ADD}" ]; then apk --no-cache --virtual .build-deps add ${APK_TMP_EXT}; else echo "[SKIP] APK_TMP_ADD";fi
RUN if [ ! -z "${APK_ADD}" ]; then apk --update --no-cache add ${APK_EXT}; else echo "[SKIP] APK_EXT";fi
RUN if [ ! -z "${EXT_CONFIG}" ]; then docker-php-ext-configure ${EXT_CONFIG}; else echo "[SKIP] EXT_CONFIG";fi
RUN if [ ! -z "${EXT_INSTALL}" ]; then docker-php-ext-install ${EXT_INSTALL}; else echo "[SKIP] EXT_INSTALL";fi
# if [ ! -z "${YAML_VERSION}" ]; then
# apk --update --no-cache add yaml
# pecl install yaml-${YAML_VERSION}
# docker-php-ext-enable yaml
# fi

# if [ ! -z "${REDIS_VERSION}" ]; then
# pecl install redis-${REDIS_VERSION}
# docker-php-ext-enable redis
# fi
RUN if [ ! -z "${APK_TMP_ADD}" ]; then apk del --purge .build-deps; else echo "[NO] APK_TMP_EXT";fi
RUN rm -rf /var/cache/apk/* /tmp/* /var/tmp/* /usr/share/doc/* /usr/share/man/*


