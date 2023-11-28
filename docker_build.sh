#!/bin/bash

# Check if ECS_CONTAINER_METADATA_URI is set
if [ -n "$ECS_CONTAINER_METADATA_URI" ]; then
    echo "Running on AWS ECS/Fargate"
else
    echo "Running locally"
    export AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID_CUSTOM}
    export AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY_CUSTOM}
fi

# Check if ENVIRONMENT is set, if not, set it to "Dev"
if [ -z "$ENVIRONMENT" ]; then
    ENVIRONMENT="Dev"
    echo "ENVIRONMENT is not set, defaulting to 'Dev'"
fi

# Build the Docker image
echo "Building Docker image..."
docker build --no-cache -t claimcontrol .
