@echo off
title ShopSphere - java.net Socket Server
echo ===================================================
echo Starting ShopSphere java.net Inventory Socket Server...
echo Port: 8888 ^| Object Serialization Protocol
echo ===================================================
java -cp "network\target\shopsphere-network-1.0.0.jar;shopsphere-common\target\shopsphere-common-1.0.0.jar;%USERPROFILE%\.m2\repository\com\mysql\mysql-connector-j\8.3.0\mysql-connector-j-8.3.0.jar" com.shopsphere.network.server.InventorySocketServer
pause
