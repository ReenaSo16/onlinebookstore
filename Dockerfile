FROM openjdk:17-jdk-slim

WORKDIR /app

# Copy the WAR file
COPY target/*.war app.war

# Run using java -jar
CMD ["java", "-jar", "app.war"]
