# Start Schema App using Docker Hub image
# Usage: .\run-schema-from-hub.ps1 [port]
#
# Opens the browser automatically once the app is ready.
# Press Ctrl+C to stop the app.

param(
    [int]$Port = 5000
)

$Image = "hapdocker/dash-gui:latest"
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$ContainerName = "dash-gui-schema-$PID"
$Url = "http://localhost:$Port"

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "  DASH-GUI  |  Schema App" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "  Image: $Image"
Write-Host "  Port:  $Port"
Write-Host "  URL:   $Url"
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

# Pull latest image
Write-Host "Pulling latest image..." -ForegroundColor Yellow
if (-not (docker pull $Image)) {
    Write-Host "ERROR: Failed to pull image. Is Docker running?" -ForegroundColor Red
    exit 1
}
Write-Host ""

# Start container in background
Write-Host "Starting Schema App..." -ForegroundColor Yellow
docker run -d `
    --rm `
    --name $ContainerName `
    -p "${Port}:${Port}" `
    -v "${ScriptDir}:/app/data" `
    -e APP=schema `
    -e PORT=$Port `
    -e SHARED_LIBRARIES_ROOT=/app/data `
    $Image | Out-Null

# Wait for app to be ready
Write-Host "Waiting for app to be ready..."
$ready = $false
for ($i = 1; $i -le 30; $i++) {
    try {
        $response = Invoke-WebRequest -Uri $Url -UseBasicParsing -TimeoutSec 2 -ErrorAction Stop
        if ($response.StatusCode -eq 200) { $ready = $true; break }
    } catch {}
    Start-Sleep -Seconds 1
}

Write-Host ""
Write-Host "=========================================" -ForegroundColor Green
Write-Host "  Schema App is running at: $Url" -ForegroundColor Green
Write-Host "  Press Ctrl+C to stop." -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green
Write-Host ""

# Open browser
Start-Process $Url

# Keep script alive; stop container on exit
try {
    while ($true) { Start-Sleep -Seconds 1 }
} finally {
    Write-Host ""
    Write-Host "Stopping Schema App..." -ForegroundColor Yellow
    docker stop $ContainerName | Out-Null
    Write-Host "Done. Goodbye!" -ForegroundColor Green
}
