$ErrorActionPreference = "Continue"
$repoRoot = Split-Path -Parent (Split-Path -Parent (Split-Path -Parent $PSScriptRoot))
Push-Location $repoRoot
try {
    Write-Host "Git status" -ForegroundColor Cyan
    git status -sb

    Write-Host "`nLatest commit" -ForegroundColor Cyan
    git log -1 --oneline

    Write-Host "`nChanged files" -ForegroundColor Cyan
    git status --short

    Write-Host "`nWhitespace/error check for tracked changes" -ForegroundColor Cyan
    git diff --check

    Write-Host "`nReview staged changes separately before commit:" -ForegroundColor Yellow
    Write-Host "git diff --cached --check"
    Write-Host "git diff --cached --name-only"
    Write-Host "Do not commit .env, database dumps, tokens, backups, ZIP archives, or private test data."
}
finally {
    Pop-Location
}
