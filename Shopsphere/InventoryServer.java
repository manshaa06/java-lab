package com.shopsphere.net;

import com.shopsphere.dao.ProductDao;
import com.shopsphere.model.Product;
import java.io.*;
import java.net.ServerSocket;
import java.net.Socket;
import java.util.ArrayList;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

/**
 * java.net demo: TCP inventory server.
 * Protocol: the client writes a command String, the server answers with a serialized object
 * (Product, Integer, ArrayList&lt;Product&gt; or an error String).
 * Commands: GET_PRODUCT id | GET_STOCK id | SEARCH_PRODUCT text | QUIT
 */
public class InventoryServer {
    public static final int PORT = 5050;
    private static final ProductDao dao = new ProductDao();

    public static void main(String[] args) throws IOException {
        ExecutorService pool = Executors.newFixedThreadPool(8);
        try (ServerSocket server = new ServerSocket(PORT)) {
            System.out.println("Inventory server listening on port " + PORT);
            while (true) {
                Socket client = server.accept();                 // blocks until a client connects
                System.out.println("Client connected: " + client.getRemoteSocketAddress());
                pool.submit(() -> handle(client));
            }
        }
    }

    private static void handle(Socket socket) {
        try (Socket s = socket;
             ObjectOutputStream out = new ObjectOutputStream(s.getOutputStream())) {
            out.flush();
            try (ObjectInputStream in = new ObjectInputStream(s.getInputStream())) {
                while (true) {
                    String command = (String) in.readObject();
                    if (command == null || command.equalsIgnoreCase("QUIT")) break;
                    out.writeObject(process(command.trim()));
                    out.flush();
                    out.reset();
                }
            }
        } catch (EOFException e) {
            // client closed the connection
        } catch (Exception e) {
            System.out.println("Connection error: " + e.getMessage());
        }
    }

    private static Object process(String command) {
        try {
            String[] parts = command.split("\\s+", 2);
            String name = parts[0].toUpperCase();
            String arg = parts.length > 1 ? parts[1] : "";
            switch (name) {
                case "GET_PRODUCT": {
                    Product p = dao.findById(Integer.parseInt(arg));
                    return p != null ? p : "ERROR: product not found";
                }
                case "GET_STOCK": {
                    Product p = dao.findById(Integer.parseInt(arg));
                    return p != null ? (Object) Integer.valueOf(p.getStock()) : "ERROR: product not found";
                }
                case "SEARCH_PRODUCT":
                    return new ArrayList<>(dao.search(arg));
                default:
                    return "ERROR: unknown command";
            }
        } catch (NumberFormatException e) {
            return "ERROR: id must be a number";
        } catch (Exception e) {
            return "ERROR: " + e.getMessage();
        }
    }
}
