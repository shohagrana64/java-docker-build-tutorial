# Stage 1 (to create a "build" image, ~140MB)
# FROM openjdk:8-jdk-alpine3.7 AS builder
FROM maven:3.8.2-jdk-8-openj9 AS builder
RUN java -version

COPY . /usr/src/myapp/
WORKDIR /usr/src/myapp/
#RUN rm -rf /var/cache/apk/* && \
#    rm -rf /tmp/*
#RUN apk update
#RUN apk --no-cache add maven && mvn --version
RUN mvn package

# Stage 2 (to create a downsized "container executable", ~87MB)
FROM openjdk:8-jre-alpine3.7
WORKDIR /root/
COPY --from=builder /usr/src/myapp/target/app.jar .

EXPOSE 8123
ENTRYPOINT ["java", "-jar", "./app.jar"]
