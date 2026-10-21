package com.shopsphere.rmi;

import com.shopsphere.model.Product;
import java.rmi.Remote;
import java.rmi.RemoteException;

/** Remote interface: every method throws RemoteException. */
public interface InventoryService extends Remote {
    Product getProduct(int id) throws RemoteException;
    int getStock(int productId) throws RemoteException;
    /** Sets the stock to the given quantity; returns true on success. */
    boolean updateStock(int productId, int quantity) throws RemoteException;
}
