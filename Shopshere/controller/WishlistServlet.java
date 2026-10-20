package com.shopsphere.controller;

import com.shopsphere.model.User;
import com.shopsphere.model.WishlistItem;
import com.shopsphere.service.CartService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

/**
 * Controller handling Wishlist operations.
 */
@WebServlet(name = "WishlistServlet", urlPatterns = {"/wishlist"})
public class WishlistServlet extends HttpServlet {

    private CartService cartService;

    @Override
    public void init() throws ServletException {
        this.cartService = new CartService();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login?redirect=" + req.getContextPath() + "/wishlist");
            return;
        }

        List<WishlistItem> wishlist = cartService.getWishlist(user.getUserId());
        req.setAttribute("wishlist", wishlist);
        req.getRequestDispatcher("/wishlist.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login?redirect=" + req.getContextPath() + "/wishlist");
            return;
        }

        String action = req.getParameter("action");
        int productId = Integer.parseInt(req.getParameter("productId"));

        if ("remove".equals(action)) {
            cartService.removeFromWishlist(user.getUserId(), productId);
            resp.sendRedirect(req.getContextPath() + "/wishlist?success=Item+removed+from+wishlist");
        } else if ("moveToCart".equals(action)) {
            cartService.addToCart(user.getUserId(), productId, 1);
            cartService.removeFromWishlist(user.getUserId(), productId);
            session.setAttribute("cartCount", cartService.getCartCount(user.getUserId()));
            resp.sendRedirect(req.getContextPath() + "/cart?success=Item+moved+to+cart");
        } else {
            // Default: add
            cartService.addToWishlist(user.getUserId(), productId);
            resp.sendRedirect(req.getContextPath() + "/wishlist?success=Item+saved+to+wishlist");
        }
    }
}
