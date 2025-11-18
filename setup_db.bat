@echo off
set DB_HOST=localhost
set DB_PORT=5432
set DB_USER=postgres
set DB_PASSWORD=root
set DB_NAME=l2db
set SQL_URL=https://lineage2js.github.io/scripts/l2db.sql
set SQL_FILE=l2db.sql

set PGPASSWORD=%DB_PASSWORD%
set "FULL_PATH=%~dp0%SQL_FILE%"

echo Connect to %DB_HOST%:%DB_PORT%...

:: Checking the connection to PostgreSQL
psql -h %DB_HOST% -p %DB_PORT% -U %DB_USER% -d postgres -c "SELECT 1;" >nul 2>&1
if errorlevel 1 (
    echo ERROR: Cannot connect to PostgreSQL server!
    echo Please make sure that:
    echo 1. PostgreSQL is installed and running
    echo 2. Server is listening on %DB_HOST%:%DB_PORT%
    echo 3. User '%DB_USER%' exists and password is correct
    echo.
    pause
    exit /b 1
)

:: Checking the existence of a database
psql -h %DB_HOST% -p %DB_PORT% -U %DB_USER% -d postgres -t -A -c "SELECT 1 FROM pg_database WHERE datname = '%DB_NAME%';" | find "1" >nul

if %errorlevel% equ 0 (
    echo Database %DB_NAME% already exists! Exiting.
    pause
    exit /b 1
)

:: Downloading SQL file
echo Downloading SQL file from %SQL_URL%...
powershell -Command "Invoke-WebRequest -Uri '%SQL_URL%' -OutFile '%SQL_FILE%'" >nul 2>&1

if not exist "%FULL_PATH%" (
    echo Error: Failed to download SQL file!
    pause
    exit /b 1
)

echo Creating database %DB_NAME%...
psql -h %DB_HOST% -p %DB_PORT% -U %DB_USER% -c "CREATE DATABASE %DB_NAME%;" >nul 2>&1

echo Importing SQL file %SQL_FILE%...
psql -h %DB_HOST% -p %DB_PORT% -U %DB_USER% -d %DB_NAME% -q -f "%FULL_PATH%"

echo.
echo Created tables in database %DB_NAME%:
psql -h %DB_HOST% -p %DB_PORT% -U %DB_USER% -d %DB_NAME% -t -A -c "SELECT table_name FROM information_schema.tables WHERE table_schema = 'public' ORDER BY table_name;"

:: Deleting a temporary file
del "%FULL_PATH%"

echo Done!
pause
