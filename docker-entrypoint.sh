#!/bin/sh
# @author Michael Wiesendanger <michael.wiesendanger@gmail.com>
# @description launch script for jenkins

# abort when trying to use unset variable
set -o nounset

exec su-exec "${JENKINS_USER}" java -Djava.awt.headless=true -jar /usr/share/jenkins/jenkins.war
