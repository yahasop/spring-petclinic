FROM eclipse-temurin:17-jre-alpine

WORKDIR /app

COPY ./target/*.jar /app/petclinic.jar

EXPOSE 8080

#ENTRYPOINT ["java", "-jar", "petclinic.jar"]

ENTRYPOINT ["MYSQL_URL=jdbc:mysql://database-1.cprhvpbkjcin.us-east-1.rds.amazonaws.com", "SPRING_PROFILES_ACTIVE=mysql", "MYSQL_USER=petclinic", "MYSQL_PASS=petclinic", "java", "-jar", "petclinic.jar"]
