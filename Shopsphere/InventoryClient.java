package com.shopsphere.net;

import com.shopsphere.model.Product;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.net.Socket;
import java.util.List;
import java.util.Scanner;

/** Console client for InventoryServer. Type e.g.  GET_PRODUCT 1   GET_STOCK 2   SEARCH_PRODUCT java   QUIT */
public class InventoryClient {
    public static void main(String[] args) throws Exception {
        String host = args.length > 0 ? args[0] : "localhost";
        try (Socket socket = new Socket(host, InventoryServer.PORT);
             ObjectOutputStream out = new ObjectOutputStream(socket.getOutputStream())) {
            out.flush();
            ObjectInputStream in = new ObjectInputStream(socket.getInputStream());
            Scanner sc = new Scanner(System.in);
            System.out.println("Connected. Commands: GET_PRODUCT id | GET_STOCK id | SEARCH_PRODUCT text | QUIT");
            while (true) {
                System.out.print("> ");
                if (!sc.hasNextLine()) break;
                String line = sc.nextLine().trim();
                if (line.isEmpty()) continue;
                out.writeObject(line);
                out.flush();
                if (line.equalsIgnoreCase("QUIT")) break;
                Object reply = in.readObject();              // deserialization
                if (reply instanceof List<?>) {
                    for (Object o : (List<?>) reply) System.out.println("  " + (Product) o);
                } else {
                    System.out.println("  " + reply);
                }
            }
        }
    }
}
