# Base file inspired from https://github.com/dockcenter/velocity/blob/main/Dockerfile, which has been archived a while ago. 

# Skipped building first stage customJRE, just use the JRE image instead of the JDK
FROM eclipse-temurin:21-jre-alpine

# Set environment variables. 
ENV JAVA_MEMORY="512M"
ENV JAVA_FLAGS="-XX:+UseG1GC -XX:G1HeapRegionSize=4M -XX:+UnlockExperimentalVMOptions -XX:+ParallelRefProcEnabled -XX:+AlwaysPreTouch -XX:MaxInlineLevel=15" 

WORKDIR /data

RUN apk add --upgrade --no-cache openssl

VOLUME /data

EXPOSE 25577

# Copy the velocity-<VERSION_NUMBER>.jar file from the nearby /velocity directory THAT SHOULD EXIST. 
COPY velocity/velocity-*.jar /opt/velocity/velocity.jar

# Start the velocity file with the flags.
ENTRYPOINT java -Xms$JAVA_MEMORY -Xmx$JAVA_MEMORY $JAVA_FLAGS -jar /opt/velocity/velocity.jar
