# Stage 1: Build
FROM maven:3.9.6-eclipse-temurin-21-alpine AS build
WORKDIR /app

# Copy toàn bộ thư mục dự án vào
COPY ./Spring_ALShop ./Spring_ALShop
WORKDIR /app/Spring_ALShop

# Cấp quyền thực thi và dùng chính file mvnw của dự án để build
RUN mvn clean package -DskipTests

# Stage 2: Run
FROM eclipse-temurin:21-jdk-alpine
WORKDIR /app

# Copy file .jar từ thư mục target sang
COPY --from=build /app/Spring_ALShop/target/*.jar Spring_ALShop.jar

EXPOSE 8080
ENTRYPOINT [ "java", "-jar", "Spring_ALShop.jar" ]