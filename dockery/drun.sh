#!/bin/bash
# @author Michael Wiesendanger <michael.wiesendanger@gmail.com>
# @description run script for docker-jenkins container

# abort when trying to use unset variable
set -o nounset

WD="${PWD}"

# variable setup
DOCKER_JENKINS_TAG="ragedunicorn/jenkins"
DOCKER_JENKINS_NAME="jenkins"
DOCKER_JENKINS_ID=0

# get absolute path to script and change context to script folder
SCRIPTPATH="$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)"
cd "${SCRIPTPATH}"

# check if there is already an image created
docker inspect ${DOCKER_JENKINS_NAME} &> /dev/null

if [ $? -eq 0 ]; then
  # start container
  docker start "${DOCKER_JENKINS_NAME}"
else
  ## run image:
  # -p expose port
  # -v mount a volume
  # -d run in detached mode
  # -i Keep STDIN open even if not attached
  # -t Allocate a pseudo-tty
  # --name define a name for the container(optional)
  DOCKER_JENKINS_ID=$(docker run \
  -p 8080:8080 \
  -p 50000:50000 \
  -v jenkins_data:/var/jenkins_home \
  -dit \
  --name "${DOCKER_JENKINS_NAME}" "${DOCKER_JENKINS_TAG}")
fi

if [ $? -eq 0 ]; then
  # print some info about containers
  echo "$(date) [INFO]: Container info:"
  docker inspect -f '{{ .Config.Hostname }} {{ .Name }} {{ .Config.Image }} {{ .NetworkSettings.IPAddress }}' ${DOCKER_JENKINS_NAME}
else
  echo "$(date) [ERROR]: Failed to start container - ${DOCKER_JENKINS_NAME}"
fi

cd "${WD}"
