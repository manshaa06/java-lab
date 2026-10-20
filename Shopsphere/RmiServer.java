package com.shopsphere.rmi.server;

import com.shopsphere.rmi.remote.InventoryService;

import java.rmi.Naming;
import java.rmi.registry.LocateRegistry;

/**
 * Server launcher that initializes the RMI Registry and binds the remote service.
 * RTU Advanced Java Syllabus Topic: RMI Architecture & RMI Registry.
 */
public class RmiServer {

    public static final int REGISTRY_PORT = 1099;
    public static final String SERVICE_NAME = "InventoryService";

    public static void main(String[] args) {
        try {
            System.out.println("=============================================================");
            System.out.println(" [ShopSphere RMI Server] Starting Remote Registry on port " + REGISTRY_PORT);
            System.out.println("=============================================================");

            // 1. Create or locate local RMI Registry
            try {
                LocateRegistry.createRegistry(REGISTRY_PORT);
                System.out.println(">> Local RMI Registry started on port " + REGISTRY_PORT);
            } catch (Exception e) {
                System.out.println(">> RMI Registry already active on port " + REGISTRY_PORT);
            }

            // 2. Instantiate Remote Object
            InventoryService service = new InventoryServiceImpl();

            // 3. Bind service in RMI Registry using standard Naming URL
            String rmiUrl = "rmi://localhost:" + REGISTRY_PORT + "/" + SERVICE_NAME;
            Naming.rebind(rmiUrl, service);

            System.out.println(">> Remote Object registered successfully!");
            System.out.println(">> URL: " + rmiUrl);
            System.out.println(">> ShopSphere RMI Server is READY to handle remote client calls.");
            System.out.println("=============================================================");

            // Keep main thread alive
            Thread.currentThread().join();

        } catch (Exception e) {
            System.err.println("[RMI Server Exception]: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
