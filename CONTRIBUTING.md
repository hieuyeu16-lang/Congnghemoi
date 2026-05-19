# Contributing Guide

## Development Setup

### Prerequisites
- Node.js 18+
- Docker & Docker Compose
- Git

### Local Development

1. **Clone and setup**
   ```bash
   git clone <repository-url>
   cd congnghemoi
   cp .env.example .env
   ```

2. **Start development environment**
   ```bash
   # Start all services
   docker compose up -d

   # Or run frontend/backend separately for development
   cd frontend && npm run dev
   cd backend && npm run dev
   ```

3. **Run tests**
   ```bash
   # Test all components
   ./test-ci.sh

   # Test specific component
   cd backend && npm test
   cd frontend && npm test
   ```

## Development Workflow

### 1. Create Feature Branch
```bash
git checkout dev
git pull origin dev
git checkout -b feature/your-feature-name
```

Note: repository branches required:
- `main` — production-ready only
- `dev` — integration branch for features and testing
- `feature/*` — feature branches created from `dev`

### 2. Development
- Write code following existing patterns
- Add tests for new functionality
- Update documentation if needed
- Run `./test-ci.sh` to ensure everything works

### 3. Commit Changes
```bash
git add .
git commit -m "feat: add new feature description"
```

Commit rules (required):
- Do NOT use vague finalizing commits like "1 lần cuối", "final", "final commit", or similar single-message commits. These are rejected by the commit hook.
- Keep commits small and focused; each commit should represent one logical change.
- Use the commit message format described in "Commit Message Guidelines" below.

To enforce commit message checks locally, enable git hooks once after cloning:

```bash
# set hooks path (run once after clone)
git config core.hooksPath .githooks
```

### 4. Push and Create PR
```bash
git push origin feature/your-feature-name
# Create Pull Request to dev branch
```

### 5. Code Review
- Ensure CI/CD pipeline passes
- Address review comments
- Merge to dev when approved

## Code Standards

### Backend (Node.js/Express)
- Use ES modules (`import/export`)
- Follow ESLint rules
- Add JSDoc for public functions
- Handle errors properly with logging

### Frontend (React/Vite)
- Use functional components with hooks
- Follow ESLint rules
- Use environment variables (VITE_*)
- No hardcoded URLs

### Docker
- Use multi-stage builds for optimization
- Follow .dockerignore patterns
- Keep images minimal

### Testing
- Write unit tests for business logic
- Test API endpoints with supertest
- Test components with React Testing Library
- Ensure CI passes all tests

## Incident Reporting

When encountering issues:

1. **Document the incident** in `incidents.md`
2. **Follow the format**:
   - Phenomenon
   - Layer (L1-L4)
   - Root cause
   - Fix applied
   - Prevention measures

3. **Test the fix** thoroughly
4. **Update documentation** if needed

## Deployment

### Development
- Push to `dev` branch
- CI/CD runs automatically
- Manual testing in staging

### Production
- Merge `dev` to `main`
- CI/CD deploys to production
- Monitor logs and health checks

## Troubleshooting

### Common Issues

**Services won't start**
```bash
docker compose logs
docker compose ps
```

**API returns 500**
```bash
docker compose logs backend
curl http://localhost:4000/api/health
```

**Frontend shows errors**
```bash
docker compose logs frontend
# Check browser console
```

**Tests fail**
```bash
cd backend && npm test -- --verbose
cd frontend && npm test -- --verbose
```

### Getting Help

1. Check existing `incidents.md`
2. Run `./simulate-incidents.sh` to test scenarios
3. Review `README.md` and documentation
4. Check Docker and CI/CD logs

## Commit Message Guidelines

```
type(scope): description

[optional body]

[optional footer]
```

**Types:**
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation
- `style`: Code style
- `refactor`: Code refactoring
- `test`: Testing
- `chore`: Maintenance

**Examples:**
```
feat(backend): add user authentication
fix(frontend): resolve memory leak in component
docs(readme): update API documentation
test(backend): add integration tests for health endpoint
```