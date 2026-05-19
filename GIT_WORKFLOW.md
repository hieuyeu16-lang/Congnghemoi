# Git Workflow Guide

## Branching Strategy

Repository branches (required):

```
main (production-ready)
dev (development integration)
feature/* (feature branches created from dev)
```

Guidelines:
- Never commit directly to `main`.
- Create `feature/*` branches from `dev` and open PRs targeting `dev`.
- Keep PRs small and focused for easier review.

## Commit Guidelines

### Commit Message Format
```
type(scope): description

[optional body]

[optional footer]
```

### Types
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation
- `style`: Code style changes
- `refactor`: Code refactoring
- `test`: Testing
- `chore`: Maintenance

### Examples
```
feat(backend): add /api/health endpoint
fix(frontend): resolve CORS error in API calls
docs(readme): update deployment instructions
test(backend): add database connection tests
```

## Workflow

### 1. Start New Feature
```bash
git checkout dev
git pull origin dev
git checkout -b feature/your-feature-name
```

### 2. Development
```bash
# Make changes
git add .
git commit -m "feat: implement new feature"
```

### 3. Push Feature Branch
```bash
git push origin feature/your-feature-name
```

### 4. Create Pull Request
- Target branch: `dev`
- Review and merge
- Delete feature branch after merge

### 5. Release to Main
```bash
git checkout main
git pull origin main
git merge dev
git push origin main
```

## CI/CD Integration

- All pushes to `main` and `dev` trigger CI pipeline
- Pull requests require CI to pass
- Pipeline runs: install → lint → test → build

## Important Notes

- Never commit directly to `main`
- Always create feature branches from `dev`
- Keep commits atomic and descriptive
- Use `.gitignore` to avoid committing sensitive files
- Run tests locally before pushing

## Emergency Fixes

For critical bugs in production:
```bash
git checkout main
git checkout -b hotfix/critical-bug
# Fix the bug
git commit -m "fix: critical bug in production"
git push origin hotfix/critical-bug
# Create PR to main and dev
```