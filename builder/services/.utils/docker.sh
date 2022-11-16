#!/bin/bash
source $(realpath $(dirname "$0")/.helper)

SERVICE_NAME=${1}
if [[ ! -d ${SERVICE_NAME} ]]; then
  error_exit "service/directory ${SERVICE_NAME} does not exists"
fi

METHOD=${2}
case ${METHOD} in
  build|up|down|stop|ps)
    CMD="docker-compose ${METHOD}"
    y=2
    ARGUMENTS=( "$@" )
    while [[ $y -lt ${#ARGUMENTS[@]} ]]
    do
      ARGUMENT=${ARGUMENTS[$y]}
      case ${ARGUMENT} in
        --|*)
          CMD="${CMD} ${ARGUMENT}"
          (( y++))
        ;;
        -)
          (( y++))
        ;;
      esac
    done
  ;;
  logs)
    CONTAINER_ID=$(getContainerId ${SERVICE_NAME} ${3})
    CMD="docker ${1} ${CONTAINER_ID}"
    case ${4} in
      -f)
        CMD="${CMD} ${4}"
        ;;
      *)
        ;;
    esac
  ;;
  sh|bash)
    CONTAINER_ID=$(getContainerId ${SERVICE_NAME} ${3})
    CMD="docker exec -it ${CONTAINER_ID} /bin/${METHOD}"
    ;;
  --help|*)
    echo "Usage: docker.sh [SERVICE_NAME] [COMMAND] {CONTAINER}"
    echo ""
    echo "...docker-compose COMMAND list:"
    echo "   build           run docker-composer build"
    echo "   up              run docker-composer up"
    echo "   down            run docker-composer down"
    echo "   stop            run docker-composer stop"
    echo "....docker COMMAND list:"
    echo "   sh              run docker exec -it /bin/sh for given [CONTAINER]"
    echo "   bash            run docker exec -it /bin/bash for given [CONTAINER]"
    echo "   logs            run docker logs for given [CONTAINER]"
    echo ""
    exit 1;
  ;;
esac
if [ ! -z "${CMD}" ]; then
  echo "<I>switch to directory ${SERVICE_NAME}"
  cd ${SERVICE_NAME}
  echo "<I>execute ${CMD} ${OPTIONS_AS_STRING}"
  ${CMD} ${OPTIONS_AS_STRING}
fi
