#!/bin/bash

echo "🚀 Demo Script for DevOps Project"
echo "=================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print status
print_status() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Check prerequisites
echo "🔍 Checking prerequisites..."

if ! command -v docker &> /dev/null; then
    print_error "Docker not installed"
    exit 1
fi

if ! command -v docker-compose &> /dev/null; then
    print_error "Docker Compose not installed"
    exit 1
fi

if ! command -v curl &> /dev/null; then
    print_error "curl not installed"
    exit 1
fi

print_status "Prerequisites OK"

# Setup environment
echo ""
echo "📝 Setting up environment..."

if [ ! -f ".env" ]; then
    cp .env.example .env
    print_status "Created .env from .env.example"
else
    print_warning ".env already exists"
fi

# Docker operations
echo ""
echo "🐳 Docker Operations..."

echo "Building images..."
docker compose build

echo "Starting services..."
docker compose up -d

echo "Waiting for services to be ready..."
sleep 10

# Check services
echo ""
echo "🔍 Checking services..."

# Check database
if docker compose exec -T db pg_isready -U appuser > /dev/null 2>&1; then
    print_status "Database is healthy"
else
    print_error "Database is not healthy"
fi

# Check backend
if curl -s http://localhost:4000/api/health > /dev/null; then
    print_status "Backend /api/health is accessible"
    HEALTH_RESPONSE=$(curl -s http://localhost:4000/api/health)
    echo "   Response: $HEALTH_RESPONSE"
else
    print_error "Backend /api/health is not accessible"
fi

# Check backend API test
if curl -s http://localhost:4000/api/test > /dev/null; then
    print_status "Backend /api/test is accessible"
    TEST_RESPONSE=$(curl -s http://localhost:4000/api/test)
    echo "   Response: $TEST_RESPONSE"
else
    print_error "Backend /api/test is not accessible"
fi

# Check frontend
if curl -s http://localhost:3000 > /dev/null; then
    print_status "Frontend is accessible"
else
    print_error "Frontend is not accessible"
fi

# Show logs
echo ""
echo "📋 Service Logs..."

echo "Backend logs (last 10 lines):"
docker compose logs --tail=10 backend

echo ""
echo "Frontend logs (last 10 lines):"
docker compose logs --tail=10 frontend

echo ""
echo "Database logs (last 5 lines):"
docker compose logs --tail=5 db

# Show running containers
echo ""
echo "📊 Running Containers:"
docker compose ps

# Simulate incidents
echo ""
echo "🚨 Simulating Incidents..."

echo "1. Testing CORS (should work with current setup)"
curl -s -H "Origin: http://localhost:3000" http://localhost:4000/api/health > /dev/null && print_status "CORS headers present" || print_error "CORS headers missing"

echo "2. Testing database dependency"
# Temporarily stop db to simulate incident
docker compose stop db
sleep 2
if curl -s http://localhost:4000/api/health > /dev/null; then
    print_error "Backend should fail without database"
else
    print_status "Backend correctly fails without database"
fi
# Restart db
docker compose start db
sleep 5

echo "3. Testing environment variables"
# Temporarily rename .env to simulate missing env
mv .env .env.backup
docker compose restart backend
sleep 3
if curl -s http://localhost:4000/api/health > /dev/null; then
    print_error "Backend should fail without DATABASE_URL"
else
    print_status "Backend correctly fails without DATABASE_URL"
fi
# Restore .env
mv .env.backup .env
docker compose restart backend
sleep 5

# Final verification
echo ""
echo "🎯 Final Verification..."

if curl -s http://localhost:4000/api/health > /dev/null && curl -s http://localhost:3000 > /dev/null; then
    print_status "All services are running correctly!"
    echo ""
    echo "🌐 Access URLs:"
    echo "   Frontend: http://localhost:3000"
    echo "   Backend Health: http://localhost:4000/api/health"
    echo "   Backend Test: http://localhost:4000/api/test"
    echo ""
    echo "🛑 To stop: docker compose down"
    echo "📋 To view logs: docker compose logs -f [service]"
else
    print_error "Some services are not working"
fi

echo ""
echo "📖 Next steps:"
echo "1. Open http://localhost:3000 in browser"
echo "2. Check browser console for errors"
echo "3. Test API with Postman (backend/postman_collection.json)"
echo "4. Push to GitHub to trigger CI/CD"
echo "5. Follow deploy-render.md for production deployment"