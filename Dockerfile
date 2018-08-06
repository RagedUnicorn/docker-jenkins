FROM ragedunicorn/openjdk:1.1.0-jre-stable

LABEL com.ragedunicorn.maintainer="Michael Wiesendanger <michael.wiesendanger@gmail.com>"

#    ______                           __
#   /_  __/___  ____ ___  _________ _/ /_
#   / / / __ \/ __ `__ \/ ___/ __ `/ __/
#  / / / /_/ / / / / / / /__/ /_/ / /_
# /_/  \____/_/ /_/ /_/\___/\__,_/\__/

# image args
ARG JENKINS_USER=jenkins
ARG JENKINS_GROUP=jenkins

# software versions
ENV \
  JENKINS_VERSION=2.107.3 \
  SU_EXEC_VERSION=0.2-r0 \
  TTF_DEJAVU_VERSION=2.37-r0

ENV \
  JENKINS_USER="${JENKINS_USER}" \
  JENKINS_GROUP="${JENKINS_GROUP}" \
  JENKINS_HOME=/var/jenkins_home \
  JENKINS_SLAVE_AGENT_PORT=50000 \
  JENKINS_SHA=fc2d2eac8d3a04ffe6b4dc14eac52b2412f6c212

# explicitly set user/group IDs
RUN addgroup -S "${JENKINS_GROUP}" -g 9999 && adduser -S -G "${JENKINS_GROUP}" -u 9999 "${JENKINS_USER}"

RUN \
  set -ex; \
  apk add --no-cache \
    su-exec="${SU_EXEC_VERSION}" \
    ttf-dejavu="${TTF_DEJAVU_VERSION}"

RUN \
  set -ex; \
  mkdir -p /usr/share/jenkins && \
  if ! wget -qO /usr/share/jenkins/jenkins.war https://repo.jenkins-ci.org/public/org/jenkins-ci/main/jenkins-war/"${JENKINS_VERSION}"/jenkins-war-"${JENKINS_VERSION}".war && then \
    echo >&2 "Error: Failed to download Jenkins binary" && \
    exit 1 && \
  fi && \
  echo "${JENKINS_SHA} */usr/share/jenkins/jenkins.war" | sha1sum -c - && \
  chown -R "${JENKINS_USER}":"${JENKINS_GROUP}" /usr/share/jenkins && \
  mkdir -p "${JENKINS_HOME}" && \
  chown -R "${JENKINS_USER}":"${JENKINS_GROUP}" /var/jenkins_home

# add launch script
COPY docker-entrypoint.sh /

RUN \
  chmod 755 /docker-entrypoint.sh

# web interface
EXPOSE 8080
# slave agents
EXPOSE 50000

VOLUME ["${JENKINS_HOME}"]

ENTRYPOINT ["/docker-entrypoint.sh"]
