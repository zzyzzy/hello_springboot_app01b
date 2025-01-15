# 빌드 스테이지
FROM maven:3.9.9-amazoncorretto-17-alpine AS build

WORKDIR /app

# 종속성 다운로드
COPY /app/pom.xml .
RUN mvn dependency:go-offline -B

# 소스 복사 및 빌드
COPY /app/src ./src
RUN mvn package -DskipTests

# 실행 스테이지
FROM amazoncorretto:17-alpine

WORKDIR /app

COPY --from=build /app/target/*.jar app.jar

ENV JAVA_OPTS="-Xms512m -Xmx512m"
ENV SERVER_PORT=8080

EXPOSE 8080

ENTRYPOINT ["sh", "-c", "java ${JAVA_OPTS} -jar app.jar"]
