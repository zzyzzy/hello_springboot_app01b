# 빌드 스테이지
FROM maven:3.9.9-amazoncorretto-17-alpine AS build

WORKDIR /app

COPY /app/pom.xml .

COPY /app/mvnw .

COPY /app/src ./src

COPY /app/.mvn ./.mvn

RUN ./mvnw clean package -DskipTests

# 실행 스테이지
FROM amazoncorretto:17-alpine

WORKDIR /app

COPY --from=build /app/target/*.jar app.jar

ENV JAVA_OPTS="-Xms512m -Xmx512m"
ENV SERVER_PORT=8080

EXPOSE 8080

ENTRYPOINT ["sh", "-c", "java ${JAVA_OPTS} -jar app.jar"]
