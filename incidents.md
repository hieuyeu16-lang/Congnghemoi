# Incident Reports

## Incident 1: Database Connection Timeout

### Phenomenon
- Backend `/api/health` endpoint returns HTTP 500
- Error message: "Database unavailable"
- Frontend shows loading indefinitely
- Docker logs show: "Postgres idle client error"

### Layer
L2 - External (Database)

### Root Cause Analysis
- Database container not healthy when backend starts
- `depends_on` condition not properly configured
- PostgreSQL initialization takes longer than expected

### Timeline
- 14:00: Deploy initiated
- 14:01: Backend container starts
- 14:02: Backend tries to connect to DB (fails)
- 14:03: Health check fails
- 14:05: DB becomes healthy
- 14:06: Manual restart fixes issue

### Fix Applied
Updated `docker-compose.yml`:
```yaml
backend:
  depends_on:
    db:
      condition: service_healthy
```

### Prevention Measures
- Always use `condition: service_healthy` in docker-compose
- Add retry logic in database connection code
- Implement proper health checks before starting services

---

## Incident 2: Environment Variable Not Set

### Phenomenon
- Frontend loads but shows "Error: Backend returned an error"
- Browser console: "Failed to fetch"
- Backend logs clean, no errors

### Layer
L4 - Frontend

### Root Cause Analysis
- `VITE_API_URL` not set in frontend environment
- `.env` file missing or not copied
- Hardcoded fallback URL removed during build

### Timeline
- 15:00: Code deployed
- 15:01: Frontend build successful
- 15:02: User reports API calls failing
- 15:05: Discovered missing VITE_API_URL
- 15:06: Fixed by setting environment variable

### Fix Applied
- Ensured `.env` file exists with `VITE_API_URL=http://localhost:4000`
- Added validation in CI to check required env vars

### Prevention Measures
- Include `.env.example` in repository
- Add CI checks for required environment variables
- Document environment setup in README

---

## Incident 3: CORS Policy Violation

### Phenomenon
- Browser console shows: "Access to fetch at 'http://localhost:4000' from origin 'http://localhost:3000' has been blocked by CORS policy"
- API calls fail with network error
- Backend receives requests but responses blocked

### Layer
L3 - Backend

### Root Cause Analysis
- Express app missing CORS middleware
- Frontend and backend on different ports (3000 vs 4000)
- No CORS headers configured in production

### Timeline
- 16:00: Development environment working
- 16:30: Deployed to staging
- 16:31: CORS errors appear
- 16:45: Identified missing CORS configuration
- 16:50: Added CORS middleware

### Fix Applied
Added to `backend/src/app.js`:
```javascript
import cors from 'cors';
app.use(cors());
```

Updated `backend/package.json`:
```json
"dependencies": {
  "cors": "^2.8.5"
}
```

### Prevention Measures
- Always configure CORS in development and production
- Test cross-origin requests during development
- Include CORS in security checklist

---

## Incident 4: Docker Build Failure (Bonus)

### Phenomenon
- `docker compose build` fails
- Error: "npm install failed"
- Build stops at dependency installation

### Layer
L1 - Infrastructure

### Root Cause Analysis
- Node.js version mismatch between local and Docker
- Package-lock.json generated with different Node version
- Missing .dockerignore causing large context

### Timeline
- 17:00: Attempted Docker build
- 17:01: npm install fails
- 17:10: Identified Node version issue
- 17:15: Updated Dockerfile to match local Node version

### Fix Applied
Updated `backend/Dockerfile`:
```dockerfile
FROM node:18-alpine AS base
```

### Prevention Measures
- Keep Node versions consistent across environments
- Use .dockerignore to exclude unnecessary files
- Test Docker builds locally before pushing

---

## Summary

### Common Patterns
1. **Environment Configuration**: Most issues related to missing or incorrect env vars
2. **Service Dependencies**: Database health checks critical for startup order
3. **Cross-Origin Issues**: CORS configuration often overlooked
4. **Build Consistency**: Docker builds can fail due to version mismatches

### Lessons Learned
- Always validate environment variables in CI/CD
- Use proper health checks and dependency management
- Test cross-origin scenarios early
- Keep infrastructure configurations version-controlled

### Tools Used for Debugging
- Docker logs: `docker compose logs -f [service]`
- Browser DevTools Network tab
- Postman for API testing
- Environment variable validation scripts