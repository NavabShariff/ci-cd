#!/bin/bash

set -e

ECR_REPO=$1
IMAGE_TAG=$2
REGION=$3

echo "Starting ECR Vulnerability Scan Check for: $ECR_REPO:$IMAGE_TAG ($REGION)"

aws ecr wait image-scan-complete \
    --region "$REGION" \
    --repository-name "$ECR_REPO" \
    --image-id imageTag="$IMAGE_TAG"

echo "Scan completed. Fetching findings..."

SCAN_FINDINGS=$(aws ecr describe-image-scan-findings \
    --region "$REGION" \
    --repository-name "$ECR_REPO" \
    --image-id imageTag="$IMAGE_TAG" | jq '.imageScanFindings.findingSeverityCounts')

CRITICAL=$(echo "$SCAN_FINDINGS" | jq '.CRITICAL // 0')


echo "=== Vulnerabilities Summary ==="
echo "CRITICAL: $CRITICAL"
echo "==============================="

if [[ "$CRITICAL" -gt 5 ]]; then
  echo "Image has $CRITICAL CRITICAL vulnerabilities! Failing pipeline."
  exit 1
fi

echo "Image passed vulnerability check."

