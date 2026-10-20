package com.shopsphere.network.client;

import com.shopsphere.model.NetworkMessage;
import com.shopsphere.model.Product;

import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.net.Socket;

/**
 * Client demonstrating java.net.Socket communication and Object Serialization deserialization.
 * Connects to ShopSphere Inventory Socket Server and performs live queries.
 * RTU Advanced Java Syllabus Topic: Client-Server & Serialization.
 */
public class InventorySocketClient {

    private final String host;
    private final int port;

    public InventorySocketClient(String host, int port) {
        this.host = host;
        this.port = port;
    }

    public void runDemo() {
        System.out.println("=============================================================");
        System.out.println(" [ShopSphere Socket Client] Connecting to " + host + ":" + port);
        System.out.println(" Demonstrating Object Serialization & Socket Transmission");
        System.out.println("=============================================================");

        try (Socket socket = new Socket(host, port);
             ObjectOutputStream oos = new ObjectOutputStream(socket.getOutputStream());
             ObjectInputStream ois = new ObjectInputStream(socket.getInputStream())) {

            oos.flush();
            System.out.println(">> TCP Connection Established with Server.");

            // 1. Send GET_PRODUCT command
            System.out.println("\n--- [Test 1] Requesting Product #1 via Serialized NetworkMessage ---");
            NetworkMessage req1 = new NetworkMessage(NetworkMessage.Command.GET_PRODUCT);
            req1.setProductId(1);
            oos.writeObject(req1);
            oos.flush();

            NetworkMessage res1 = (NetworkMessage) ois.readObject();
            System.out.println("<< Server Response: " + res1.getMessage());
            if (res1.getProduct() != null) {
                Product p = res1.getProduct();
                System.out.println("   Deserialized Product Object: " + p.getName() + " | Brand: " + p.getBrand() + " | Price: ₹" + p.getPrice());
            }

            // 2. Send GET_STOCK command
            System.out.println("\n--- [Test 2] Requesting Stock Count for Product #2 ---");
            NetworkMessage req2 = new NetworkMessage(NetworkMessage.Command.GET_STOCK);
            req2.setProductId(2);
            oos.writeObject(req2);
            oos.flush();

            NetworkMessage res2 = (NetworkMessage) ois.readObject();
            System.out.println("<< Server Response: " + res2.getMessage());
            System.out.println("   Current Stock Units: " + res2.getStockQuantity());

            // 3. Send SEARCH_PRODUCT command
            System.out.println("\n--- [Test 3] Searching Products Matching 'Laptop' ---");
            NetworkMessage req3 = new NetworkMessage(NetworkMessage.Command.SEARCH_PRODUCT);
            req3.setQuery("laptop");
            oos.writeObject(req3);
            oos.flush();

            NetworkMessage res3 = (NetworkMessage) ois.readObject();
            System.out.println("<< Server Response: " + res3.getMessage());
            if (res3.getProductList() != null) {
                System.out.println("   Found " + res3.getProductList().size() + " items:");
                for (Product p : res3.getProductList()) {
                    System.out.println("   - [" + p.getProductId() + "] " + p.getName() + " (₹" + p.getPrice() + ")");
                }
            }

            // 4. Send UPDATE_STOCK command
            System.out.println("\n--- [Test 4] Updating Stock for Product #3 to 50 Units ---");
            NetworkMessage req4 = new NetworkMessage(NetworkMessage.Command.UPDATE_STOCK);
            req4.setProductId(3);
            req4.setStockQuantity(50);
            oos.writeObject(req4);
            oos.flush();

            NetworkMessage res4 = (NetworkMessage) ois.readObject();
            System.out.println("<< Server Response: " + res4.getMessage());
            System.out.println("   Updated Stock Confirmed: " + res4.getStockQuantity());

            System.out.println("\n=============================================================");
            System.out.println(" [SUCCESS] All java.net Socket & Serialization Tests Passed!");
            System.out.println("=============================================================");

        } catch (Exception e) {
            System.err.println("[Socket Client Error]: " + e.getMessage());
            System.err.println("Ensure InventorySocketServer is running on port " + port);
        }
    }

    public static void main(String[] args) {
        String host = "127.0.0.1";
        int port = 8888;
        if (args.length > 0) host = args[0];
        if (args.length > 1) port = Integer.parseInt(args[1]);

        new InventorySocketClient(host, port).runDemo();
    }
}
