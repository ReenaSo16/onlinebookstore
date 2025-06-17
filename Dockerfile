# Use official Tomcat image
FROM tomcat:9.0-jdk17-temurin

# Clean default apps (optional)
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy your WAR file into webapps
COPY target/onlinebookstore-0.0.1-SNAPSHOT.war /usr/local/tomcat/webapps/onlinebookstore.war

# Tomcat will auto-deploy the WAR on startup
EXPOSE 8080
