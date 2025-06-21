# Base file inspired from https://github.com/dockcenter/velocity/blob/main/Dockerfile, which has been archived a while ago. 

# Skipped building first stage customJRE, just use the JRE image instead of the JDK
FROM eclipse-temurin:21-jre-alpine

# Add app user
ARG APPLICATION_USER=velocity

# Set environment variables. 
ENV JAVA_MEMORY="512M"
ENV JAVA_FLAGS="-XX:+UseG1GC -XX:G1HeapRegionSize=4M -XX:+UnlockExperimentalVMOptions -XX:+ParallelRefProcEnabled -XX:+AlwaysPreTouch -XX:MaxInlineLevel=15" 

WORKDIR /data

RUN apk add --upgrade --no-cache openssl && \
    addgroup -S $APPLICATION_USER && \
    adduser -S $APPLICATION_USER -G velocity && \
    chown $APPLICATION_USER:$APPLICATION_USER /data

USER $APPLICATION_USER

VOLUME /data

EXPOSE 25577

COPY --chown=velocity velocity/velocity-*.jar /opt/velocity/velocity.jar

ENTRYPOINT java -Xms$JAVA_MEMORY -Xmx$JAVA_MEMORY $JAVA_FLAGS -jar /opt/velocity/velocity.jar