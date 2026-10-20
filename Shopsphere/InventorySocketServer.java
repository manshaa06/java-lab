package com.shopsphere.network.server;

import com.shopsphere.dao.ProductDAO;
import com.shopsphere.model.NetworkMessage;
import com.shopsphere.model.Product;

import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.net.ServerSocket;
import java.net.Socket;
import java.util.List;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

/**
 * Multithreaded Inventory Socket Server using java.net.ServerSocket and Java Object Serialization.
 * RTU Advanced Java Syllabus Topic: java.net Networking & Object Serialization.
 */
public class InventorySocketServer {

    public static final int DEFAULT_PORT = 8888;
    private final int port;
    private final ProductDAO productDAO;
    private final ExecutorService threadPool;
    private volatile boolean running = true;

    public InventorySocketServer(int port) {
        this.port = port;
        this.productDAO = new ProductDAO();
        this.threadPool = Executors.newCachedThreadPool();
    }

    public void start() {
        System.out.println("=============================================================");
        System.out.println(" [ShopSphere Socket Server] Starting on port " + port);
        System.out.println(" Protocol: Java Object Serialization (ObjectOutputStream/InputStream)");
        System.out.println(" Commands: GET_PRODUCT, GET_STOCK, UPDATE_STOCK, SEARCH_PRODUCT, LIST_ALL");
        System.out.println("=============================================================");

        try (ServerSocket serverSocket = new ServerSocket(port)) {
            while (running) {
                try {
                    Socket clientSocket = serverSocket.accept();
                    System.out.println("[Socket Server] Accepted client connection from: " + clientSocket.getRemoteSocketAddress());
                    threadPool.submit(new ClientHandler(clientSocket));
                } catch (IOException e) {
                    if (!running) break;
                    System.err.println("[Socket Server] Error accepting client: " + e.getMessage());
                }
            }
        } catch (IOException e) {
            System.err.println("[Socket Server] Failed to bind ServerSocket on port " + port + ": " + e.getMessage());
        } finally {
            threadPool.shutdown();
        }
    }

    public void stop() {
        this.running = false;
        this.threadPool.shutdownNow();
    }

    /**
     * Runnable handler servicing an individual socket client.
     */
    private class ClientHandler implements Runnable {
        private final Socket socket;

        public ClientHandler(Socket socket) {
            this.socket = socket;
        }

        @Override
        public void run() {
            try (ObjectOutputStream oos = new ObjectOutputStream(socket.getOutputStream());
                 ObjectInputStream ois = new ObjectInputStream(socket.getInputStream())) {

                oos.flush(); // Flush stream header

                while (!socket.isClosed()) {
                    Object receivedObj;
                    try {
                        receivedObj = ois.readObject();
                    } catch (ClassNotFoundException e) {
                        System.err.println("[ClientHandler] Unknown class received: " + e.getMessage());
                        break;
                    } catch (IOException e) {
                        // Client closed connection
                        break;
                    }

                    if (receivedObj instanceof NetworkMessage) {
                        NetworkMessage request = (NetworkMessage) receivedObj;
                        NetworkMessage response = processRequest(request);
                        oos.writeObject(response);
                        oos.flush();
                        System.out.println("[ClientHandler] Handled command: " + request.getCommand() + " -> Response sent.");
                    }
                }
            } catch (IOException e) {
                // Client disconnected
            } finally {
                try {
                    socket.close();
                } catch (IOException ignored) {}
            }
        }

        private NetworkMessage processRequest(NetworkMessage request) {
            if (request == null || request.getCommand() == null) {
                return NetworkMessage.error("Null or malformed request");
            }

            switch (request.getCommand()) {
                case GET_PRODUCT: {
                    Product p = productDAO.findById(request.getProductId());
                    if (p != null) {
                        NetworkMessage resp = NetworkMessage.success("Product found");
                        resp.setProduct(p);
                        return resp;
                    } else {
                        return NetworkMessage.error("Product with ID " + request.getProductId() + " not found.");
                    }
                }
                case GET_STOCK: {
                    Product p = productDAO.findById(request.getProductId());
                    if (p != null) {
                        NetworkMessage resp = NetworkMessage.success("Stock retrieved");
                        resp.setStockQuantity(p.getStock());
                        return resp;
                    } else {
                        return NetworkMessage.error("Product not found");
                    }
                }
                case UPDATE_STOCK: {
                    boolean ok = productDAO.updateStock(request.getProductId(), request.getStockQuantity());
                    if (ok) {
                        NetworkMessage resp = NetworkMessage.success("Stock updated to " + request.getStockQuantity());
                        resp.setStockQuantity(request.getStockQuantity());
                        return resp;
                    } else {
                        return NetworkMessage.error("Failed to update stock for Product #" + request.getProductId());
                    }
                }
                case SEARCH_PRODUCT: {
                    List<Product> matches = productDAO.search(request.getQuery(), null, null, null, null);
                    NetworkMessage resp = NetworkMessage.success("Search completed (" + matches.size() + " matches)");
                    resp.setProductList(matches);
                    return resp;
                }
                case LIST_ALL: {
                    List<Product> all = productDAO.getAll();
                    NetworkMessage resp = NetworkMessage.success("All products retrieved");
                    resp.setProductList(all);
                    return resp;
                }
                default:
                    return NetworkMessage.error("Unsupported command: " + request.getCommand());
            }
        }
    }

    public static void main(String[] args) {
        int port = DEFAULT_PORT;
        if (args.length > 0) {
            try {
                port = Integer.parseInt(args[0]);
            } catch (NumberFormatException ignored) {}
        }
        new InventorySocketServer(port).start();
    }
}
