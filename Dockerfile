FROM openjdk:8-jdk  # Official, Debian-based (~400MB), reliable
# OR for smaller: FROM eclipse-temurin:8-jdk-alpine  # Eclipse Temurin, actively maintained Alpine (~150MB)
WORKDIR /app
COPY ./target/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
