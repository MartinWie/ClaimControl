#!/bin/bash

echo "Test output"
echo "$ECR_AWS_REGION"
echo "Test output2"

# Check if ECS_CONTAINER_METADATA_URI is set
if [ -n "$ECS_CONTAINER_METADATA_URI" ]; then
    echo "Running on AWS ECS/Fargate"
else
    echo "Running on non AWS machine, checking for aws credentials..."
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

# Check for --local argument
if [ "$1" == "--local" ]; then
    echo "Local mode enabled, no upload to ECR"
else
  # Login AWS ECR
      aws ecr get-login-password --region "$ECR_AWS_REGION" | docker login --username AWS --password-stdin "$ECR_CLAIMCONTROL_URL"

      # Tag image
      docker tag claimcontrol:latest "$ECR_CLAIMCONTROL_URL"/claimcontrol:latest

      # Push image
      docker push "$ECR_CLAIMCONTROL_URL"/claimcontrol:latest
fi
