FROM ubuntu:18.04

ADD . apache-ofbiz 

WORKDIR apache-ofbiz

# Install OpenJDK-8
RUN apt-get update && \
apt-get install -y openjdk-8-jdk && \
apt-get install -y ant gradle && \
apt-get clean;

# Fix certificate issues
RUN apt-get update && \
apt-get install ca-certificates-java && \
apt-get clean && \
update-ca-certificates -f;

# Setup JAVA_HOME path
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64/
ENV JAVA_OPTS -Xmx3G
RUN export JAVA_HOME

# Granting permission to gradlew 
RUN chmod +x ./gradlew

#for passing in entity engine config
VOLUME apache-ofbiz/framework/entity/config/

#for Derby Database
VOLUME apache-ofbiz/runtime/data

#Expose port 
EXPOSE 8443

# Run ofbiz
ENTRYPOINT ./gradlew build loadAll ofbiz