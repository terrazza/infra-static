#!/bin/bash
set -e

BASE_FOLDER=$(realpath $(dirname "$0")/..)
BUILD_ARG_FILE=".build.args"
DOCKER_FILE="Dockerfile"

function error() {
    echo "Usage: build.sh <DOCKERFOLDER> <TAG> [OPTIONS]"
    echo
    echo "Options"
    echo "docker [OPTIONS]               all given arguments are forwarded to the docker command"
    echo "--preview                      echo the command that will be executed"
    echo
    if [[ ! -z ${1} ]]; then
    echo ${1}
    echo
    fi
    exit 1
}

if [[ -z ${1} ]]; then
  error "<E>Argument <DOCKERFOLDER> missing"
fi
DOCKER_FOLDER=${BASE_FOLDER}/${1}

if [ ! -f "${DOCKER_FOLDER}/${DOCKER_FILE}" ]; then
  error "<E>${DOCKER_FOLDER}/${DOCKER_FILE} missing/not found"
fi;
if [ ! -f "${DOCKER_FOLDER}/${BUILD_ARG_FILE}" ]; then
  error "<E>${DOCKER_FOLDER}/${BUILD_ARG_FILE} missing/not found"
fi;

if [[ -z ${2} ]]; then
  error "<E>Argument <TAG> missing"
fi
BUILD_IMAGE_TAG=${2}

#
# source .build.args and prepare initial cmd
#
source ${DOCKER_FOLDER}/${BUILD_ARG_FILE}
CMD="docker build . --tag ${BUILD_IMAGE_NAME}:${BUILD_IMAGE_TAG}"

#
# pass given .build.args as build-args to docker build
#
ARGUMENT=$(cat ${DOCKER_FOLDER}/${BUILD_ARG_FILE} | sed 's@^@--build-arg @g' | paste -sd ' ')
CMD="${CMD} ${ARGUMENT}"

#
# forward all given arguments to CMD (ignore first 2 arguments (DOCKERFOLDER, BUILD_IMAGE_TAG)
#
y=2
ARGUMENTS=( "$@" )
while [[ $y -lt ${#ARGUMENTS[@]} ]]
do
  ARGUMENT=${ARGUMENTS[$y]}
  case ${ARGUMENT} in
    --help)
      error;
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

#
# execute our just preview prepared CMD
#
start=`date +%s`
echo
echo "<I>start build.sh: $(date)"
echo "<I>switch to directory ${DOCKER_FOLDER}"
echo "<I>execute ${CMD}"
if [[ -z ${PREVIEW_CMD} ]]; then
  cd ${DOCKER_FOLDER}
  ${CMD}
fi
end=`date +%s`
runtime=$((end-start))
echo "<I>end build.sh: $(date) (runtime: ${runtime} sec)"
echo
