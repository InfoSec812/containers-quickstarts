FROM registry.access.redhat.com/openshift3/jenkins-agent-maven-35-rhel7
LABEL maintainer="Deven Phillips <deven.phillips@redhat.com>"

LABEL com.redhat.component="jenkins-slave-selenium-chrome-rhel7-docker" \
      name="openshift3/jenkins-slave-selenium-chrome-rhel7" \
      version="3.10" \
      architecture="x86_64" \
      release="1" \
      io.k8s.display-name="Jenkins Slave Selenium Chrome" \
      io.k8s.description="The jenkins agent to run Selenium with a headless Chrome browser." \
      io.openshift.tags="openshift,jenkins,slave,selenium,chrome"

USER root
ADD https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm google-chrome-stable_current_x86_64.rpm

ENV INSTALL_PKGS "xorg-x11-server-Xvfb unzip"

RUN yum install -y --setopt=tsflags=nodocs \
      --disablerepo=* \
      --enablerepo=rhel-7-server-rpms \
      --enablerepo=rhel-server-rhscl-7-rpms \
      --enablerepo=rhel-7-server-optional-rpms \
      $INSTALL_PKGS && \
    yum -y localinstall \
      --disablerepo=* \
      --enablerepo=rhel-7-server-rpms \
      --enablerepo=rhel-7-server-optional-rpms \
      google-chrome-stable_current_x86_64.rpm && \
    rm google-chrome-stable_current_x86_64.rpm && \
    rpm -V $INSTALL_PKGS google-chrome-stable && \
    yum clean all -y && \
    rm -rf /var/cache/yum

## Install WebDriver executable
RUN curl -o chromedriver.zip -L https://chromedriver.storage.googleapis.com/2.43/chromedriver_linux64.zip && \
    unzip chromedriver.zip && \
    rm -f chromedriver.zip && \
    mv chromedriver /usr/local/bin/chromedriver

USER 1001
