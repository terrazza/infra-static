#!/bin/bash
source $(realpath $(dirname "$0")/.helper)

OPTIONS=()
case ${1} in
  compose)
    case ${2} in
      down)
        CMD="docker-compose ${2}"
      ;;
      up)
        case ${3} in
          -d)
          OPTIONS+=(${3})
          ;;
        esac
        CMD="docker-compose ${2}"
      ;;
      *)
        error_exit "supported arguments for [COMMAND=compose] are: down,up"
      ;;
    esac
  ;;
  logs)
    if [ -z ${2} ]; then
      error_exit "argument missing: <CONTAINER>"
    fi
    CONTAINER_ID=$(getContainerId "${2}")
    CMD="docker ${1} ${CONTAINER_ID}"
    case ${3} in
      -f)
        OPTIONS+=(${3})
        ;;
      *)
        ;;
    esac
  ;;
  exec)
    if [ -z ${2} ]; then
      error_exit "argument missing: <CONTAINER>"
    fi
    CONTAINER_ID=$(getContainerId "${2}")
    CMD="docker ${1} -it ${CONTAINER_ID}"
    OPTIONS+=("/bin/sh")
    ;;
  --help|*)
    echo "Usage: docker.sh [COMMAND] {CONTAINER}"
    echo ""
    echo "Commands: "
    echo "   exec            call docker exec -it for given [container]"
    echo "   logs            log the given [container]"
    echo ""
    exit 1;
  ;;
esac
if [ ! -z "${CMD}" ]; then
  OPTIONS_AS_STRING=$(array2string " " " " " " "${OPTIONS[@]}")
  ${CMD} ${OPTIONS_AS_STRING}
fi
