param(
  [Parameter(Mandatory=$true)][string]$ProjectId,
  [string]$Region = "us-central1",
  [string]$ServiceName = "khatavani"
)

$ErrorActionPreference = "Stop"

Write-Host "Enabling Google Cloud APIs on $ProjectId..."
gcloud services enable run.googleapis.com aiplatform.googleapis.com firestore.googleapis.com cloudbuild.googleapis.com --project $ProjectId

Write-Host "Deploying $ServiceName to Cloud Run ($Region)..."
gcloud run deploy $ServiceName `
  --source . `
  --project $ProjectId `
  --region $Region `
  --allow-unauthenticated `
  --session-affinity `
  --min-instances 1 `
  --timeout 3600 `
  --set-env-vars "GCP_PROJECT=$ProjectId,GCP_LOCATION=$Region,USE_VERTEX_AI=true,USE_FIRESTORE=true,GEMINI_LIVE_MODEL=gemini-live-2.5-flash-native-audio"
