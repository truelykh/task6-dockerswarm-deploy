FROM maven:3.8-openjdk-11 AS build

ARG NEXUS_USER
ARG NEXUS_PASS

WORKDIR /app

COPY settings.xml .
COPY pom.xml .


COPY src ./src
RUN mvn -s settings.xml clean package -DskipTests \
    -Drepo.username=${NEXUS_USER} \
    -Drepo.password=${NEXUS_PASS}

FROM tomcat:9.0-jdk11-temurin

LABEL maintainer="rakesh" \
    app="task6-dockerswarm-app" \
    version="1.0.0"

ENV SWARM_SERVICE_NAME=task6_app \
    NEXUS_MAVEN_REPO_URL=http://nexus:8081/repository/maven-swarm/ \
    NEXUS_DOCKER_REPO_URL=http://nexus:8081/repository/dockerswarm/ \
    CATALINA_OPTS="-Xms256m -Xmx512m -XX:+UseG1GC"

RUN rm -rf /usr/local/tomcat/webapps/*
COPY --from=build /app/target/task6-app.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080
CMD ["catalina.sh", "run"]
