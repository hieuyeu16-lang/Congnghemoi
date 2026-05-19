# DevOps Demo - PowerShell Version (Windows Native)
# =================================================

Write-Host "🚀 DevOps Demo - PowerShell Version" -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan

# Colors for PowerShell
$Green = "Green"
$Red = "Red"
$Yellow = "Yellow"
$Blue = "Blue"

$scriptRoot = Split-Path -Path $MyInvocation.MyCommand.Path -Parent

# Function to check if port is in use
function Test-Port {
    param([int]$Port)
    $connection = Test-NetConnection -ComputerName localhost -Port $Port -WarningAction SilentlyContinue
    return $connection.TcpTestSucceeded
}

# Setup environment
Write-Host "`n📝 Setting up environment..." -ForegroundColor $Blue
if (!(Test-Path ".env")) {
    Copy-Item ".env.example" ".env"
    Write-Host "✅ Created root .env from .env.example" -ForegroundColor $Green
} else {
    Write-Host "⚠️  Root .env already exists" -ForegroundColor $Yellow
}
if (!(Test-Path "backend\.env")) {
    Copy-Item ".env.example" "backend\.env"
    Write-Host "✅ Created backend\.env from .env.example" -ForegroundColor $Green
} else {
    Write-Host "⚠️  backend\.env already exists" -ForegroundColor $Yellow
}
if (!(Test-Path "frontend\.env")) {
    Copy-Item ".env.example" "frontend\.env"
    Write-Host "✅ Created frontend\.env from .env.example" -ForegroundColor $Green
} else {
    Write-Host "⚠️  frontend\.env already exists" -ForegroundColor $Yellow
}

# Start backend
Write-Host "`n🔧 Starting Backend..." -ForegroundColor $Blue
Set-Location backend
npm install --silent | Out-Null
Set-Location ..
$backendJob = Start-Job -ScriptBlock { param($path) Set-Location $path; npm start } -ArgumentList "$scriptRoot\backend"
Write-Host "📍 Backend Job ID: $($backendJob.Id)" -ForegroundColor $Blue

# Wait for backend to start
Write-Host "⏳ Waiting for backend to start..." -ForegroundColor $Yellow
Start-Sleep -Seconds 5

# Check backend health
Write-Host "`n🔍 Checking Backend..." -ForegroundColor $Blue
try {
    $healthResponse = Invoke-RestMethod -Uri "http://localhost:4000/api/health" -Method Get -TimeoutSec 5
    Write-Host "✅ Backend /api/health accessible" -ForegroundColor $Green
    Write-Host "   Response: $($healthResponse | ConvertTo-Json -Depth 3)" -ForegroundColor $Blue
} catch {
    Write-Host "❌ Backend /api/health not accessible" -ForegroundColor $Red
    Write-Host "   Error: $($_.Exception.Message)" -ForegroundColor $Red
}

# Check backend test endpoint
try {
    $testResponse = Invoke-RestMethod -Uri "http://localhost:4000/api/test" -Method Get -TimeoutSec 5
    Write-Host "✅ Backend /api/test accessible" -ForegroundColor $Green
    Write-Host "   Response: $($testResponse | ConvertTo-Json -Depth 3)" -ForegroundColor $Blue
} catch {
    Write-Host "❌ Backend /api/test not accessible" -ForegroundColor $Red
    Write-Host "   Error: $($_.Exception.Message)" -ForegroundColor $Red
}

# Start frontend
Write-Host "`n🌐 Starting Frontend..." -ForegroundColor $Blue
Set-Location frontend
npm install --silent | Out-Null
Set-Location ..
$frontendJob = Start-Job -ScriptBlock { param($path) Set-Location $path; npm run dev } -ArgumentList "$scriptRoot\frontend"
Write-Host "📍 Frontend Job ID: $($frontendJob.Id)" -ForegroundColor $Blue

# Wait for frontend to start
Write-Host "⏳ Waiting for frontend to start..." -ForegroundColor $Yellow
Start-Sleep -Seconds 5

# Check frontend
Write-Host "`n🔍 Checking Frontend..." -ForegroundColor $Blue
if (Test-Port 5173) {
    Write-Host "✅ Frontend accessible on port 5173" -ForegroundColor $Green
} else {
    Write-Host "❌ Frontend not accessible" -ForegroundColor $Red
}

# Show running jobs
Write-Host "`n📊 Running Jobs:" -ForegroundColor $Blue
$runningJobs = Get-Job -State Running
if ($runningJobs) {
    $runningJobs | Format-Table Id, Name, State
} else {
    Write-Host 'No running jobs found' -ForegroundColor $Yellow
}

# Show access URLs
Write-Host "`n🌐 Access URLs:" -ForegroundColor $Blue
Write-Host '   Frontend: http://localhost:5173' -ForegroundColor $Blue
Write-Host '   Backend Health: http://localhost:4000/api/health' -ForegroundColor $Blue
Write-Host '   Backend Test: http://localhost:4000/api/test' -ForegroundColor $Blue

# Test CI/CD locally
Write-Host "`n🔄 Running Local CI/CD Tests..." -ForegroundColor $Blue

Write-Host "Backend tests:" -NoNewline
Set-Location backend
try {
    npm test 2>$null | Out-Null
    Write-Host " ✅ Backend tests passed" -ForegroundColor $Green
} catch {
    Write-Host " ❌ Backend tests failed" -ForegroundColor $Red
}
Set-Location ..

Write-Host "Frontend tests:" -NoNewline
Set-Location frontend
try {
    npm test 2>$null | Out-Null
    Write-Host " ✅ Frontend tests passed" -ForegroundColor $Green
} catch {
    Write-Host " ❌ Frontend tests failed" -ForegroundColor $Red
}
Set-Location ..

# Simulate incidents
Write-Host "`n🚨 Simulating Incidents..." -ForegroundColor $Blue

Write-Host "1. Testing environment variables..." -ForegroundColor $Yellow
foreach ($path in ".env", "frontend\.env") {
    if (Test-Path $path) {
        $content = Get-Content $path
        $content | Where-Object { $_ -notmatch "^VITE_API_URL=" } | Set-Content "$path.temp"
        Move-Item "$path.temp" $path -Force
        Write-Host "⚠️  Removed VITE_API_URL from $path" -ForegroundColor $Yellow
    }
}
Write-Host "   Frontend should show API errors" -ForegroundColor $Yellow

Write-Host "2. Testing backend failure..." -ForegroundColor $Yellow
Stop-Job $backendJob -ErrorAction SilentlyContinue
Start-Sleep -Seconds 2
try {
    Invoke-RestMethod -Uri "http://localhost:4000/api/health" -Method Get -TimeoutSec 2 | Out-Null
    Write-Host "❌ Backend should be down" -ForegroundColor $Red
} catch {
    Write-Host "✅ Backend correctly down" -ForegroundColor $Green
}

# Restore environment
foreach ($path in ".env", "backend\.env", "frontend\.env") {
    Copy-Item ".env.example" $path -Force
    Write-Host "✅ Restored $path from .env.example" -ForegroundColor $Green
}

# Restart backend
$backendJob = Start-Job -ScriptBlock { param($path) Set-Location $path; npm start } -ArgumentList "$scriptRoot\backend"
Write-Host "✅ Restarted backend (Job ID: $($backendJob.Id))" -ForegroundColor $Green

# Final status
Write-Host "`n🎯 Demo Complete!" -ForegroundColor $Green
Write-Host "`n📋 Manual Checks:" -ForegroundColor $Blue
Write-Host "1. Open http://localhost:5173 in browser" -ForegroundColor $Blue
Write-Host "2. Check browser console for errors" -ForegroundColor $Blue
Write-Host "3. Test API endpoints with Postman" -ForegroundColor $Blue
Write-Host "4. Try modifying .env to see error handling" -ForegroundColor $Blue
Write-Host "`n[STOP] To stop: Get-Job | Stop-Job" -ForegroundColor $Yellow
Write-Host "[DOCS] See README.md for full documentation" -ForegroundColor $Blue

Write-Host "`n[INFO] Jobs will continue running for manual testing..." -ForegroundColor $Yellow
Write-Host "   Press Ctrl+C to exit (jobs will continue in background)" -ForegroundColor $Yellow