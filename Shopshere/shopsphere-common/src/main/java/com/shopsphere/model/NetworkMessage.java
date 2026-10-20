package com.shopsphere.model;

import java.io.Serializable;
import java.util.List;

/**
 * Message wrapper object transmitted over java.net Sockets using ObjectOutputStream/ObjectInputStream.
 * Demonstrates Java Object Serialization as per the RTU syllabus.
 */
public class NetworkMessage implements Serializable {
    private static final long serialVersionUID = 1L;

    public enum Command {
        GET_PRODUCT,
        GET_STOCK,
        SEARCH_PRODUCT,
        UPDATE_STOCK,
        LIST_ALL,
        RESPONSE_SUCCESS,
        RESPONSE_ERROR
    }

    private Command command;
    private int productId;
    private int stockQuantity;
    private String query;
    private String message;
    private boolean success;

    // Serialized payload objects
    private Product product;
    private List<Product> productList;

    public NetworkMessage() {}

    public NetworkMessage(Command command) {
        this.command = command;
    }

    public static NetworkMessage success(String message) {
        NetworkMessage msg = new NetworkMessage(Command.RESPONSE_SUCCESS);
        msg.setSuccess(true);
        msg.setMessage(message);
        return msg;
    }

    public static NetworkMessage error(String message) {
        NetworkMessage msg = new NetworkMessage(Command.RESPONSE_ERROR);
        msg.setSuccess(false);
        msg.setMessage(message);
        return msg;
    }

    public Command getCommand() {
        return command;
    }

    public void setCommand(Command command) {
        this.command = command;
    }

    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public int getStockQuantity() {
        return stockQuantity;
    }

    public void setStockQuantity(int stockQuantity) {
        this.stockQuantity = stockQuantity;
    }

    public String getQuery() {
        return query;
    }

    public void setQuery(String query) {
        this.query = query;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public boolean isSuccess() {
        return success;
    }

    public void setSuccess(boolean success) {
        this.success = success;
    }

    public Product getProduct() {
        return product;
    }

    public void setProduct(Product product) {
        this.product = product;
    }

    public List<Product> getProductList() {
        return productList;
    }

    public void setProductList(List<Product> productList) {
        this.productList = productList;
    }

    @Override
    public String toString() {
        return "NetworkMessage{" +
                "command=" + command +
                ", productId=" + productId +
                ", success=" + success +
                ", message='" + message + '\'' +
                '}';
    }
}
