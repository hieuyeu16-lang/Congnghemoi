#!/bin/bash

echo "🔄 Local CI/CD Pipeline Test"
echo "============================"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

PASSED=0
FAILED=0

run_step() {
    local step_name="$1"
    local command="$2"

    echo -e "${YELLOW}▶️  Running: $step_name${NC}"

    if eval "$command"; then
        echo -e "${GREEN}✅ $step_name PASSED${NC}"
        ((PASSED++))
    else
        echo -e "${RED}❌ $step_name FAILED${NC}"
        ((FAILED++))
    fi
    echo ""
}

echo "🚀 Starting Local CI/CD Pipeline..."
echo ""

# Backend steps
echo "📦 Backend Pipeline"
echo "-------------------"

run_step "Backend Install" "cd backend && npm install --silent"
run_step "Backend Lint" "cd backend && npm run lint"
run_step "Backend Test" "cd backend && npm test"
run_step "Backend Build" "cd backend && npm run build"

# Frontend steps
echo "🌐 Frontend Pipeline"
echo "--------------------"

run_step "Frontend Install" "cd frontend && npm install --silent"
run_step "Frontend Lint" "cd frontend && npm run lint"
run_step "Frontend Test" "cd frontend && npm test"
run_step "Frontend Build" "cd frontend && npm run build"

# Docker steps
echo "🐳 Docker Pipeline"
echo "------------------"

run_step "Docker Compose Config" "docker compose config --quiet"
run_step "Docker Build" "docker compose build --quiet"

# Environment checks
echo "🔧 Environment Checks"
echo "----------------------"

run_step "Env Example Exists" "[ -f .env.example ]"
run_step "Env Not Committed" "[ ! -f .env ] || ! git ls-files .env | grep -q .env"
run_step "Gitignore Exists" "[ -f .gitignore ]"

# Documentation checks
echo "📚 Documentation Checks"
echo "------------------------"

run_step "README Exists" "[ -f README.md ]"
run_step "Git Workflow Exists" "[ -f GIT_WORKFLOW.md ]"
run_step "Incidents Report Exists" "[ -f incidents.md ]"
run_step "Deploy Guide Exists" "[ -f deploy-render.md ]"

# API checks (requires running services)
echo "🔗 API Checks (requires running services)"
echo "-----------------------------------------"

if curl -s http://localhost:4000/api/health > /dev/null 2>&1; then
    run_step "API Health Check" "curl -s http://localhost:4000/api/health > /dev/null"
    run_step "API Test Endpoint" "curl -s http://localhost:4000/api/test > /dev/null"
else
    echo -e "${YELLOW}⚠️  Services not running - skipping API checks${NC}"
    echo "   Run './demo.sh' first to start services"
    echo ""
fi

# Summary
echo "📊 Pipeline Summary"
echo "==================="

echo "✅ Passed: $PASSED"
echo "❌ Failed: $FAILED"

if [ $FAILED -eq 0 ]; then
    echo -e "${GREEN}🎉 All checks passed! Ready to push to GitHub.${NC}"
    echo ""
    echo "📋 Next steps:"
    echo "1. Commit your changes: git add . && git commit -m 'feat: complete project setup'"
    echo "2. Push to GitHub: git push origin main"
    echo "3. Check GitHub Actions for CI/CD pipeline"
    echo "4. Create pull request if using feature branches"
else
    echo -e "${RED}⚠️  Some checks failed. Please fix before pushing.${NC}"
    exit 1
fi