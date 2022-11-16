#!/bin/bash
set -e

function exit_help() {
  if [[ ! -z ${1} ]];then
    echo "<E>${1}"
    echo
  fi
  echo "Usage: docker-compose.sh [SERVICE_NAME] [COMMAND] (OPTIONS...)"
  echo
  echo "requirements"
  echo "   SERVICE_NAME is an existing path within"
  echo "   /.docker-compose.yml"
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
DOCKER_COMPOSE_FILE=docker-compose.yml
SERVICE_NAME=${1}
if [[ -z ${SERVICE_NAME} ]]; then
  exit_help "argument [SERVICE_NAME] missing"
fi
if [[ ! -d ${SERVICE_NAME} ]]; then
  exit_help "service/directory ${SERVICE_NAME} does not exists"
fi

if [[ ! -f ${SERVICE_NAME}/${DOCKER_COMPOSE_FILE} ]]; then
  echo
  echo "${SERVICE_NAME}/${DOCKER_COMPOSE_FILE} file does not exists"
  exit_help
fi
CMD="docker-compose -f ${SERVICE_NAME}/${DOCKER_COMPOSE_FILE}"
CMD="docker-compose"
y=1
ARGUMENTS=( "$@" )
while [[ $y -lt ${#ARGUMENTS[@]} ]]
do
  ARGUMENT=${ARGUMENTS[$y]}
  case ${ARGUMENT} in
    bash|sh)
      (( y++))
      CONTAINER_NAME=${ARGUMENTS[$y]}
      CMD="${CMD} exec -it ${CONTAINER_NAME} /bin/${ARGUMENT}"
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
# execute our just preview prepared CMD
#
start=`date +%s`
echo
echo "<I>start docker-compose.sh: $(date)"
echo "<I>switch to directory ${SERVICE_NAME}"
echo "<I>execute ${CMD}"
if [[ -z ${PREVIEW_CMD} ]]; then
  cd ${SERVICE_NAME}
  ${CMD}
fi
end=`date +%s`
runtime=$((end-start))
echo "<I>end docker-compose.sh: $(date) (runtime: ${runtime} sec)"
echo
