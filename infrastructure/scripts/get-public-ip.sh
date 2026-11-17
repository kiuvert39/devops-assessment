#!/usr/bin/env bash

set -Eeuo pipefail

# Usage: ./get-public-ip.sh <dev|prod>

log() {
    echo "[INFO] $1"
}

error() {
    echo "[ERROR] $1" >&2
    exit 1
}

# Validate environment argument
if [[ $# -ne 1 ]]; then
    error "Usage: $0 <dev|prod>"
fi

ENVIRONMENT="$1"

case "$ENVIRONMENT" in
    dev)
        PROJECT_ID="${GCP_PROJECT_ID_DEV:-}"
        ADDRESS_NAME="${LB_ADDRESS_NAME_DEV:-assessment-dev-lb-ip}"
        ;;
    prod)
        PROJECT_ID="${GCP_PROJECT_ID_PROD:-}"
        ADDRESS_NAME="${LB_ADDRESS_NAME_PROD:-assessment-prod-lb-ip}"
        ;;
    *)
        error "Invalid environment '$ENVIRONMENT'. Use dev or prod."
        ;;
esac

# Check required configuration
[[ -n "$PROJECT_ID" ]] || error "Project ID is not configured for $ENVIRONMENT."

# Check Google Cloud CLI
command -v gcloud >/dev/null 2>&1 || error "Google Cloud CLI (gcloud) is not installed."

# Check authentication
ACCOUNT=$(gcloud auth list \
    --filter="status:ACTIVE" \
    --format="value(account)") || error "Unable to check Google Cloud authentication."

[[ -n "$ACCOUNT" ]] || error "No active Google Cloud account. Run: gcloud auth login"

log "Environment: $ENVIRONMENT"
log "Project: $PROJECT_ID"
log "Load Balancer address: $ADDRESS_NAME"

# Retrieve the global Load Balancer IP
if ! PUBLIC_IP=$(gcloud compute addresses describe "$ADDRESS_NAME" \
    --global \
    --project="$PROJECT_ID" \
    --format="value(address)" 2>&1); then
    error "Unable to retrieve Load Balancer IP. Check project access and whether the address exists. Details: $PUBLIC_IP"
fi

[[ -n "$PUBLIC_IP" ]] || error "No IP address was returned."

log "Load Balancer public IP: $PUBLIC_IP"
