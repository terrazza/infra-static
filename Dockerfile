
ARG DB_IMAGE_NAME
ARG DB_IMAGE_TAG

FROM ${DB_IMAGE_NAME}:${DB_IMAGE_TAG} as db
