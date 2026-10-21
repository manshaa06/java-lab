package com.shopsphere.rmi;

import com.shopsphere.dao.ProductDao;
import com.shopsphere.model.Product;
import java.rmi.RemoteException;
import java.rmi.server.UnicastRemoteObject;
import java.sql.SQLException;

/** Remote object: exported through UnicastRemoteObject; talks to MySQL through the DAO. */
public class InventoryServiceImpl extends UnicastRemoteObject implements InventoryService {
    private final ProductDao dao = new ProductDao();

    public InventoryServiceImpl() throws RemoteException {
        super();
    }

    @Override
    public Product getProduct(int id) throws RemoteException {
        try { return dao.findById(id); }
        catch (SQLException e) { throw new RemoteException("Database error: " + e.getMessage(), e); }
    }

    @Override
    public int getStock(int productId) throws RemoteException {
        Product p = getProduct(productId);
        if (p == null) throw new RemoteException("No such product: " + productId);
        return p.getStock();
    }

    @Override
    public boolean updateStock(int productId, int quantity) throws RemoteException {
        try { return dao.updateStock(productId, quantity); }
        catch (SQLException e) { throw new RemoteException("Database error: " + e.getMessage(), e); }
    }
}
