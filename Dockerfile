FROM alpine:3.5

LABEL com.ragedunicorn.maintainer="Michael Wiesendanger <michael.wiesendanger@gmail.com>" \
  com.ragedunicorn.version="1.0"

#    ______                           __
#   /_  __/___  ____ ___  _________ _/ /_
#   / / / __ \/ __ `__ \/ ___/ __ `/ __/
#  / / / /_/ / / / / / / /__/ /_/ / /_
# /_/  \____/_/ /_/ /_/\___/\__,_/\__/

# software versions
ENV \
  JENKINS_VERSION=2.9 \
  SU_EXEC_VERSION=0.2-r0 \
  CURL=7.52.1-r3 \
  TTF_DEJAVU_VERSION=2.35-r0 \
  JAVA_VERSION=8.121.13-r0

ENV \
  JENKINS_HOME=/var/jenkins_home \
  JENKINS_SLAVE_AGENT_PORT=50000 \
  JENKINS_USER=jenkins \
  JENKINS_GROUP=jenkins \
  JENKINS_SHA=1fd02a942cca991577ee9727dd3d67470e45c031

ENV \
  JAVA_HOME=/usr/lib/jvm/java-1.8-openjdk/jre \
  PATH=$PATH:/usr/lib/jvm/java-1.8-openjdk/jre/bin:/usr/lib/jvm/java-1.8-openjdk/bin

# explicitly set user/group IDs
RUN addgroup -S "${JENKINS_GROUP}" -g 9999 && adduser -S -G "${JENKINS_GROUP}" -u 9999 "${JENKINS_USER}"

RUN \
  set -ex; \
  apk add --no-cache \
    su-exec="${SU_EXEC_VERSION}" \
    openjdk8="${JAVA_VERSION}" \
    ttf-dejavu="${TTF_DEJAVU_VERSION}" \
    curl="${CURL}"

RUN \
  set -ex; \
  mkdir -p /usr/share/jenkins; \
  curl -fSL https://repo.jenkins-ci.org/public/org/jenkins-ci/main/jenkins-war/"${JENKINS_VERSION}"/jenkins-war-"${JENKINS_VERSION}".war -o /usr/share/jenkins/jenkins.war; \
  echo "${JENKINS_SHA} */usr/share/jenkins/jenkins.war" | sha1sum -c -; \
  chown -R "${JENKINS_USER}":"${JENKINS_GROUP}" /usr/share/jenkins; \
  mkdir -p "${JENKINS_HOME}"; \
  chown -R "${JENKINS_USER}":"${JENKINS_GROUP}" /var/jenkins_home

# add launch script
COPY docker-entrypoint.sh /

RUN \
  chmod 755 /docker-entrypoint.sh

# web interface
EXPOSE 8080
# slave agents
EXPOSE 50000

VOLUME "${JENKINS_HOME}"

ENTRYPOINT ["/docker-entrypoint.sh"]
