#!/bin/bash
source $(realpath $(dirname "$0")/.helper)

DOCKER_COMPOSE_FILE=docker-compose.yml
SERVICE_NAME=${1}
if [[ ! -d ${SERVICE_NAME} ]]; then
  error_exit "service/directory ${SERVICE_NAME} does not exists"
fi

if [[ ! -f ${SERVICE_NAME}/${DOCKER_COMPOSE_FILE} ]]; then
  error_exit "${SERVICE_NAME}/${DOCKER_COMPOSE_FILE} file does not exists"
fi
CMD="docker-compose -f ${SERVICE_NAME}/${DOCKER_COMPOSE_FILE}"
y=1
ARGUMENTS=( "$@" )
while [[ $y -lt ${#ARGUMENTS[@]} ]]
do
  ARGUMENT=${ARGUMENTS[$y]}
  case ${ARGUMENT} in
    --container)
      (( y++))
      CONTAINER_NAME=${ARGUMENTS[$y]}
      CONTAINER_ID=$(getDockerComposeContainerId ${SERVICE_NAME} ${CONTAINER_NAME})
      echo $CONTAINER_ID
      (( y++))
      ;;
    --preview)
      PREVIEW_CMD=1
      (( y++))
      ;;
    *)
      CMD="${CMD} ${ARGUMENT}"
      (( y++))
    ;;
  esac
done

echo "<I>execute ${CMD}"
if [[ -z ${PREVIEW_CMD} ]]; then
  ${CMD}
fi
