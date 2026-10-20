package com.shopsphere.rmi.client;

import com.shopsphere.model.Product;
import com.shopsphere.rmi.remote.InventoryService;

import java.rmi.Naming;
import java.util.List;

/**
 * Client demonstrating RMI Registry Lookup and Remote Method Invocation.
 * RTU Advanced Java Syllabus Topic: RMI Client & Remote Invocations.
 */
public class RmiClient {

    public static void main(String[] args) {
        String host = "localhost";
        int port = 1099;
        String serviceName = "InventoryService";

        String url = "rmi://" + host + ":" + port + "/" + serviceName;

        System.out.println("=============================================================");
        System.out.println(" [ShopSphere RMI Client] Connecting to: " + url);
        System.out.println("=============================================================");

        try {
            // 1. Lookup remote interface proxy from RMI registry
            System.out.println(">> Performing RMI Registry Lookup for '" + serviceName + "'...");
            InventoryService remoteService = (InventoryService) Naming.lookup(url);
            System.out.println(">> Remote stub proxy obtained successfully: " + remoteService.getClass().getName());

            // 2. Invoke remote getProduct
            System.out.println("\n--- [RMI Test 1] Invoking remote getProduct(1) ---");
            Product p1 = remoteService.getProduct(1);
            if (p1 != null) {
                System.out.println(">> Remote Returned Product: " + p1.getName());
                System.out.println("   Brand: " + p1.getBrand() + " | Price: ₹" + p1.getPrice() + " | Stock: " + p1.getStock());
            }

            // 3. Invoke remote getStock
            System.out.println("\n--- [RMI Test 2] Invoking remote getStock(2) ---");
            int stock2 = remoteService.getStock(2);
            System.out.println(">> Remote Returned Stock for Product #2: " + stock2 + " units");

            // 4. Invoke remote updateStock
            System.out.println("\n--- [RMI Test 3] Invoking remote updateStock(2, " + (stock2 + 5) + ") ---");
            boolean updated = remoteService.updateStock(2, stock2 + 5);
            System.out.println(">> Remote Stock Update Result: " + updated);
            System.out.println(">> Verified Stock: " + remoteService.getStock(2) + " units");

            // 5. Invoke remote getLowStockProducts
            System.out.println("\n--- [RMI Test 4] Invoking remote getLowStockProducts(25) ---");
            List<Product> lowStock = remoteService.getLowStockProducts(25);
            System.out.println(">> Found " + lowStock.size() + " items below threshold 25:");
            for (Product lp : lowStock) {
                System.out.println("   - [" + lp.getProductId() + "] " + lp.getName() + " (Stock: " + lp.getStock() + ")");
            }

            System.out.println("\n=============================================================");
            System.out.println(" [SUCCESS] All Java RMI Invocations Completed Successfully!");
            System.out.println("=============================================================");

        } catch (Exception e) {
            System.err.println("[RMI Client Error]: " + e.getMessage());
            System.err.println("Ensure RmiServer is running and listening on port " + port);
        }
    }
}
