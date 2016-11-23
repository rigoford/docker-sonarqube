FROM java:8-alpine

MAINTAINER Martin Ford <ford.j.martin@gmail.com>

ARG SONAR_USER=sonar
ARG SONAR_VERSION=6.1
ARG SONARQUBE_HOME=/opt/sonarqube
ARG SONARQUBE_DATA=$SONARQUBE_HOME/data
ARG SONARQUBE_EXTENSIONS=$SONARQUBE_HOME/extensions
ARG SONARQUBE_PLUGINS=$SONARQUBE_EXTENSIONS/plugins

ENV SONAR_VERSION=$SONAR_VERSION \
    SONARQUBE_HOME=$SONARQUBE_HOME \
    SONARQUBE_JDBC_USERNAME=sonar \
    SONARQUBE_JDBC_PASSWORD=sonar \
    SONARQUBE_JDBC_URL=

RUN apk add --no-cache curl unzip \
    && mkdir -p /tmp \
    && curl -o /tmp/sonarqube.zip -fSL \
         https://sonarsource.bintray.com/Distribution/sonarqube/sonarqube-$SONAR_VERSION.zip \
    && unzip /tmp/sonarqube.zip -d /opt \
    && mv /opt/sonarqube-$SONAR_VERSION $SONARQUBE_HOME \
    && rm /tmp/sonarqube.zip

ARG SONAR_DEPENDENCY_CHECK_PLUGIN_VERSION=1.0.2
ARG SONAR_GIT_PLUGIN_VERSION=1.2
ARG SONAR_JAVA_PLUGIN_VERSION=4.2.1.6971
ARG SONAR_JAVASCRIPT_PLUGIN_VERSION=2.18.0.3454
ARG SONAR_LDAP_PLUGIN_VERSION=2.1.0.507
ARG SONAR_XML_PLUGIN_VERSION=1.4.1

RUN curl -o $SONARQUBE_PLUGINS/sonar-dependency-check-plugin.jar -fSL \
      https://github.com/stevespringett/dependency-check-sonar-plugin/releases/download/sonar-dependency-check-$SONAR_DEPENDENCY_CHECK_PLUGIN_VERSION/sonar-dependency-check-plugin-$SONAR_DEPENDENCY_CHECK_PLUGIN_VERSION.jar \
    && curl -o $SONARQUBE_PLUGINS/sonar-git-plugin.jar -fSL \
         https://sonarsource.bintray.com/Distribution/sonar-scm-git-plugin/sonar-scm-git-plugin-$SONAR_GIT_PLUGIN_VERSION.jar \
    && curl -o $SONARQUBE_PLUGINS/sonar-java-plugin.jar -fSL \
         https://sonarsource.bintray.com/Distribution/sonar-java-plugin/sonar-java-plugin-$SONAR_JAVA_PLUGIN_VERSION.jar \
    && curl -o $SONARQUBE_PLUGINS/sonar-javascript-plugin.jar -fSL \
         https://sonarsource.bintray.com/Distribution/sonar-javascript-plugin/sonar-javascript-plugin-$SONAR_JAVASCRIPT_PLUGIN_VERSION.jar \
    && curl -o $SONARQUBE_PLUGINS/sonar-ldap-plugin.jar -fSL \
         https://sonarsource.bintray.com/Distribution/sonar-ldap-plugin/sonar-ldap-plugin-$SONAR_LDAP_PLUGIN_VERSION.jar \
    && curl -o $SONARQUBE_PLUGINS/sonar-xml-plugin.jar -fSL \
         http://sonarsource.bintray.com/Distribution/sonar-xml-plugin/sonar-xml-plugin-$SONAR_XML_PLUGIN_VERSION.jar

COPY files/run.sh $SONARQUBE_HOME/bin/

RUN addgroup $SONAR_USER \
    && adduser -h $SONARQUBE_HOME -s /bin/sh -D -G $SONAR_USER -H $SONAR_USER \
    && chown -R $SONAR_USER:$SONAR_USER $SONARQUBE_HOME

USER $SONAR_USER

EXPOSE 9000

VOLUME ["$SONARQUBE_DATA", "$SONARQUBE_EXTENSIONS"]

WORKDIR $SONARQUBE_HOME

ENTRYPOINT ["./bin/run.sh"]

