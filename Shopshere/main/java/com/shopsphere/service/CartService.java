package com.shopsphere.service;

import com.shopsphere.dao.CartDAO;
import com.shopsphere.dao.WishlistDAO;
import com.shopsphere.model.CartItem;
import com.shopsphere.model.WishlistItem;

import java.util.List;

/**
 * Service Layer for Shopping Cart and Wishlist operations.
 */
public class CartService {

    private final CartDAO cartDAO = new CartDAO();
    private final WishlistDAO wishlistDAO = new WishlistDAO();

    public List<CartItem> getCartItems(int userId) {
        return cartDAO.getCartByUser(userId);
    }

    public boolean addToCart(int userId, int productId, int quantity) {
        return cartDAO.addToCart(userId, productId, quantity);
    }

    public boolean updateCartQuantity(int cartId, int quantity) {
        return cartDAO.updateQuantity(cartId, quantity);
    }

    public boolean removeFromCart(int cartId) {
        return cartDAO.removeFromCart(cartId);
    }

    public boolean clearUserCart(int userId) {
        return cartDAO.clearCart(userId);
    }

    public int getCartCount(int userId) {
        return cartDAO.getCartCount(userId);
    }

    public double calculateCartSubtotal(List<CartItem> items) {
        double subtotal = 0.0;
        if (items != null) {
            for (CartItem item : items) {
                subtotal += item.getSubtotal();
            }
        }
        return Math.round(subtotal * 100.0) / 100.0;
    }

    public List<WishlistItem> getWishlist(int userId) {
        return wishlistDAO.getWishlistByUser(userId);
    }

    public boolean addToWishlist(int userId, int productId) {
        return wishlistDAO.addToWishlist(userId, productId);
    }

    public boolean removeFromWishlist(int userId, int productId) {
        return wishlistDAO.removeFromWishlist(userId, productId);
    }

    public boolean isInWishlist(int userId, int productId) {
        return wishlistDAO.isInWishlist(userId, productId);
    }
}
