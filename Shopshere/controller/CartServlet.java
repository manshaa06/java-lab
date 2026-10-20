package com.shopsphere.controller;

import com.shopsphere.model.CartItem;
import com.shopsphere.model.User;
import com.shopsphere.service.CartService;
import com.shopsphere.service.CheckoutService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

/**
 * Controller handling Shopping Cart operations: View, Add, Update, Remove, Coupon application.
 */
@WebServlet(name = "CartServlet", urlPatterns = {"/cart"})
public class CartServlet extends HttpServlet {

    private CartService cartService;
    private CheckoutService checkoutService;

    @Override
    public void init() throws ServletException {
        this.cartService = new CartService();
        this.checkoutService = new CheckoutService();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login?redirect=" + req.getContextPath() + "/cart");
            return;
        }

        List<CartItem> cartItems = cartService.getCartItems(user.getUserId());
        String appliedCoupon = (session != null) ? (String) session.getAttribute("appliedCoupon") : null;

        CheckoutService.CheckoutSummary summary = checkoutService.calculateSummary(user.getUserId(), appliedCoupon);

        // Synchronize cart count
        int count = 0;
        for (CartItem ci : cartItems) count += ci.getQuantity();
        session.setAttribute("cartCount", count);

        req.setAttribute("cartItems", cartItems);
        req.setAttribute("summary", summary);

        req.getRequestDispatcher("/cart.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login?redirect=" + req.getContextPath() + "/cart");
            return;
        }

        String action = req.getParameter("action");
        if (action == null) action = "view";

        switch (action) {
            case "add": {
                int productId = Integer.parseInt(req.getParameter("productId"));
                int quantity = 1;
                String qParam = req.getParameter("quantity");
                if (qParam != null) {
                    try {
                        quantity = Integer.parseInt(qParam.trim());
                    } catch (NumberFormatException ignored) {}
                }
                cartService.addToCart(user.getUserId(), productId, quantity);
                session.setAttribute("cartCount", cartService.getCartCount(user.getUserId()));
                resp.sendRedirect(req.getContextPath() + "/cart?success=Item+added+to+cart");
                break;
            }
            case "update": {
                int cartId = Integer.parseInt(req.getParameter("cartId"));
                int quantity = Integer.parseInt(req.getParameter("quantity"));
                cartService.updateCartQuantity(cartId, quantity);
                session.setAttribute("cartCount", cartService.getCartCount(user.getUserId()));
                resp.sendRedirect(req.getContextPath() + "/cart");
                break;
            }
            case "remove": {
                int cartId = Integer.parseInt(req.getParameter("cartId"));
                cartService.removeFromCart(cartId);
                session.setAttribute("cartCount", cartService.getCartCount(user.getUserId()));
                resp.sendRedirect(req.getContextPath() + "/cart?success=Item+removed+from+cart");
                break;
            }
            case "clear": {
                cartService.clearUserCart(user.getUserId());
                session.setAttribute("cartCount", 0);
                session.removeAttribute("appliedCoupon");
                resp.sendRedirect(req.getContextPath() + "/cart?success=Cart+cleared");
                break;
            }
            case "applyCoupon": {
                String code = req.getParameter("couponCode");
                if (code != null && !code.trim().isEmpty()) {
                    CheckoutService.CheckoutSummary test = checkoutService.calculateSummary(user.getUserId(), code);
                    if (test.getAppliedCoupon() != null) {
                        session.setAttribute("appliedCoupon", test.getAppliedCoupon().getCode());
                        resp.sendRedirect(req.getContextPath() + "/cart?success=" + java.net.URLEncoder.encode(test.getMessage(), "UTF-8"));
                        return;
                    } else {
                        resp.sendRedirect(req.getContextPath() + "/cart?error=" + java.net.URLEncoder.encode(test.getMessage(), "UTF-8"));
                        return;
                    }
                }
                resp.sendRedirect(req.getContextPath() + "/cart");
                break;
            }
            case "removeCoupon": {
                session.removeAttribute("appliedCoupon");
                resp.sendRedirect(req.getContextPath() + "/cart?success=Coupon+removed");
                break;
            }
            default:
                resp.sendRedirect(req.getContextPath() + "/cart");
        }
    }
}
