FROM docker.io/sonarqube:7.6-community

USER root
ADD sonar.properties /opt/sonarqube/conf/sonar.properties
ADD run.sh /opt/sonarqube/bin/run.sh
CMD /opt/sonarqube/bin/run.sh
RUN cp -a /opt/sonarqube/data /opt/sonarqube/data-init && \
	cp -a /opt/sonarqube/extensions /opt/sonarqube/extensions-init
ADD plugins.sh /opt/sonarqube/bin/plugins.sh
RUN chown root:root /opt/sonarqube -R; \
    chmod 6775 /opt/sonarqube -R; \
    chmod 6775 /opt/sonarqube/data -R; \
    chown root:root /opt/sonarqube/data -R
USER 1001
ENTRYPOINT ["/opt/sonarqube/bin/run.sh"]
