ARG IMAGE_NAME
ARG IMAGE_TAG
FROM ${IMAGE_NAME}:${IMAGE_TAG} as app_nginx

ENV APK_ADD \
    bash \
    nano

RUN apk add --update --no-cache ${APK_ADD}

ENV ENV_CONFIG_ROOT_FOLDER=/etc/nginx
ENV SERVER_NAME=api.noframework.io

COPY conf/dy.nginx.conf ${ENV_CONFIG_ROOT_FOLDER}/dynamic/dy.nginx.conf
RUN bash -c "envsubst < ${ENV_CONFIG_ROOT_FOLDER}/dynamic/dy.nginx.conf > ${ENV_CONFIG_ROOT_FOLDER}/dynamic/nginx.conf"

COPY conf/nginx.conf ${ENV_CONFIG_ROOT_FOLDER}/nginx.conf
COPY conf/locations/*.conf ${ENV_CONFIG_ROOT_FOLDER}/locations/

#
# add certbot
#
# RUN apk add certbot
# certbot certonly --webroot -w /usr/share/nginx -d www.noframework.io --email it@noframework.io --non-interactive --agree-tos
