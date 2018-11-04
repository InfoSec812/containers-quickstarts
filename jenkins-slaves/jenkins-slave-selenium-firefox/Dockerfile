FROM registry.access.redhat.com/openshift3/jenkins-agent-maven-35-rhel7
LABEL maintainer="Deven Phillips <deven.phillips@redhat.com>"

LABEL com.redhat.component="jenkins-slave-selenium-firefox-rhel7-docker" \
      name="openshift3/jenkins-slave-selenium-firefox-rhel7" \
      version="3.10" \
      architecture="x86_64" \
      release="1" \
      io.k8s.display-name="Jenkins Slave Selenium Firefox" \
      io.k8s.description="The jenkins agent to run Selenium with a headless Firefox browser." \
      io.openshift.tags="openshift,jenkins,slave,selenium,firefox"

ENV INSTALL_PKGS "xorg-x11-server-Xvfb firefox"

RUN yum install -y --setopt=tsflags=nodocs \
      --disablerepo=* \
      --enablerepo=rhel-7-server-rpms \
      --enablerepo=rhel-server-rhscl-7-rpms \
      --enablerepo=rhel-7-server-optional-rpms \
      $INSTALL_PKGS && \
    yum clean all -y && \
    rm -rf /var/cache/yum

RUN curl -L -o geckodriver.tar.gz https://github.com/mozilla/geckodriver/releases/download/v0.23.0/geckodriver-v0.23.0-linux64.tar.gz && \
    tar -xzf geckodriver.tar.gz -C /usr/local/bin/ && \
    rm -f geckodriver.tar.gz

