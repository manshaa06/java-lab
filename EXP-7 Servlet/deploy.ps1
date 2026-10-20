# deploy.ps1 - Builds and deploys the servlet to Tomcat 11
$ErrorActionPreference = "Stop"

$tomcatHome = "C:\Users\nikhi\Downloads\apache-tomcat-11.0.26-windows-x64\apache-tomcat-11.0.26"
$env:CATALINA_HOME = $tomcatHome

Write-Host "1. Building WAR file with Maven..." -ForegroundColor Cyan
mvn clean package

if ($LASTEXITCODE -ne 0) {
    Write-Host "Maven build failed!" -ForegroundColor Red
    exit $LASTEXITCODE
}

Write-Host "2. Deploying servlet.war to Tomcat webapps..." -ForegroundColor Cyan
Copy-Item "target\servlet.war" -Destination "$tomcatHome\webapps\servlet.war" -Force

# Check if Tomcat is running on port 8080
$running = Get-NetTCPConnection -LocalPort 8080 -ErrorAction SilentlyContinue

if (-not $running) {
    Write-Host "3. Starting Tomcat..." -ForegroundColor Cyan
    Start-Process "$tomcatHome\bin\startup.bat"
    Start-Sleep -Seconds 3
} else {
    Write-Host "3. Tomcat is already running on port 8080. Deployed updated servlet.war." -ForegroundColor Green
}

Write-Host "`nAccess the application at:" -ForegroundColor Yellow
Write-Host "http://localhost:8080/servlet/student.jsp" -ForegroundColor White
Start-Process "http://localhost:8080/servlet/student.jsp"
