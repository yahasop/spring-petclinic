FROM eclipse-temurin:21-jre-alpine

WORKDIR /app

COPY ./target/*.jar /app/petclinic.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "petclinic.jar"]
