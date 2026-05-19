#!/bin/bash

echo "🚨 Incident Simulation Script"
echo "============================"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_incident() {
    echo -e "${RED}🚨 INCIDENT: $1${NC}"
}

print_fix() {
    echo -e "${GREEN}✅ FIX: $1${NC}"
}

print_layer() {
    echo -e "${BLUE}📍 LAYER: $1${NC}"
}

# Incident 1: Database Connection Failure
echo ""
print_incident "Database Connection Failure"
print_layer "L2 - External (Database)"

echo "Simulating database failure..."
docker compose stop db

echo "Testing backend health..."
if curl -s http://localhost:4000/api/health > /dev/null; then
    echo -e "${RED}❌ Backend should fail without database${NC}"
else
    echo -e "${GREEN}✅ Backend correctly fails without database${NC}"
fi

print_fix "Restart database service"
docker compose start db
sleep 5

if curl -s http://localhost:4000/api/health > /dev/null; then
    echo -e "${GREEN}✅ Database connection restored${NC}"
else
    echo -e "${RED}❌ Database still not working${NC}"
fi

# Incident 2: Environment Variable Missing
echo ""
print_incident "Environment Variable Missing"
print_layer "L4 - Frontend"

echo "Simulating missing VITE_API_URL..."
# Create a temporary .env without VITE_API_URL
echo "DATABASE_URL=postgres://appuser:secret@db:5432/appdb" > .env.temp
echo "POSTGRES_USER=appuser" >> .env.temp
echo "POSTGRES_PASSWORD=secret" >> .env.temp
echo "POSTGRES_DB=appdb" >> .env.temp
# VITE_API_URL is missing

mv .env .env.backup
mv .env.temp .env

docker compose restart frontend
sleep 3

echo "Testing frontend (should show API error)..."
# This would require browser automation to fully test
echo -e "${YELLOW}⚠️  Manual check required: Open http://localhost:3000${NC}"
echo -e "${YELLOW}   Should show 'Error: Backend returned an error'${NC}"

print_fix "Add VITE_API_URL to .env"
echo "VITE_API_URL=http://localhost:4000" >> .env
docker compose restart frontend
sleep 3

# Restore original .env
mv .env.backup .env
docker compose restart frontend
sleep 3

# Incident 3: CORS Error
echo ""
print_incident "CORS Policy Violation"
print_layer "L3 - Backend"

echo "Testing CORS headers..."
RESPONSE=$(curl -s -I -H "Origin: http://localhost:3000" http://localhost:4000/api/health)
if echo "$RESPONSE" | grep -q "Access-Control-Allow-Origin"; then
    echo -e "${GREEN}✅ CORS headers present${NC}"
else
    echo -e "${RED}❌ CORS headers missing${NC}"
    print_fix "Add CORS middleware to backend"
fi

# Incident 4: Docker Build Failure
echo ""
print_incident "Docker Build Failure"
print_layer "L1 - Infrastructure"

echo "Testing Docker build..."
if docker compose build --quiet; then
    echo -e "${GREEN}✅ Docker build successful${NC}"
else
    echo -e "${RED}❌ Docker build failed${NC}"
    print_fix "Check Dockerfile syntax and dependencies"
fi

# Incident 5: CI/CD Pipeline Failure
echo ""
print_incident "CI/CD Pipeline Failure"
print_layer "L1 - Infrastructure"

echo "Simulating CI failure (missing test)..."
# This would require GitHub Actions simulation
echo -e "${YELLOW}⚠️  Manual check required: Push to GitHub${NC}"
echo -e "${YELLOW}   Check Actions tab for pipeline status${NC}"

print_fix "Ensure all tests pass before pushing"

echo ""
echo "🎯 Incident Simulation Complete"
echo ""
echo "📋 Summary of Simulated Incidents:"
echo "1. Database connection failure"
echo "2. Missing environment variables"
echo "3. CORS policy violation"
echo "4. Docker build failure"
echo "5. CI/CD pipeline issues"
echo ""
echo "📖 See incidents.md for detailed reports"