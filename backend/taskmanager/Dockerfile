FROM eclipse-temurin:17-jdk-jammy AS build
WORKDIR /workspace

COPY .mvn/ .mvn/
COPY mvnw pom.xml ./
RUN chmod +x mvnw && ./mvnw dependency:go-offline -B

COPY src/ src/
RUN ./mvnw package -DskipTests -B

FROM eclipse-temurin:17-jre-jammy
WORKDIR /app

RUN useradd --system --create-home spring
COPY --from=build /workspace/target/*.jar app.jar

USER spring
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
