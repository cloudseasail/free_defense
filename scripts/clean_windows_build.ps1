# Clears stale Windows build artifacts that can cause CMake cache/source path mismatch errors.
# Usage: From the project root, run:
#   powershell -ExecutionPolicy Bypass -File .\scripts\clean_windows_build.ps1

$ErrorActionPreference = 'Stop'

function Remove-IfExists {
    param(
        [Parameter(Mandatory=$true)][string]$Path
    )
    if (Test-Path -LiteralPath $Path) {
        Write-Host "Removing: $Path" -ForegroundColor Yellow
        Remove-Item -LiteralPath $Path -Recurse -Force -ErrorAction SilentlyContinue
    } else {
        Write-Host "Not found (skip): $Path" -ForegroundColor DarkGray
    }
}

# Resolve repo root (script is located under scripts/)
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoRoot = Split-Path -Parent $ScriptDir
Set-Location $RepoRoot

# Paths to clean
$paths = @(
    Join-Path $RepoRoot 'build\windows',
    Join-Path $RepoRoot 'build\win32',
    Join-Path $RepoRoot 'windows\flutter\ephemeral'
)

Write-Host "Cleaning Windows build artifacts to fix CMake cache mismatches..." -ForegroundColor Cyan
foreach ($p in $paths) {
    Remove-IfExists -Path $p
}

Write-Host "Cleanup complete. You can now regenerate build files, e.g.:" -ForegroundColor Green
Write-Host "  flutter clean" -ForegroundColor Green
Write-Host "  flutter pub get" -ForegroundColor Green
Write-Host "  flutter build windows" -ForegroundColor Green
