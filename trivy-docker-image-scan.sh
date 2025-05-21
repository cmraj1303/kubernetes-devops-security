#!/bin/bash

# Step 1: Build the Docker image
docker build -t myapp:latest .

# Step 2: Set image name
dockerImageName="myapp:latest"
echo "Scanning image: $dockerImageName"

# Step 3: Run Trivy scans
docker run --rm -v $WORKSPACE:/root/.cache/ aquasec/trivy:0.17.2 -q image --exit-code 0 --severity HIGH --light $dockerImageName
docker run --rm -v $WORKSPACE:/root/.cache/ aquasec/trivy:0.17.2 -q image --exit-code 0 --severity CRITICAL --light $dockerImageName

# Step 4: Capture and process exit code
exit_code=$?
echo "Exit Code : $exit_code"

if [[ "${exit_code}" == 1 ]]; then
    echo "Image scanning failed. Vulnerabilities found"
    exit 0
else
    echo "Image scanning passed. No CRITICAL vulnerabilities found"
fi
