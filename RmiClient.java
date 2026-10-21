package com.shopsphere.rmi;

import com.shopsphere.model.Product;
import java.rmi.Naming;

/** Looks up the remote service in the registry and calls it like a local object. */
public class RmiClient {
    public static void main(String[] args) throws Exception {
        String host = args.length > 0 ? args[0] : "localhost";
        InventoryService service = (InventoryService) Naming.lookup("rmi://" + host + ":" + RmiServer.PORT + "/InventoryService");

        Product p = service.getProduct(1);                      // Product is serialized and sent back
        System.out.println("getProduct(1)  -> " + p);
        System.out.println("getStock(1)    -> " + service.getStock(1));
        boolean ok = service.updateStock(1, service.getStock(1));
        System.out.println("updateStock(1) -> " + ok);
    }
}
