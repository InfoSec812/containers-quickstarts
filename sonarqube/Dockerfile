FROM registry.access.redhat.com/redhat-openjdk-18/openjdk18-openshift
ARG SQ_VERSION="7.5"
ARG SQ_PLUGINS="pmd gitlab github ldap"

LABEL sonarqube.version="${SQ_VERSION}" \
			version="${SQ_VERSION}" \
			usage="https://github.com/redhat-cop/containers-quickstarts/blob/master/sonarqube/README.md" \
			distribution-scope="public" \
			name="SonarQube ${SQ_VERSION} for OpenShift" \
			architecture="x86_64" \
			release="${SQ_VERSION}"

ENV SONARQUBE_HOME=/opt/sonarqube \
    JDBC_USERNAME=sonar \
    JDBC_PASSWORD=sonar \
		SONAR_VERSION=${SQ_VERSION} \
    JDBC_URL=jdbc:h2:mem:sonar \
		FORCE_AUTHENTICATION=true \
		SONAR_AUTOCREATE_USERS=false \
		SONAR_LOG_LEVEL=INFO \
		PROXY_HOST= \
		PROXY_PORT= \
		PROXY_USER= \
		PROXY_PASSWORD= \
		LDAP_REALM= \
		LDAP_URL= \
		LDAP_BINDDN= \
		LDAP_BINDPASSWD= \
		LDAP_CONTEXTFACTORY= \
		LDAP_STARTTLS= \
		LDAP_AUTHENTICATION= \
		LDAP_USER_BASEDN= \
		LDAP_USER_REQUEST= \
		LDAP_USER_REAL_NAME_ATTR= \
		LDAP_USER_EMAIL_ATTR= \
		LDAP_GROUP_BASEDN= \
		LDAP_GROUP_REQUEST= \
		LDAP_GROUP_ID_ATTR=


# Http port
EXPOSE 9000

USER root

WORKDIR /opt

RUN gpg --keyserver ha.pool.sks-keyservers.net --recv-keys F1182E81C792928921DBCAB4CFCA4A29D26468DE \
    && curl -s -o sonarqube.zip -fSL https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-${SQ_VERSION}.zip \
    && curl -s -o sonarqube.zip.asc -fSL https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-${SQ_VERSION}.zip.asc \
    && gpg --batch --verify sonarqube.zip.asc sonarqube.zip \
    && unzip -qq sonarqube.zip \
    && mv sonarqube-${SQ_VERSION} sonarqube \
    && mv sonarqube/extensions sonarqube/extensions-init \
    && mv sonarqube/data sonarqube/data-init \
		&& rm -rf sonarqube/temp \
    && mkdir -p sonarqube/data-init/plugins \
    && mkdir -p sonarqube/extensions \
    && mkdir -p sonarqube/data \
    && rm sonarqube.zip*

ADD sonar.properties /opt/sonarqube/conf/sonar.properties
ADD run.sh /opt/sonarqube/bin/run.sh
ADD plugins.sh /opt/sonarqube/bin/plugins.sh
RUN chown -R root:root sonarqube \
    && chmod 1775 sonarqube -R
VOLUME "$SONARQUBE_HOME/data"

WORKDIR $SONARQUBE_HOME

ENTRYPOINT ["/opt/sonarqube/bin/run.sh"]
RUN /opt/sonarqube/bin/plugins.sh ${SQ_PLUGINS}

USER 1001