#!/bin/bash
source $(realpath $(dirname "$0")/.helper)

OPTIONS=()
case ${1} in
  down|stop)
    CMD="docker-compose ${1}"
  ;;
  build)
    CMD="docker-compose ${1}"
    case ${2} in
      --no-cache)
      OPTIONS+=(${2})
      ;;
    esac
  ;;
  up)
    case ${2} in
      -d)
      OPTIONS+=(${2})
      ;;
    esac
    CMD="docker-compose ${1}"
  ;;
  logs)
    if [ -z ${2} ]; then
      error_exit "argument missing: <CONTAINER>"
    fi
    CONTAINER_ID=$(getContainerId "${2}")
    CMD="docker ${1} ${CONTAINER_ID}"
    echo ":${CMD}:"
    case ${3} in
      -f)
        OPTIONS+=(${3})
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
    CMD="docker exec -it ${CONTAINER_ID}"
    OPTIONS+=("/bin/${1}")
    ;;
  --help|*)
    echo "Usage: docker.sh [COMMAND] {CONTAINER}"
    echo ""
    echo "...docker-compose COMMAND list:"
    echo "   build           run docker-composer build (optional arguments: --no-cache)"
    echo "   up              run docker-composer up (optional arguments: -d)"
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
  OPTIONS_AS_STRING=$(array2string " " " " " " "${OPTIONS[@]}")
  ${CMD} ${OPTIONS_AS_STRING}
fi
