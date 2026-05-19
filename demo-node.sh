#!/bin/bash

echo "🚀 DevOps Demo - Node.js Version (No Docker Required)"
echo "==================================================="

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Function to check if port is in use
check_port() {
    local port=$1
    local name=$2
    if lsof -Pi :$port -sTCP:LISTEN -t >/dev/null 2>&1; then
        echo -e "${GREEN}✅ $name running on port $port${NC}"
        return 0
    else
        echo -e "${RED}❌ $name not running on port $port${NC}"
        return 1
    fi
}

# Setup environment
echo "📝 Setting up environment..."
if [ ! -f ".env" ]; then
    cp .env.example .env
    echo -e "${GREEN}✅ Created .env from .env.example${NC}"
else
    echo -e "${YELLOW}⚠️  .env already exists${NC}"
fi

# Start backend
echo ""
echo "🔧 Starting Backend..."
cd backend
npm install > /dev/null 2>&1
npm start &
BACKEND_PID=$!
cd ..
echo -e "${BLUE}📍 Backend PID: $BACKEND_PID${NC}"

# Wait for backend to start
echo "⏳ Waiting for backend to start..."
sleep 5

# Check backend health
echo ""
echo "🔍 Checking Backend..."
if curl -s http://localhost:4000/api/health > /dev/null 2>&1; then
    echo -e "${GREEN}✅ Backend /api/health accessible${NC}"
    HEALTH_RESPONSE=$(curl -s http://localhost:4000/api/health 2>/dev/null)
    echo "   Response: $HEALTH_RESPONSE"
else
    echo -e "${RED}❌ Backend /api/health not accessible${NC}"
fi

# Check backend test endpoint
if curl -s http://localhost:4000/api/test > /dev/null 2>&1; then
    echo -e "${GREEN}✅ Backend /api/test accessible${NC}"
    TEST_RESPONSE=$(curl -s http://localhost:4000/api/test 2>/dev/null)
    echo "   Response: $TEST_RESPONSE"
else
    echo -e "${RED}❌ Backend /api/test not accessible${NC}"
fi

# Start frontend
echo ""
echo "🌐 Starting Frontend..."
cd frontend
npm install > /dev/null 2>&1
npm run dev &
FRONTEND_PID=$!
cd ..
echo -e "${BLUE}📍 Frontend PID: $FRONTEND_PID${NC}"

# Wait for frontend to start
echo "⏳ Waiting for frontend to start..."
sleep 5

# Check frontend
echo ""
echo "🔍 Checking Frontend..."
if curl -s http://localhost:5173 > /dev/null 2>&1; then
    echo -e "${GREEN}✅ Frontend accessible on port 5173${NC}"
else
    echo -e "${RED}❌ Frontend not accessible${NC}"
fi

# Show running processes
echo ""
echo "📊 Running Processes:"
ps aux | grep -E "(node|npm)" | grep -v grep

# Show access URLs
echo ""
echo "🌐 Access URLs:"
echo -e "${BLUE}   Frontend (Dev): http://localhost:5173${NC}"
echo -e "${BLUE}   Backend Health: http://localhost:4000/api/health${NC}"
echo -e "${BLUE}   Backend Test: http://localhost:4000/api/test${NC}"

# Test CI/CD locally
echo ""
echo "🔄 Running Local CI/CD Tests..."
echo "Backend tests:"
cd backend && npm test 2>/dev/null && echo -e "${GREEN}✅ Backend tests passed${NC}" || echo -e "${RED}❌ Backend tests failed${NC}"
cd ..

echo "Frontend tests:"
cd frontend && npm test 2>/dev/null && echo -e "${GREEN}✅ Frontend tests passed${NC}" || echo -e "${RED}❌ Frontend tests failed${NC}"
cd ..

# Simulate incidents
echo ""
echo "🚨 Simulating Incidents..."

echo "1. Testing environment variables..."
# Temporarily remove VITE_API_URL
sed -i 's/VITE_API_URL=.*//' .env
echo -e "${YELLOW}⚠️  Removed VITE_API_URL from .env${NC}"
echo -e "${YELLOW}   Frontend should show API errors${NC}"

echo "2. Testing backend failure..."
kill $BACKEND_PID 2>/dev/null
sleep 2
if curl -s http://localhost:4000/api/health > /dev/null 2>&1; then
    echo -e "${RED}❌ Backend should be down${NC}"
else
    echo -e "${GREEN}✅ Backend correctly down${NC}"
fi

# Restore environment
echo "VITE_API_URL=http://localhost:4000" >> .env
echo -e "${GREEN}✅ Restored VITE_API_URL${NC}"

# Restart backend
cd backend && npm start &
NEW_BACKEND_PID=$!
cd ..
echo -e "${GREEN}✅ Restarted backend (PID: $NEW_BACKEND_PID)${NC}"

# Final status
echo ""
echo "🎯 Demo Complete!"
echo ""
echo "📋 Manual Checks:"
echo "1. Open http://localhost:5173 in browser"
echo "2. Check browser console for errors"
echo "3. Test API endpoints with Postman"
echo "4. Try modifying .env to see error handling"
echo ""
echo "🛑 To stop: kill $NEW_BACKEND_PID $FRONTEND_PID"
echo "📖 See README.md for full documentation"