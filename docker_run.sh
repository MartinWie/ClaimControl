#!/bin/bash

# Function to check AWS credentials
check_aws_credentials() {
    # Try to use AWS CLI to get caller identity, redirecting errors
    if aws sts get-caller-identity > /dev/null 2>&1; then
        echo "AWS credentials are available."
        return 0
    else
        echo "AWS credentials are not available."
        return 1
    fi
}

# Check if ENVIRONMENT is set, if not, set it to "Dev"
if [ -z "$ENVIRONMENT" ]; then
    ENVIRONMENT="Dev"
    echo "ENVIRONMENT is not set, defaulting to 'Dev'"
fi


# Check for AWS credentials
if ! check_aws_credentials; then
    # If credentials are not available, set them as part of the docker run command
    docker run -e AWS_ACCESS_KEY_ID="$AWS_ACCESS_KEY_ID_CUSTOM" \
               -e AWS_SECRET_ACCESS_KEY="$AWS_SECRET_ACCESS_KEY_CUSTOM" \
               -e ENVIRONMENT=$ENVIRONMENT -p 8080:8080 claimcontrol
else
    # If credentials are available, do not include them in the docker run command
    docker run -e ENVIRONMENT=$ENVIRONMENT -p 8080:8080 claimcontrol
fi
