#!/bin/bash
# @author Michael Wiesendanger <michael.wiesendanger@gmail.com>
# @description build script for docker-jenkins container

# abort when trying to use unset variable
set -o nounset

WD="${PWD}"

# variable setup
DOCKER_JENKINS_TAG="ragedunicorn/jenkins"
DOCKER_JENKINS_NAME="jenkins"
DOCKER_JENKINS_DATA_VOLUME="jenkins_data"

# get absolute path to script and change context to script folder
SCRIPTPATH="$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)"
cd "${SCRIPTPATH}"

echo "$(date) [INFO]: Building container: ${DOCKER_JENKINS_NAME}"

# build java container
docker build -t "${DOCKER_JENKINS_TAG}" ../

# check if redis data volume already exists
docker volume inspect "${DOCKER_JENKINS_DATA_VOLUME}" > /dev/null 2>&1

if [ $? -eq 0 ]; then
  echo "$(date) [INFO]: Reusing existing volume: ${DOCKER_JENKINS_DATA_VOLUME}"
else
  echo "$(date) [INFO]: Creating new volume: ${DOCKER_JENKINS_DATA_VOLUME}"
  docker volume create --name "${DOCKER_JENKINS_DATA_VOLUME}" > /dev/null
fi

cd "${WD}"
