package com.shopsphere.rmi.remote;

import com.shopsphere.model.Product;

import java.rmi.Remote;
import java.rmi.RemoteException;
import java.util.List;

/**
 * Remote Interface for ShopSphere Remote Inventory Service.
 * RTU Advanced Java Syllabus Topic: Java RMI Architecture & Remote Interface.
 */
public interface InventoryService extends Remote {

    Product getProduct(int id) throws RemoteException;

    int getStock(int productId) throws RemoteException;

    boolean updateStock(int productId, int quantity) throws RemoteException;

    List<Product> getAllProducts() throws RemoteException;

    List<Product> getLowStockProducts(int threshold) throws RemoteException;
}
