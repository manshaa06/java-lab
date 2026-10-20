package com.shopsphere.rmi.server;

import com.shopsphere.dao.ProductDAO;
import com.shopsphere.model.Product;
import com.shopsphere.rmi.remote.InventoryService;

import java.rmi.RemoteException;
import java.rmi.server.UnicastRemoteObject;
import java.util.List;

/**
 * Remote Object Implementation for ShopSphere Inventory.
 * Extends UnicastRemoteObject to enable remote method invocation over TCP/IP.
 */
public class InventoryServiceImpl extends UnicastRemoteObject implements InventoryService {

    private static final long serialVersionUID = 1L;
    private final ProductDAO productDAO;

    public InventoryServiceImpl() throws RemoteException {
        super();
        this.productDAO = new ProductDAO();
    }

    @Override
    public Product getProduct(int id) throws RemoteException {
        System.out.println("[RMI Server] Remote call: getProduct(" + id + ")");
        return productDAO.findById(id);
    }

    @Override
    public int getStock(int productId) throws RemoteException {
        System.out.println("[RMI Server] Remote call: getStock(" + productId + ")");
        Product p = productDAO.findById(productId);
        return p != null ? p.getStock() : 0;
    }

    @Override
    public boolean updateStock(int productId, int quantity) throws RemoteException {
        System.out.println("[RMI Server] Remote call: updateStock(" + productId + ", " + quantity + ")");
        return productDAO.updateStock(productId, quantity);
    }

    @Override
    public List<Product> getAllProducts() throws RemoteException {
        System.out.println("[RMI Server] Remote call: getAllProducts()");
        return productDAO.getAll();
    }

    @Override
    public List<Product> getLowStockProducts(int threshold) throws RemoteException {
        System.out.println("[RMI Server] Remote call: getLowStockProducts(" + threshold + ")");
        return productDAO.getLowStock(threshold);
    }
}
