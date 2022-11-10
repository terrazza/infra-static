#!/bin/bash
source $(realpath $(dirname "$0")/.helper)

case ${1} in
  build|up|down|stop)
    METHOD=${1}
    CMD="docker-compose ${METHOD}"
    y=1
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
    if [ -z ${2} ]; then
      error_exit "argument missing: <CONTAINER>"
    fi
    CONTAINER_ID=$(getContainerId "${2}")
    CMD="docker ${1} ${CONTAINER_ID}"
    case ${3} in
      -f)
        CMD="${CMD} ${3}"
        ;;
      *)
        ;;
    esac
  ;;
  sh|bash)
    if [ -z ${2} ]; then
      error_exit "argument missing: <CONTAINER>"
    fi
    CONTAINER_ID=$(getContainerId "${2}")
    CMD="docker exec -it ${CONTAINER_ID} /bin/${1}"
    ;;
  --help|*)
    echo "Usage: docker.sh [COMMAND] {CONTAINER}"
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
  ${CMD} ${OPTIONS_AS_STRING}
fi
