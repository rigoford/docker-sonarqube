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

ARG SONAR_CHECKSTYLE_PLUGIN=sonar-checkstyle-plugin
ARG SONAR_CHECKSTYLE_PLUGIN_VERSION=2.4
ARG SONAR_DEPENDENCY_CHECK_PLUGIN=sonar-dependency-check-plugin
ARG SONAR_DEPENDENCY_CHECK_PLUGIN_VERSION=1.0.2
ARG SONAR_FINDBUGS_PLUGIN=sonar-findbugs-plugin
ARG SONAR_FINDBUGS_PLUGIN_VERSION=3.4.3
ARG SONAR_GIT_PLUGIN=sonar-scm-git-plugin
ARG SONAR_GIT_PLUGIN_VERSION=1.2
ARG SONAR_JAVA_PLUGIN=sonar-java-plugin
ARG SONAR_JAVA_PLUGIN_VERSION=4.2.1.6971
ARG SONAR_JAVASCRIPT_PLUGIN=sonar-javascript-plugin
ARG SONAR_JAVASCRIPT_PLUGIN_VERSION=2.18.0.3454
ARG SONAR_LDAP_PLUGIN=sonar-ldap-plugin
ARG SONAR_LDAP_PLUGIN_VERSION=2.1.0.507
ARG SONAR_XML_PLUGIN=sonar-xml-plugin
ARG SONAR_XML_PLUGIN_VERSION=1.4.1

RUN curl -o $SONARQUBE_PLUGINS/$SONAR_CHECKSTYLE_PLUGIN-$SONAR_CHECKSTYLE_PLUGIN_VERSION.jar -fSL \
      https://sonarsource.bintray.com/Distribution/$SONAR_CHECKSTYLE_PLUGIN/$SONAR_CHECKSTYLE_PLUGIN-$SONAR_CHECKSTYLE_PLUGIN_VERSION.jar \
    && curl -o $SONARQUBE_PLUGINS/$SONAR_DEPENDENCY_CHECK_PLUGIN-$SONAR_DEPENDENCY_CHECK_PLUGIN_VERSION.jar -fSL \
         https://github.com/stevespringett/dependency-check-sonar-plugin/releases/download/sonar-dependency-check-$SONAR_DEPENDENCY_CHECK_PLUGIN_VERSION/$SONAR_DEPENDENCY_CHECK_PLUGIN-$SONAR_DEPENDENCY_CHECK_PLUGIN_VERSION.jar \
    && curl -o $SONARQUBE_PLUGINS/$SONAR_FINDBUGS_PLUGIN-$SONAR_FINDBUGS_PLUGIN_VERSION.jar -fSL \
         https://github.com/SonarQubeCommunity/sonar-findbugs/releases/download/$SONAR_FINDBUGS_PLUGIN_VERSION/$SONAR_FINDBUGS_PLUGIN-$SONAR_FINDBUGS_PLUGIN_VERSION.jar \
    && curl -o $SONARQUBE_PLUGINS/$SONAR_GIT_PLUGIN-$SONAR_GIT_PLUGIN_VERSION.jar -fSL \
         https://sonarsource.bintray.com/Distribution/$SONAR_GIT_PLUGIN/$SONAR_GIT_PLUGIN-$SONAR_GIT_PLUGIN_VERSION.jar \
    && curl -o $SONARQUBE_PLUGINS/$SONAR_JAVA_PLUGIN-$SONAR_JAVA_PLUGIN_VERSION.jar -fSL \
         https://sonarsource.bintray.com/Distribution/$SONAR_JAVA_PLUGIN/$SONAR_JAVA_PLUGIN-$SONAR_JAVA_PLUGIN_VERSION.jar \
    && curl -o $SONARQUBE_PLUGINS/$SONAR_JAVASCRIPT_PLUGIN-$SONAR_JAVASCRIPT_PLUGIN_VERSION.jar -fSL \
         https://sonarsource.bintray.com/Distribution/$SONAR_JAVASCRIPT_PLUGIN/$SONAR_JAVASCRIPT_PLUGIN-$SONAR_JAVASCRIPT_PLUGIN_VERSION.jar \
    && curl -o $SONARQUBE_PLUGINS/$SONAR_LDAP_PLUGIN-$SONAR_LDAP_PLUGIN_VERSION.jar -fSL \
         https://sonarsource.bintray.com/Distribution/$SONAR_LDAP_PLUGIN/$SONAR_LDAP_PLUGIN-$SONAR_LDAP_PLUGIN_VERSION.jar \
    && curl -o $SONARQUBE_PLUGINS/$SONAR_XML_PLUGIN-$SONAR_XML_PLUGIN_VERSION.jar -fSL \
         http://sonarsource.bintray.com/Distribution/$SONAR_XML_PLUGIN/$SONAR_XML_PLUGIN-$SONAR_XML_PLUGIN_VERSION.jar

RUN mkdir -p /tmp \
    && curl -o /tmp/newrelic-java.zip -fSL \
         https://download.newrelic.com/newrelic/java-agent/newrelic-agent/current/newrelic-java.zip \
    && unzip /tmp/newrelic-java.zip newrelic/newrelic.jar -d $SONARQUBE_HOME/lib \
    && rm /tmp/newrelic-java.zip

COPY files/run.sh $SONARQUBE_HOME/bin

RUN addgroup $SONAR_USER \
    && adduser -h $SONARQUBE_HOME -s /bin/sh -D -G $SONAR_USER -H $SONAR_USER \
    && chown -R $SONAR_USER:$SONAR_USER $SONARQUBE_HOME

USER $SONAR_USER

EXPOSE 9000

VOLUME ["$SONARQUBE_DATA", "$SONARQUBE_EXTENSIONS"]

WORKDIR $SONARQUBE_HOME

ENTRYPOINT ["./bin/run.sh"]

