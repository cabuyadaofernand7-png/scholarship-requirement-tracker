param(
    [switch]$SkipBackend,
    [switch]$SkipFlutter
)

$ErrorActionPreference = "Continue"
$repoRoot = Split-Path -Parent (Split-Path -Parent (Split-Path -Parent $PSScriptRoot))
$backend = Join-Path $repoRoot "backend"
$frontend = Join-Path $repoRoot "frontend"
$timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
$outDir = Join-Path $repoRoot "documentation\week-17\08-repository-and-maintenance\verification-$timestamp"

New-Item -ItemType Directory -Path $outDir -Force | Out-Null

Write-Host "Week 17 verification helper" -ForegroundColor Cyan
Write-Host "Repository: $repoRoot"
Write-Host "Output: $outDir"
Write-Host "This script does not run migrations or modify the database." -ForegroundColor Yellow

if (-not $SkipBackend) {
    if (Test-Path (Join-Path $backend "artisan")) {
        Push-Location $backend
        try {
            Write-Host "`n[1/2] Laravel route inventory" -ForegroundColor Cyan
            php artisan route:list --path=api 2>&1 |
                Tee-Object -FilePath (Join-Path $outDir "laravel-api-routes.txt")

            Write-Host "`n[2/2] Laravel test suite" -ForegroundColor Cyan
            Write-Host "Confirm backend .env and phpunit.xml use the isolated test database before proceeding." -ForegroundColor Yellow
            php artisan test 2>&1 |
                Tee-Object -FilePath (Join-Path $outDir "laravel-test-results.txt")
        }
        finally {
            Pop-Location
        }
    } else {
        Write-Warning "Laravel artisan file not found at $backend"
    }
}

if (-not $SkipFlutter) {
    if (Test-Path (Join-Path $frontend "pubspec.yaml")) {
        Push-Location $frontend
        try {
            Write-Host "`nFlutter analyze" -ForegroundColor Cyan
            flutter analyze 2>&1 |
                Tee-Object -FilePath (Join-Path $outDir "flutter-analyze.txt")

            Write-Host "`nFlutter tests" -ForegroundColor Cyan
            flutter test 2>&1 |
                Tee-Object -FilePath (Join-Path $outDir "flutter-test.txt")

            Write-Host "`nFlutter Web build" -ForegroundColor Cyan
            flutter build web 2>&1 |
                Tee-Object -FilePath (Join-Path $outDir "flutter-web-build.txt")
        }
        finally {
            Pop-Location
        }
    } else {
        Write-Warning "Flutter pubspec.yaml not found at $frontend"
    }
}

Write-Host "`nVerification commands finished. Review each output file and record actual exit status/results." -ForegroundColor Green
Write-Host "No output from this helper should be treated as a production-readiness test."
