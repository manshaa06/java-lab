@echo off
title ShopSphere - Initialize Database
echo ===================================================
echo Importing database\shopsphere.sql into MySQL...
echo ===================================================
powershell -Command "Get-Content 'database\shopsphere.sql' -Raw | & 'C:\xampp\mysql\bin\mysql.exe' -u root"
if %errorlevel% equ 0 (
    echo Database initialized and seeded successfully!
) else (
    echo Error initializing database. Ensure MySQL is running.
)
pause
