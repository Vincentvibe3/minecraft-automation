#Download fabric server
FROM docker.io/alpine:latest as fabric_download
ARG mc_version=NONE
ARG fabric_version=NONE
ARG fabric_installer_version=NONE
RUN apk add --no-cache curl
RUN curl -Jf https://meta.fabricmc.net/v2/versions/loader/${mc_version}/${fabric_version}/${fabric_installer_version}/server/jar -o /server.jar

# Create a custom Java runtime
FROM docker.io/eclipse-temurin:17 as jre-build
RUN $JAVA_HOME/bin/jlink \
         --add-modules ALL-MODULE-PATH \
         --strip-debug \
         --no-man-pages \
         --no-header-files \
         --compress=2 \
         --output /javaruntime

#Create minecraft files
FROM docker.io/eclipse-temurin:17 as server_files_setup
WORKDIR /home/server/data
COPY --from=fabric_download /server.jar ../server.jar
RUN java -Xmx2G -jar ../server.jar nogui

# Setup Image
FROM docker.io/ubuntu:latest
# FROM docker.io/eclipse-temurin:17
ENV JAVA_HOME=/opt/java/openjdk
ENV PATH "${JAVA_HOME}/bin:/home/server:${PATH}"
# ENV PATH "/home/server:${PATH}"
WORKDIR /home/server/data
COPY --from=jre-build /javaruntime $JAVA_HOME
COPY --from=fabric_download /server.jar ../server.jar
COPY --from=server_files_setup /home/server/data .
RUN cp -r ./versions ../versions
RUN cp -r ./libraries ../libraries
COPY /start.sh ../start.sh
RUN chmod +x ../start.sh

# run server
ENV eula=""
ENV seed=""
ENV rcon=""
ENV rconpwd=""
ENV gamemode=""
ENV difficulty=""
ENV whitelist=""
EXPOSE 25565
EXPOSE 25575
ENTRYPOINT [ "../start.sh" ]