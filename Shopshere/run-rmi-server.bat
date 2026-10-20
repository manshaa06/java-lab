@echo off
title ShopSphere - Java RMI Registry and Server
echo ===================================================
echo Starting ShopSphere Remote Inventory Service...
echo RMI Registry Port: 1099
echo ===================================================
java -cp "rmi\target\shopsphere-rmi-1.0.0.jar;shopsphere-common\target\shopsphere-common-1.0.0.jar;%USERPROFILE%\.m2\repository\com\mysql\mysql-connector-j\8.3.0\mysql-connector-j-8.3.0.jar" com.shopsphere.rmi.server.RmiServer
pause
