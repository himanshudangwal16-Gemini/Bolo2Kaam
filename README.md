# KhataVani — Gemini Live Voice Copilot for Kirana Merchants

Real-time, code-switched (Hinglish / Tanglish / Marathi) voice operations agent powered by **Gemini Live API on Vertex AI**, **FastAPI**, **Firestore**, and a **React PWA**.

---

## 1. Online Deployment via GitHub → Google Cloud Run

You can deploy this repository online in **two ways** directly from GitHub:

### Option A: Cloud Run Native GitHub Continuous Deployment (No CLI / No Keys Required)
1. Push this `khatavani` folder to a new GitHub repository (`main` branch).
2. Open [Google Cloud Console → Cloud Run](https://console.cloud.google.com/run) and click **Create Service**.
3. Select **Continuously deploy from a repository (source or function)** → **Set up with Cloud Build**.
4. Connect your GitHub repo (`main` branch) and choose **Dockerfile** (or `cloudbuild.yaml`).
5. Under **Service settings**:
   - Port: `8080`
   - Authentication: **Allow unauthenticated invocations**
   - Min instances: `1` (prevents cold starts during your live demo)
   - Request timeout: `3600` seconds (for long-lived WebSocket voice sessions)
   - Session affinity: **Enabled**
6. Add Environment Variables:
   - `GCP_PROJECT` = `<your-gcp-project-id>`
   - `GCP_LOCATION` = `us-central1`
   - `USE_VERTEX_AI` = `true`
   - `USE_FIRESTORE` = `true`
   - `GEMINI_LIVE_MODEL` = `gemini-live-2.5-flash-native-audio`
7. Ensure **Vertex AI API** (`aiplatform.googleapis.com`) and **Firestore API** (`firestore.googleapis.com`) are enabled in your GCP project.

### Option B: GitHub Actions CI/CD (`.github/workflows/deploy-cloud-run.yml`)
1. Push this repo to GitHub (`main` branch).
2. In your GitHub repo → **Settings → Secrets and variables → Actions**, add:
   - `GCP_PROJECT_ID`: Your Google Cloud project ID
   - `GCP_SA_KEY`: JSON key of a Service Account with `Cloud Run Admin`, `Cloud Build Editor`, `Service Account User`, `Artifact Registry Writer`, and `Storage Admin` roles.
3. Every `git push` to `main` automatically runs `pytest` and deploys to Cloud Run.

### Option C: Google Cloud Shell (`deploy.sh`)
```bash
git clone https://github.com/<your-username>/<your-repo>.git
cd <your-repo>
chmod +x deploy.sh
./deploy.sh YOUR_GCP_PROJECT_ID us-central1
```

---

## 2. Local Development Quickstart

### Backend
```powershell
cd backend
python -m venv .venv
.\.venv\Scripts\Activate.ps1
pip install -r requirements.txt
# Optional for live Gemini audio (otherwise runs in Action-Path Simulation Mode):
# $env:GEMINI_API_KEY="your-key"
uvicorn app.main:app --reload --port 8000
```

### Frontend
```powershell
cd frontend
npm.cmd install
npm.cmd run dev
```
Open `http://localhost:5173`.
