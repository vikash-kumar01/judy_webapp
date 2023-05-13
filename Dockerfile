# Stage 1: Build the application using Maven
FROM maven:3.6.3-jdk-11 AS build
WORKDIR /app
COPY . .
RUN mvn clean package

# Stage 2: Run the application using OpenJDK
FROM openjdk:11.0
WORKDIR /app
COPY --from=build /app/target/Uber.jar /app/
CMD ["java", "-jar", "/app/Uber.jar"]



