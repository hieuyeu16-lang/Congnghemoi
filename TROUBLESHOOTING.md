# Troubleshooting Guide

## Windows-Specific Issues

### PowerShell Execution Policy
**Error:** `cannot be loaded because running scripts is disabled`
**Solution:**
```powershell
# Check current policy
Get-ExecutionPolicy

# Set to allow local scripts
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# Or run with bypass
powershell -ExecutionPolicy Bypass -File .\demo.ps1
```

### Node.js Not Found
**Error:** `'node' is not recognized`
**Solution:**
1. Install Node.js from https://nodejs.org
2. Restart PowerShell/Command Prompt
3. Check: `node --version`

### npm Not Found
**Error:** `'npm' is not recognized`
**Solution:**
- npm comes with Node.js installation
- If missing, reinstall Node.js
- Check: `npm --version`

### Port Already in Use
**Error:** `listen EADDRINUSE: address already in use`
**Solution:**
```bash
# Find process using port
netstat -ano | findstr :4000

# Kill process (replace PID)
taskkill /PID <PID> /F

# Or use PowerShell
Get-NetTCPConnection -LocalPort 4000 | Select-Object OwningProcess
Stop-Process -Id <PID>
```

### Permission Denied (Scripts)
**Error:** `Permission denied` when running `.sh` files
**Solution:**
```bash
# Convert line endings
sed -i 's/\r$//' demo.sh

# Or use dos2unix if available
dos2unix demo.sh

# Make executable
chmod +x demo.sh
```

## Docker Issues

### Docker Desktop Not Running
**Error:** `Docker Desktop is unable to start`
**Solution:**
1. Start Docker Desktop application
2. Wait for Docker daemon to start
3. Check: `docker --version`

### Docker Compose Not Found
**Error:** `'docker-compose' is not recognized`
**Solution:**
- Use `docker compose` (newer syntax)
- Or install Docker Compose separately

### Build Failures
**Error:** `npm install failed` in Docker
**Solution:**
```bash
# Clear Docker cache
docker system prune -a

# Rebuild without cache
docker compose build --no-cache

# Check Dockerfile syntax
docker build --no-cache -f backend/Dockerfile backend
```

## Network Issues

### Cannot Connect to localhost
**Error:** `Connection refused`
**Solution:**
1. Check if service is running: `docker compose ps`
2. Check logs: `docker compose logs [service]`
3. Verify ports: `netstat -ano | findstr :4000`

### CORS Errors
**Error:** `CORS policy violation`
**Solution:**
1. Check VITE_API_URL in `.env`
2. Ensure backend has CORS middleware
3. Verify ports match between frontend and backend

## Environment Issues

### .env Not Loaded
**Error:** Environment variables not working
**Solution:**
1. Ensure `.env` exists in project root
2. Check syntax (no spaces around `=`)
3. Restart services after changing `.env`

### Database Connection Failed
**Error:** `Database unavailable`
**Solution:**
1. Check DATABASE_URL in `.env`
2. Ensure database container is healthy
3. Check logs: `docker compose logs db`

## Testing Issues

### Tests Fail
**Error:** `Tests failed`
**Solution:**
```bash
# Run with verbose output
cd backend && npm test -- --verbose
cd frontend && npm test -- --verbose

# Check test environment
cd backend && npm run lint
cd frontend && npm run lint
```

### Jest ESM Issues
**Error:** `Cannot use import statement outside module`
**Solution:**
- Ensure `jest.config.js` has ESM configuration
- Use `cross-env` for NODE_ENV
- Check Node.js version (18+ required)

## Git Issues

### Git Not Found
**Error:** `'git' is not recognized`
**Solution:**
1. Install Git from https://git-scm.com
2. Restart terminal
3. Check: `git --version`

### Push Rejected
**Error:** `Updates were rejected`
**Solution:**
```bash
# Pull latest changes
git pull origin main --rebase

# Or force push (careful!)
git push origin main --force-with-lease
```

## Performance Issues

### Slow Startup
**Problem:** Services take long to start
**Solution:**
1. Check system resources
2. Clear Docker cache: `docker system prune`
3. Use development mode instead of Docker

### High Memory Usage
**Problem:** Node.js processes use too much memory
**Solution:**
1. Monitor with Task Manager
2. Kill unnecessary processes
3. Use `--max-old-space-size` flag

## Getting Help

### Debug Steps
1. **Check logs:** `docker compose logs -f`
2. **Verify environment:** `cat .env`
3. **Test components individually:**
   ```bash
   cd backend && npm test
   cd frontend && npm run build
   ```
4. **Check system resources:** Task Manager
5. **Restart services:** `docker compose restart`

### Common Commands
```bash
# System info
node --version
npm --version
docker --version
git --version

# Process management
tasklist | findstr node
netstat -ano | findstr LISTENING

# Docker cleanup
docker system prune -a
docker volume prune
```

### Support Resources
- [Node.js Documentation](https://nodejs.org/docs)
- [Docker Documentation](https://docs.docker.com)
- [React Documentation](https://react.dev)
- [Express.js Guide](https://expressjs.com)