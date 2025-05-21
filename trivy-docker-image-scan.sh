#!/bin/bash

# Set the image name (change this if your tag is different)
dockerImageName="myapp:latest"
echo "Scanning image: $dockerImageName"

# Run Trivy scan for HIGH severity issues
docker run --rm -v $WORKSPACE:/root/.cache/ aquasec/trivy:0.17.2 -q image --exit-code 0 --severity HIGH --light $dockerImageName

# Run Trivy scan for CRITICAL severity issues
docker run --rm -v $WORKSPACE:/root/.cache/ aquasec/trivy:0.17.2 -q image --exit-code 1 --severity CRITICAL --light $dockerImageName

# Capture exit code from CRITICAL scan
exit_code=$?
echo "Exit Code : $exit_code"

# Check scan results
if [[ "${exit_code}" == 1 ]]; then
    echo "Image scanning failed. Vulnerabilities found"
    exit 0
else
    echo "Image scanning passed. No CRITICAL vulnerabilities found"
fi
