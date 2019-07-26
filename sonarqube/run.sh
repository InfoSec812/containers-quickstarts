#!/bin/bash

set -x
set -e

## If the mounted data volume is empty, populate it from the default data
cp -a /opt/sonarqube/data-init/* /opt/sonarqube/data/

## Link the plugins directory from the mounted volume
rm -rf /opt/sonarqube/extensions/plugins
mkdir -p /opt/sonarqube/data/plugins
ln -s /opt/sonarqube/data/plugins /opt/sonarqube/extensions/plugins

## If a properties file is mounted, load those properties into SQ
## Valid properties can be seen here: https://bit.ly/2LJWxWQ
export SONAR_EXTRA_PROPS=""
if [ -d "/opt/sonarqube/conf/properties" && -f "/opt/sonarqube/conf/properties/sonar.properties" ]; then
  for PROP in $(cat /opt/sonarqube/conf/properties/sonar.properties)
  export SONAR_EXTRA_PROPS="${SONAR_EXTRA_PROPS} -D${PROP}"
fi

## Install plugins from PLUGINS_LIST environment variable
/opt/sonarqube/bin/plugins.sh

if [ "${1:0:1}" != '-' ]; then
  exec "$@"
fi

java ${JAVA_OPTS} -jar lib/sonar-application-$SONAR_VERSION.jar \
    -Dsonar.web.javaAdditionalOpts="${SONARQUBE_WEB_JVM_OPTS} ${SONAR_EXTRA_PROPS} -Djava.security.egd=file:/dev/./urandom" \
    "$@"