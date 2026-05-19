# Task Management Demo

## Architecture
- Frontend: React + Vite
- Backend: Node.js + Express
- Database: PostgreSQL
- Containerization: Docker + docker-compose
- CI/CD: GitHub Actions

## Features
- `/api/health` endpoint
- `/api/tasks` endpoint returns sample task data
- Frontend renders danh sách công việc và trạng thái hoàn thành
- Docker multi-stage frontend build
- `docker compose up -d` runs frontend, backend, database

## Quick Start

### Option 1: Docker Demo (Recommended)
```bash
# Full Docker demo with database
./demo.sh

# Or using npm scripts
npm run demo
```

### Option 2: Node.js Demo (No Docker Required)
```powershell
# First, allow script execution (run in PowerShell as Administrator)
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# Then run the demo
.\demo.ps1
```

**Note:** If you get execution policy errors, run PowerShell as Administrator and execute:
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### Option 3: Manual Setup
1. Copy `.env.example` to `.env`
2. Start backend: `cd backend && npm install && npm start`
3. Start frontend: `cd frontend && npm install && npm run dev`
4. Open http://localhost:5173

## Available Scripts

```bash
# Demo scripts
./demo.sh              # Full Docker demo
./demo-node.sh         # Node.js only demo (Linux/WSL)
.\demo.ps1            # PowerShell demo (Windows)

# Testing & validation
./test-ci.sh          # Local CI/CD pipeline test
./simulate-incidents.sh # Incident simulation
./check-demo.sh       # Quick validation checklist

# Docker management
npm start             # docker compose up -d
npm run build         # docker compose build
npm run logs          # docker compose logs -f
npm stop              # docker compose down
npm run clean         # docker compose down -v
```

## CI/CD
- GitHub Actions pipeline installs dependencies
- Runs lint, test, build for backend and frontend
- Triggers on `push` and `pull_request`

## Docker
- `docker compose up -d`
- `docker compose logs -f backend`
- `docker compose ps`

## Notes
- Do not commit `.env`
- Keep config values in `.env.example`
- Frontend uses `VITE_API_URL` only

## Demo Steps

### 1. Docker Demo
```bash
# Build images
docker compose build

# Run containers
docker compose up -d

# Check running containers
docker compose ps

# View backend logs
docker compose logs -f backend

# View frontend logs
docker compose logs -f frontend

# Stop containers
docker compose down
```

### 2. API Testing with Postman
- Import collection: `backend/postman_collection.json` (create if needed)
- Test endpoints:
  - GET `http://localhost:4000/api/health`
  - GET `http://localhost:4000/api/test`

### 3. CI/CD Demo
- Push to GitHub
- Check Actions tab for pipeline execution
- Verify lint, test, build steps pass

## Incident Reports (Sample)

### Incident 1: Database Connection Failure
**Phenomenon:** Backend `/api/health` returns 500 error
**Layer:** L2 - External (Database)
**Root Cause:** DATABASE_URL environment variable not set
**Fix:** Copy `.env.example` to `.env` and set correct DATABASE_URL
**Prevention:** Always check `.env` before deployment

### Incident 2: Frontend API Call Failure
**Phenomenon:** Frontend shows "Error: Backend returned an error"
**Layer:** L4 - Frontend
**Root Cause:** VITE_API_URL points to wrong backend URL
**Fix:** Update VITE_API_URL in `.env` to match backend port
**Prevention:** Use environment variables, never hardcode URLs

### Incident 3: CORS Error
**Phenomenon:** Browser console shows CORS error
**Layer:** L3 - Backend
**Root Cause:** Missing CORS headers in backend
**Fix:** Add CORS middleware to Express app
**Prevention:** Configure CORS properly in production

## Deployment Options

### Option 1: Render (Free)
1. Create a Render account and connect your GitHub repository.
2. Create a new Web Service for the backend:
   - Environment: Docker
   - Dockerfile path: `backend/Dockerfile`
   - Branch: `main`
   - Set environment variables:
     - `PORT` = `4000`
     - `DATABASE_URL` = your production database URL
3. Create a new Static Site for the frontend:
   - Root directory: `frontend`
   - Build command: `npm install && npm run build`
   - Publish directory: `dist`
   - Set environment variable:
     - `VITE_API_URL` = your backend public URL, for example `https://task-booking-backend.onrender.com`
4. Use `render.yaml` in the repo to keep both services configuration versioned.
5. Add `RENDER_API_KEY` as a GitHub secret in this repository if you want automatic deploys from the Render workflow.
6. Push to `main` to trigger Render deploy and GitHub CI.

### GitHub Actions deploy (optional)
- A second workflow file is available at `.github/workflows/render-deploy.yml`
- It deploys on `push` to `main` or on manual dispatch
- Requires secret: `RENDER_API_KEY`

### Option 2: VPS/WSL
1. Setup an Ubuntu server or WSL environment.
2. Install Docker and Docker Compose.
3. Clone this repository.
4. Copy `.env.example` to `.env` and set production values.
5. Run `docker compose up -d`.

### Option 3: Vercel
1. Connect the GitHub repo to Vercel.
2. Deploy the frontend as a static site.
3. Deploy the backend separately as a Render web service or platform that supports Node.js.
4. Update `VITE_API_URL` to the deployed backend endpoint.

## Checklist for Demo
- [ ] Frontend loads at http://localhost:3000
- [ ] No console errors
- [ ] Backend /api/health returns 200
- [ ] API returns data (check /api/test)
- [ ] Docker containers running
- [ ] Logs accessible via docker compose logs
- [ ] CI pipeline passes on push
- [ ] .env.example exists, .env not committed
- [ ] Can redeploy after changes
