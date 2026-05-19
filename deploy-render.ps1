# Render deployment helper for Windows
# Usage: .\deploy-render.ps1

if (-not (Get-Command render -ErrorAction SilentlyContinue)) {
    Write-Host "Render CLI chưa được cài đặt. Đang cài..." -ForegroundColor Yellow
    npm install -g @renderinc/cli
}

if (-not $env:RENDER_API_KEY) {
    Write-Host "ERROR: Biến môi trường RENDER_API_KEY chưa được đặt." -ForegroundColor Red
    Write-Host "1. Tạo API key trên https://dashboard.render.com/account/api-keys" -ForegroundColor Yellow
    Write-Host "2. Trong PowerShell: setx RENDER_API_KEY \"<your_key>\"" -ForegroundColor Yellow
    Write-Host "3. Đóng và mở lại PowerShell, rồi chạy lại script." -ForegroundColor Yellow
    exit 1
}

Write-Host "Đang deploy lên Render..." -ForegroundColor Cyan
render deploy --wait

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Deploy hoàn tất." -ForegroundColor Green
} else {
    Write-Host "❌ Deploy thất bại. Kiểm tra log trên Render và sửa lỗi." -ForegroundColor Red
}
