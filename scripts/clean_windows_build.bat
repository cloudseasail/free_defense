@echo off
setlocal
REM Wrapper to clean stale Windows build artifacts that cause CMake cache/source path mismatches.
REM Usage: From the project root, run:
REM   scripts\clean_windows_build.bat

set SCRIPT_DIR=%~dp0
powershell -NoProfile -ExecutionPolicy Bypass -File "%SCRIPT_DIR%clean_windows_build.ps1"

endlocal
