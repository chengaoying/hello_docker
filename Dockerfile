FROM tomcat:8-jre8
RUN rm -rf /usr/local/tomcat/webapps
ADD ./target/docker-ci-0.0.1.war /usr/local/tomcat/webapps/docker-ci-0.0.1.war