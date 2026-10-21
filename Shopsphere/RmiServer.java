package com.shopsphere.rmi;

import java.rmi.Naming;
import java.rmi.registry.LocateRegistry;

/** Starts the RMI registry (port 1099) and binds the inventory service under the name "InventoryService". */
public class RmiServer {
    public static final int PORT = 1099;

    public static void main(String[] args) throws Exception {
        LocateRegistry.createRegistry(PORT);
        Naming.rebind("rmi://localhost:" + PORT + "/InventoryService", new InventoryServiceImpl());
        System.out.println("RMI registry started on port " + PORT + ", InventoryService bound.");
    }
}
