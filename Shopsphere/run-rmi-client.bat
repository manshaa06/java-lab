@echo off
title ShopSphere - Java RMI Client
echo ===================================================
echo Invoking ShopSphere Remote Inventory Service...
echo ===================================================
java -cp "rmi\target\shopsphere-rmi-1.0.0.jar;shopsphere-common\target\shopsphere-common-1.0.0.jar;%USERPROFILE%\.m2\repository\com\mysql\mysql-connector-j\8.3.0\mysql-connector-j-8.3.0.jar" com.shopsphere.rmi.client.RmiClient
pause
