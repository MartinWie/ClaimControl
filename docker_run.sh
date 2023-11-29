#!/bin/bash

# Check if ENVIRONMENT is set, if not, set it to "Dev"
if [ -z "$ENVIRONMENT" ]; then
    ENVIRONMENT="Dev"
    echo "ENVIRONMENT is not set, defaulting to 'Dev'"
fi

# Check for --local argument
if [ "$1" == "--local" ]; then
    # Use the local image
    IMAGE="claimcontrol"
    echo "Using local Docker image."
else
    # Login to AWS ECR if not running on AWS
    if [ -z "$ECS_CONTAINER_METADATA_URI" ]; then
        aws ecr get-login-password --region "$ECR_AWS_REGION" | docker login --username AWS --password-stdin "$ECR_CLAIMCONTROL_URL"
    fi
    # Use the ECR image
    IMAGE=""$ECR_CLAIMCONTROL_URL"/claimcontrol:latest"
    echo "Using AWS ECR Docker image."
fi

# Check if ECS_CONTAINER_METADATA_URI is set
if [ -n "$ECS_CONTAINER_METADATA_URI" ]; then
    echo "Running on AWS ECS/Fargate"
    docker run -e ENVIRONMENT=$ENVIRONMENT -p 8080:8080 "$IMAGE"
else
    echo "Running not in AWS"
    docker run -e AWS_ACCESS_KEY_ID="$AWS_ACCESS_KEY_ID_CUSTOM" \
                   -e AWS_SECRET_ACCESS_KEY="$AWS_SECRET_ACCESS_KEY_CUSTOM" \
                   -e ENVIRONMENT=$ENVIRONMENT -p 8080:8080 "$IMAGE"
fi
