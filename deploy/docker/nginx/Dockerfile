ARG IMAGE_NAME
ARG IMAGE_TAG
FROM ${IMAGE_NAME}:${IMAGE_TAG} as app_nginx

ENV APK_ADD \
    bash \
    nano

RUN apk add --update --no-cache ${APK_ADD}

ENV ENV_CONTENT_ROOT_FOLDER=${CONTENT_FOLDER}
ENV ENV_ASSETS_ROOT_FOLDER=${ASSETS_FOLDER}
ENV ENV_HTML_ROOT_FOLDER=${HTML_FOLDER}
ENV ENV_CONFIG_ROOT_FOLDER=/etc/nginx
ENV ENV_CONFIG_LOCATION_FOLDER=${ENV_CONFIG_ROOT_FOLDER}/locations

COPY conf/nginx.conf ${ENV_CONFIG_ROOT_FOLDER}/nginx.conf
COPY conf/locations/*.conf ${ENV_CONFIG_LOCATION_FOLDER}/

#
# add certbot
#
# RUN apk add certbot
# certbot certonly --webroot -w /usr/share/nginx -d www.noframework.io --email it@noframework.io --non-interactive --agree-tos
