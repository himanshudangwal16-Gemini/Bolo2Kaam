#!/usr/bin/env bash
set -euo pipefail

PROJECT_ID="${1:-$(gcloud config get-value project)}"
REGION="${2:-us-central1}"
SERVICE_NAME="khatavani"

if [[ -z "$PROJECT_ID" ]]; then
  echo "Usage: ./deploy.sh <GCP_PROJECT_ID> [REGION]"
  exit 1
fi

echo "Enabling required Google Cloud APIs on $PROJECT_ID..."
gcloud services enable \
  run.googleapis.com \
  aiplatform.googleapis.com \
  firestore.googleapis.com \
  cloudbuild.googleapis.com \
  --project "$PROJECT_ID"

echo "Deploying $SERVICE_NAME to Cloud Run ($REGION)..."
gcloud run deploy "$SERVICE_NAME" \
  --source . \
  --project "$PROJECT_ID" \
  --region "$REGION" \
  --allow-unauthenticated \
  --session-affinity \
  --min-instances 1 \
  --timeout 3600 \
  --set-env-vars "GCP_PROJECT=${PROJECT_ID},GCP_LOCATION=${REGION},USE_VERTEX_AI=true,USE_FIRESTORE=true,GEMINI_LIVE_MODEL=gemini-live-2.5-flash-native-audio"

echo "Deployment complete!"
