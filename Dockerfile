# Stage 1: Build using amazoncorretto
FROM amazoncorretto:21-alpine as build

# Set the working directory in the build stage
WORKDIR /build

# Copy the project files into the container
COPY . .

# Build the project
RUN ./gradlew build

# Stage 2: Create the runtime image using
FROM amazoncorretto:21-alpine

# Set the working directory in the runtime container
WORKDIR /app

# Copy only the built jar file from the build stage
COPY --from=build /build/build/libs/de.mw.claimcontrol-all.jar /app/app.jar

# Run the application
CMD ["java", "-jar", "/app/app.jar"]
