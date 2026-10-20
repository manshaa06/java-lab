package com.shopsphere.service;

import com.shopsphere.dao.AddressDAO;
import com.shopsphere.dao.UserDAO;
import com.shopsphere.model.Address;
import com.shopsphere.model.User;

import java.util.List;

/**
 * Service Layer for User management, authentication and profile operations.
 */
public class UserService {

    private final UserDAO userDAO = new UserDAO();
    private final AddressDAO addressDAO = new AddressDAO();

    public User login(String email, String password) {
        if (email == null || password == null || email.trim().isEmpty()) {
            return null;
        }
        return userDAO.authenticate(email.trim(), password);
    }

    public boolean registerCustomer(String name, String email, String password, String mobile) {
        if (email == null || password == null || name == null) {
            return false;
        }
        if (userDAO.findByEmail(email.trim()) != null) {
            return false; // Email already in use
        }

        User u = new User();
        u.setName(name.trim());
        u.setEmail(email.trim());
        u.setPassword(password);
        u.setMobile(mobile != null ? mobile.trim() : "");
        u.setRole("CUSTOMER");
        u.setStatus("ACTIVE");

        return userDAO.register(u);
    }

    public User getUserById(int userId) {
        return userDAO.findById(userId);
    }

    public List<User> getAllUsers() {
        return userDAO.getAllUsers();
    }

    public boolean toggleUserStatus(int userId, String newStatus) {
        return userDAO.updateStatus(userId, newStatus);
    }

    public boolean updateProfile(User user) {
        return userDAO.updateProfile(user);
    }

    public List<Address> getUserAddresses(int userId) {
        return addressDAO.getByUserId(userId);
    }

    public boolean addAddress(Address address) {
        return addressDAO.insert(address);
    }

    public boolean deleteAddress(int addressId, int userId) {
        return addressDAO.delete(addressId, userId);
    }
}
