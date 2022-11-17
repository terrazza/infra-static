#!/bin/bash
set -e

function exit_help() {
  if [[ ! -z ${1} ]];then
    echo "$(tput setaf 1)[$(date)]<E> ${1}$(tput sgr 0)"
    echo
  fi
  echo "Usage: docker-compose.sh [SERVICE_NAME] [COMMAND] (OPTIONS...)"
  echo
  echo "Arguments:"
  echo "   SERVICE_NAME                   is an existing path within"
  echo "                                  /.docker-compose.yml"
  echo
  echo "Options:"
  echo "--preview                         echo built Command"
  echo
  echo "Commands:"
  echo "bash                              Execute -it [CONTAINER_NAME] /bin/bash"
  echo "   Options:"
  echo "   [CONTAINER_NAME]               service to execute against (required)"
  echo "sh                                Execute /bin/sh"
  echo "   Options:"
  echo "   [CONTAINER_NAME]               service to execute against (required)"
  echo "exec                              Execute -it [CONTAINER_NAME] a command"
  echo "   Options:"
  echo "   [CONTAINER_NAME]               service to execute against (required)"
  echo "build                             Build or rebuild services"
  echo "   Options:"
  echo "   --build-arg stringArray        Set build-time variables for services."
  echo "   --no-cache                     Do not use cache when building the image"
  echo "   -q, --quiet                    Don't print anything to STDOUT"
  echo "up                                Create and start containers"
  echo "   Options:"
  echo "   -d, --detach                   Detached mode: Run containers in the background"
  echo "down                              Stop and remove containers, networks"
  echo "ps                                List containers"
  echo "   Options:"
  echo "    -a, --all                     Show all stopped containers (including those created by the run command)"
  echo "ls                                List running compose projects"
  echo "   Options:"
  echo "    -a, --all                     Show all stopped Compose projects"
  echo "images                            List images used by the created containers"
  echo "logs                              View output from containers (require --container [CONTAINER_NAME]"
  echo "   Options:"
  echo "   [CONTAINER_NAME]               optional, "
  echo "   -f, --follow                   follow"
  echo "   -t, --timestamps               Show timestamps"
  echo "   --timestamps string            Show logs before a timestamp (e.g. 2013-01-02T13:23:37Z) or relative (e.g. 42m for 42 minutes)"
  echo
  if [[ ! -z ${1} ]];then
    exit 1
  fi
}

#
# CONSTANT ARGS
#
BUILD_ARG_FILE=.build.args
DOCKER_COMPOSE_FILE_PATTERN=docker-compose.y*ml
DOCKER_COMPOSE_LOCAL_FILE_PATTERN=docker-compose.local.y*ml
CMD="docker-compose"

#
#
#
SERVICE_NAME=${1}
if [[ -z ${SERVICE_NAME} ]]; then
  exit_help "argument [SERVICE_NAME] missing"
fi
if [[ ! -d ${SERVICE_NAME} ]]; then
  exit_help "service/directory ${SERVICE_NAME} does not exists"
fi

DOCKER_COMPOSE_FILE=$(ls ${SERVICE_NAME}/${DOCKER_COMPOSE_FILE_PATTERN} | grep "${1}" | awk '{print $1}')
if [[ -z ${DOCKER_COMPOSE_FILE} ]]; then
  exit_help "${SERVICE_NAME}/${DOCKER_COMPOSE_FILE_PATTERN} file does not exists"
fi


ARGUMENTS=( "$@" )
#
# handle --local property
#
y=1
while [[ $y -lt ${#ARGUMENTS[@]} ]]
do
  ARGUMENT=${ARGUMENTS[$y]}
  case ${ARGUMENT} in
    --local)
      DOCKER_COMPOSE_LOCAL_FILE=$(ls ${SERVICE_NAME}/${DOCKER_COMPOSE_LOCAL_FILE_PATTERN} | grep "${1}" | awk '{print $1}')
      if [[ -z ${DOCKER_COMPOSE_FILE} ]]; then
        exit_help "${SERVICE_NAME}/${DOCKER_COMPOSE_LOCAL_FILE_PATTERN} file does not exists"
      fi
      #
      # get basename of COMPOSE_FILE(s)
      #
      DOCKER_COMPOSE_FILE="$(basename -- ${DOCKER_COMPOSE_FILE})"
      DOCKER_COMPOSE_LOCAL_FILE="$(basename -- ${DOCKER_COMPOSE_LOCAL_FILE})"
      CMD="${CMD} --file ${DOCKER_COMPOSE_FILE} --file ${DOCKER_COMPOSE_LOCAL_FILE}"
      (( y++))
    ;;
    *)
      (( y++))
    ;;
  esac
done

#
# common stuff
#
y=1
while [[ $y -lt ${#ARGUMENTS[@]} ]]
do
  ARGUMENT=${ARGUMENTS[$y]}
  case ${ARGUMENT} in
    bash|sh)
      (( y++))
      CONTAINER_NAME=${ARGUMENTS[$y]}
      CMD="${CMD} exec -it ${CONTAINER_NAME} /bin/${ARGUMENT}"
      ECHO_STEPS=1
      (( y++))
    ;;
    #
    # skip --local argument (handled above)
    #
    --local)
      (( y++))
    ;;
    up)
      CMD="${CMD} ${ARGUMENT}"
      #
      # source .build.args
      #
      if [[ -f ${SERVICE_NAME}/${BUILD_ARG_FILE} ]]; then
        source ${SERVICE_NAME}/${BUILD_ARG_FILE}
      fi
      (( y++))
    ;;
    build)
      ECHO_STEPS=1
      CMD="${CMD} ${ARGUMENT}"
      #
      # source .build.args
      # + bypass .build.args into -build-args
      #
      if [[ -f ${SERVICE_NAME}/${BUILD_ARG_FILE} ]]; then
        source ${SERVICE_NAME}/${BUILD_ARG_FILE}
        # BUILD_ARGS=$(cat ${SERVICE_NAME}/${BUILD_ARG_FILE} | sed 's@^@--build-arg @g' | paste -sd ' ')
        # CMD="${CMD} ${BUILD_ARGS}"
      fi
      (( y++))
    ;;
    exec)
      exit_help "COMMAND ${ARGUMENT} not supported (use bash or sh)"
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

#
# execute or just preview prepared CMD
#
start=`date +%s`
if [[ ! -z ${ECHO_STEPS} ]] || [[ ! -z ${PREVIEW_CMD} ]]; then
  echo "[$(date)]<I> switch to directory ${SERVICE_NAME}"
  echo "[$(date)]<I> start execute command: ${CMD}"
fi;
if [[ -z ${PREVIEW_CMD} ]]; then
  cd ${SERVICE_NAME}
  ${CMD}
fi
if [[ ! -z ${ECHO_STEPS} ]]; then
  end=`date +%s`
  runtime=$((end-start))
  echo "[$(date)]<I> end execute command: (runtime: ${runtime} sec)"
  echo
fi