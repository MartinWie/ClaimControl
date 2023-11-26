# Stage 1: Build using amazoncorretto
FROM amazoncorretto:21-alpine AS build

# Set the working directory in the build stage
WORKDIR /build

# Copy the project files into the container
COPY . .

# Install pip
RUN apk --no-cache add py-pip

# Get environmentvariables & build
RUN pip install aenv
RUN aenv -e "$ENVIRONMENT" -s ClaimControl "./gradlew build"


# Stage 2: Create the runtime image using
FROM amazoncorretto:21-alpine

# Set the working directory in the runtime container
WORKDIR /app

# Install pip
RUN apk --no-cache add py-pip

# Install aenv
RUN pip install aenv

# Copy only the built jar file from the build stage
COPY --from=build /build/build/libs/de.mw.claimcontrol-all.jar /app/app.jar

# Run the application
CMD aenv -e "$ENVIRONMENT" -s ClaimControl "java -jar /app/app.jar"

