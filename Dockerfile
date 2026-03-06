# ===== ETAPA 1: Build (compilação) =====
FROM gradle:8.7-jdk21-alpine AS build

WORKDIR /app
COPY build.gradle settings.gradle ./
COPY src ./src
RUN gradle bootJar --no-daemon -x test

# ===== ETAPA 2: Run (execução) =====
FROM eclipse-temurin:21-jre-alpine

WORKDIR /app
COPY --from=build /app/build/libs/*.jar app.jar

RUN addgroup -S easypet && adduser -S easypet -G easypet
USER easypet

EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]