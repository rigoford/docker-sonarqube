FROM rigoford/alpine-java-newrelic:3.33.0.1

MAINTAINER Martin Ford <ford.j.martin@gmail.com>

ARG SONAR_USER=sonar
ARG SONAR_VERSION=6.2
ARG SONARQUBE_HOME=/opt/sonarqube
ARG SONARQUBE_DATA=$SONARQUBE_HOME/data
ARG SONARQUBE_EXTENSIONS=$SONARQUBE_HOME/extensions
ARG SONARQUBE_PLUGINS=$SONARQUBE_EXTENSIONS/plugins

ARG SONAR_CHECKSTYLE_PLUGIN=sonar-checkstyle-plugin
ARG SONAR_CHECKSTYLE_PLUGIN_VERSION=2.4
ARG SONAR_DEPENDENCY_CHECK_PLUGIN=sonar-dependency-check-plugin
ARG SONAR_DEPENDENCY_CHECK_PLUGIN_VERSION=1.0.2
ARG SONAR_FINDBUGS_PLUGIN=sonar-findbugs-plugin
ARG SONAR_FINDBUGS_PLUGIN_VERSION=3.4.3
ARG SONAR_GIT_PLUGIN=sonar-scm-git-plugin
ARG SONAR_GIT_PLUGIN_VERSION=1.2
ARG SONAR_GROOVY_PLUGIN=sonar-groovy-plugin
ARG SONAR_GROOVY_PLUGIN_PATH_VERSION=1.4-RC1
ARG SONAR_GROOVY_PLUGIN_VERSION=1.4-build514
ARG SONAR_JAVA_PLUGIN=sonar-java-plugin
ARG SONAR_JAVA_PLUGIN_VERSION=4.2.1.6971
ARG SONAR_JAVA_RULES=sonar-java-rules
ARG SONAR_JAVA_RULES_VERSION=0.3.0
ARG SONAR_JAVASCRIPT_PLUGIN=sonar-javascript-plugin
ARG SONAR_JAVASCRIPT_PLUGIN_VERSION=2.18.0.3454
ARG SONAR_LDAP_PLUGIN=sonar-ldap-plugin
ARG SONAR_LDAP_PLUGIN_VERSION=2.1.0.507
ARG SONAR_PMD_PLUGIN=sonar-pmd-plugin
ARG SONAR_PMD_PLUGIN_VERSION=2.6
ARG SONAR_XML_PLUGIN=sonar-xml-plugin
ARG SONAR_XML_PLUGIN_VERSION=1.4.1

ENV SONAR_VERSION=$SONAR_VERSION \
    SONARQUBE_HOME=$SONARQUBE_HOME \
    SONARQUBE_JDBC_USERNAME=sonar \
    SONARQUBE_JDBC_PASSWORD=sonar \
    SONARQUBE_JDBC_URL=

RUN apk --no-cache add curl unzip && \
    mkdir -p /tmp && \
    curl -o /tmp/sonarqube.zip -fSL \
      https://sonarsource.bintray.com/Distribution/sonarqube/sonarqube-$SONAR_VERSION.zip && \
    unzip /tmp/sonarqube.zip -d /opt && \
    mv /opt/sonarqube-$SONAR_VERSION $SONARQUBE_HOME && \
    rm /tmp/sonarqube.zip && \
    curl -o $SONARQUBE_PLUGINS/$SONAR_CHECKSTYLE_PLUGIN-$SONAR_CHECKSTYLE_PLUGIN_VERSION.jar -fSL \
      https://sonarsource.bintray.com/Distribution/$SONAR_CHECKSTYLE_PLUGIN/$SONAR_CHECKSTYLE_PLUGIN-$SONAR_CHECKSTYLE_PLUGIN_VERSION.jar && \
    curl -o $SONARQUBE_PLUGINS/$SONAR_DEPENDENCY_CHECK_PLUGIN-$SONAR_DEPENDENCY_CHECK_PLUGIN_VERSION.jar -fSL \
      https://github.com/stevespringett/dependency-check-sonar-plugin/releases/download/sonar-dependency-check-$SONAR_DEPENDENCY_CHECK_PLUGIN_VERSION/$SONAR_DEPENDENCY_CHECK_PLUGIN-$SONAR_DEPENDENCY_CHECK_PLUGIN_VERSION.jar && \
    curl -o $SONARQUBE_PLUGINS/$SONAR_FINDBUGS_PLUGIN-$SONAR_FINDBUGS_PLUGIN_VERSION.jar -fSL \
      https://github.com/SonarQubeCommunity/sonar-findbugs/releases/download/$SONAR_FINDBUGS_PLUGIN_VERSION/$SONAR_FINDBUGS_PLUGIN-$SONAR_FINDBUGS_PLUGIN_VERSION.jar && \
    curl -o $SONARQUBE_PLUGINS/$SONAR_GIT_PLUGIN-$SONAR_GIT_PLUGIN_VERSION.jar -fSL \
      https://sonarsource.bintray.com/Distribution/$SONAR_GIT_PLUGIN/$SONAR_GIT_PLUGIN-$SONAR_GIT_PLUGIN_VERSION.jar && \
    curl -o $SONARQUBE_PLUGINS/$SONAR_GROOVY_PLUGIN-$SONAR_GROOVY_PLUGIN_VERSION.jar -fSL \
      https://github.com/SonarQubeCommunity/sonar-groovy/releases/download/$SONAR_GROOVY_PLUGIN_PATH_VERSION/$SONAR_GROOVY_PLUGIN-$SONAR_GROOVY_PLUGIN_VERSION.jar && \
    curl -o $SONARQUBE_PLUGINS/$SONAR_JAVA_PLUGIN-$SONAR_JAVA_PLUGIN_VERSION.jar -fSL \
      https://sonarsource.bintray.com/Distribution/$SONAR_JAVA_PLUGIN/$SONAR_JAVA_PLUGIN-$SONAR_JAVA_PLUGIN_VERSION.jar && \
    curl -o $SONARQUBE_PLUGINS/$SONAR_JAVA_RULES-$SONAR_JAVA_RULES_VERSION.jar -fSL \
      https://oss.sonatype.org/content/repositories/releases/com/github/rigoford/$SONAR_JAVA_RULES/$SONAR_JAVA_RULES_VERSION/$SONAR_JAVA_RULES-$SONAR_JAVA_RULES_VERSION.jar && \
    curl -o $SONARQUBE_PLUGINS/$SONAR_JAVASCRIPT_PLUGIN-$SONAR_JAVASCRIPT_PLUGIN_VERSION.jar -fSL \
      https://sonarsource.bintray.com/Distribution/$SONAR_JAVASCRIPT_PLUGIN/$SONAR_JAVASCRIPT_PLUGIN-$SONAR_JAVASCRIPT_PLUGIN_VERSION.jar && \
    curl -o $SONARQUBE_PLUGINS/$SONAR_LDAP_PLUGIN-$SONAR_LDAP_PLUGIN_VERSION.jar -fSL \
      https://sonarsource.bintray.com/Distribution/$SONAR_LDAP_PLUGIN/$SONAR_LDAP_PLUGIN-$SONAR_LDAP_PLUGIN_VERSION.jar && \
    curl -o $SONARQUBE_PLUGINS/$SONAR_PMD_PLUGIN-$SONAR_PMD_PLUGIN_VERSION.jar -fSL \
      https://github.com/SonarQubeCommunity/sonar-pmd/releases/download/$SONAR_PMD_PLUGIN_VERSION/$SONAR_PMD_PLUGIN-$SONAR_PMD_PLUGIN_VERSION.jar && \
    curl -o $SONARQUBE_PLUGINS/$SONAR_XML_PLUGIN-$SONAR_XML_PLUGIN_VERSION.jar -fSL \
      http://sonarsource.bintray.com/Distribution/$SONAR_XML_PLUGIN/$SONAR_XML_PLUGIN-$SONAR_XML_PLUGIN_VERSION.jar && \
    apk del curl unzip

COPY files/run.sh $SONARQUBE_HOME/bin

RUN addgroup $SONAR_USER && \
    adduser -h $SONARQUBE_HOME -s /bin/sh -D -G $SONAR_USER -H $SONAR_USER && \
    chown -R $SONAR_USER:$SONAR_USER $SONARQUBE_HOME

USER $SONAR_USER

EXPOSE 9000

VOLUME ["$SONARQUBE_DATA", "$SONARQUBE_EXTENSIONS"]

WORKDIR $SONARQUBE_HOME

ENTRYPOINT ["./bin/run.sh"]

