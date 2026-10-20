@echo off
title ShopSphere - Deploy to Tomcat 11
echo ===================================================
echo Building and Deploying ShopSphere to Apache Tomcat 11...
echo ===================================================
call mvn clean package
if %errorlevel% neq 0 (
    echo Maven build failed.
    pause
    exit /b %errorlevel%
)

echo Copying ShopSphere.war to Tomcat webapps...
copy /Y "web\target\ShopSphere.war" "C:\Users\nikhi\Downloads\apache-tomcat-11.0.26-windows-x64\apache-tomcat-11.0.26\webapps\ShopSphere.war"

echo Deployment complete!
echo Opening browser at http://localhost:8080/ShopSphere/
start http://localhost:8080/ShopSphere/
pause
