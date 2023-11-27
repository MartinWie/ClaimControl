#!/bin/bash

# Check if ENVIRONMENT is set, if not, set it to "Dev"
if [ -z "$ENVIRONMENT" ]; then
    ENVIRONMENT="Dev"
    echo "ENVIRONMENT is not set, defaulting to 'Dev'"
fi

# Check if ECS_CONTAINER_METADATA_URI is set
if [ -n "$ECS_CONTAINER_METADATA_URI" ]; then
    echo "Running on AWS ECS/Fargate"
    docker run -e ENVIRONMENT=$ENVIRONMENT -p 8080:8080 claimcontrol
else
    echo "Running locally"
    docker run -e AWS_ACCESS_KEY_ID="$AWS_ACCESS_KEY_ID_CUSTOM" \
                   -e AWS_SECRET_ACCESS_KEY="$AWS_SECRET_ACCESS_KEY_CUSTOM" \
                   -e ENVIRONMENT=$ENVIRONMENT -p 8080:8080 claimcontrol
fi
