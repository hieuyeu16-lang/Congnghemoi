#!/bin/bash

echo "=== Demo Checklist Validation ==="

# Check if .env.example exists
if [ -f ".env.example" ]; then
    echo "✅ .env.example exists"
else
    echo "❌ .env.example missing"
fi

# Check if .env is not committed (should not exist in repo)
if [ -f ".env" ]; then
    echo "⚠️  .env exists (make sure it's not committed)"
else
    echo "✅ .env not in repository"
fi

# Check Docker files
if [ -f "docker-compose.yml" ]; then
    echo "✅ docker-compose.yml exists"
else
    echo "❌ docker-compose.yml missing"
fi

if [ -f "backend/Dockerfile" ]; then
    echo "✅ backend/Dockerfile exists"
else
    echo "❌ backend/Dockerfile missing"
fi

if [ -f "frontend/Dockerfile" ]; then
    echo "✅ frontend/Dockerfile exists"
else
    echo "❌ frontend/Dockerfile missing"
fi

# Check CI/CD
if [ -f ".github/workflows/ci.yml" ]; then
    echo "✅ GitHub Actions workflow exists"
else
    echo "❌ GitHub Actions workflow missing"
fi

# Check API endpoint
echo "🔍 Checking backend API..."
if curl -s http://localhost:4000/api/health > /dev/null; then
    echo "✅ Backend /api/health accessible"
else
    echo "❌ Backend /api/health not accessible"
fi

# Check frontend
echo "🔍 Checking frontend..."
if curl -s http://localhost:3000 > /dev/null; then
    echo "✅ Frontend accessible"
else
    echo "❌ Frontend not accessible"
fi

# Check Docker containers
echo "🔍 Checking Docker containers..."
if docker compose ps | grep -q "Up"; then
    echo "✅ Docker containers running"
else
    echo "❌ Docker containers not running"
fi

echo ""
echo "=== Manual Checks Required ==="
echo "- Open http://localhost:3000 and check for console errors"
echo "- Test API with Postman using backend/postman_collection.json"
echo "- Push to GitHub and verify CI/CD pipeline"
echo "- Check docker compose logs for any errors"