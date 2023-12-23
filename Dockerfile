# Stage 1: Build using amazoncorretto
FROM amazoncorretto:21-alpine AS build

# Environment variables
ARG AWS_ACCESS_KEY_ID
ARG AWS_SECRET_ACCESS_KEY
ARG ENVIRONMENT
ENV AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
ENV AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
ENV ENVIRONMENT=$ENVIRONMENT

# Set ENVIRONMENT to "Dev" if not set
RUN if [ -z "$ENVIRONMENT" ]; then ENVIRONMENT="Dev"; fi


# Set the working directory in the build stage
WORKDIR /build

# Copy the project files into the container
COPY . .

# Install pip
RUN apk --no-cache add py-pip

# Install git
RUN apk --no-cache add git

# Get environmentvariables & build
RUN pip install git+https://github.com/MartinWie/AEnv.git
RUN aenv -c -r eu-west-1 -e "$ENVIRONMENT" -s ClaimControl "./gradlew build --info"


# Stage 2: Create the runtime image using
FROM amazoncorretto:21-alpine

# Set the working directory in the runtime container
WORKDIR /app

# Install pip
RUN apk --no-cache add py-pip

# Install git
RUN apk --no-cache add git

# Install aenv
RUN pip install git+https://github.com/MartinWie/AEnv.git

# Copy only the built jar file from the build stage
COPY --from=build /build/build/libs/de.mw.claimcontrol-all.jar /app/app.jar

# Run the application
CMD aenv -c -r eu-west-1 -e "$ENVIRONMENT" -s ClaimControl "java -jar /app/app.jar"

