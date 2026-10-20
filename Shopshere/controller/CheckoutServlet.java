package com.shopsphere.controller;

import com.shopsphere.model.*;
import com.shopsphere.service.CartService;
import com.shopsphere.service.CheckoutService;
import com.shopsphere.service.UserService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

/**
 * Controller handling Order Checkout, Address Selection/Creation, and Atomic Order Placement.
 */
@WebServlet(name = "CheckoutServlet", urlPatterns = {"/checkout", "/place-order"})
public class CheckoutServlet extends HttpServlet {

    private CheckoutService checkoutService;
    private CartService cartService;
    private UserService userService;

    @Override
    public void init() throws ServletException {
        this.checkoutService = new CheckoutService();
        this.cartService = new CartService();
        this.userService = new UserService();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login?redirect=" + req.getContextPath() + "/checkout");
            return;
        }

        List<CartItem> cartItems = cartService.getCartItems(user.getUserId());
        if (cartItems.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/cart?error=Your+cart+is+empty");
            return;
        }

        String appliedCoupon = (String) session.getAttribute("appliedCoupon");
        CheckoutService.CheckoutSummary summary = checkoutService.calculateSummary(user.getUserId(), appliedCoupon);
        List<Address> addresses = userService.getUserAddresses(user.getUserId());

        req.setAttribute("cartItems", cartItems);
        req.setAttribute("summary", summary);
        req.setAttribute("addresses", addresses);

        req.getRequestDispatcher("/checkout.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String addressIdStr = req.getParameter("addressId");
        String paymentMethod = req.getParameter("paymentMethod");
        String appliedCoupon = (String) session.getAttribute("appliedCoupon");

        // Handle inline address addition if chosen
        int addressId = 0;
        if ("new".equalsIgnoreCase(addressIdStr) || addressIdStr == null || addressIdStr.trim().isEmpty()) {
            String addressLine = req.getParameter("newAddressLine");
            String city = req.getParameter("newCity");
            String state = req.getParameter("newState");
            String pincode = req.getParameter("newPincode");
            String addressType = req.getParameter("newAddressType");

            if (addressLine == null || city == null || state == null || pincode == null ||
                addressLine.trim().isEmpty() || city.trim().isEmpty() || pincode.trim().isEmpty()) {
                resp.sendRedirect(req.getContextPath() + "/checkout?error=Please+provide+complete+delivery+address");
                return;
            }

            Address addr = new Address();
            addr.setUserId(user.getUserId());
            addr.setAddressLine(addressLine.trim());
            addr.setCity(city.trim());
            addr.setState(state.trim());
            addr.setPincode(pincode.trim());
            addr.setAddressType(addressType != null ? addressType : "HOME");

            if (userService.addAddress(addr)) {
                addressId = addr.getAddressId();
            } else {
                resp.sendRedirect(req.getContextPath() + "/checkout?error=Failed+to+save+address");
                return;
            }
        } else {
            try {
                addressId = Integer.parseInt(addressIdStr.trim());
            } catch (NumberFormatException e) {
                resp.sendRedirect(req.getContextPath() + "/checkout?error=Invalid+address+selected");
                return;
            }
        }

        try {
            Order order = checkoutService.processCheckout(user.getUserId(), addressId, paymentMethod, appliedCoupon);
            if (order != null) {
                // Clear session coupon and reset cart count
                session.removeAttribute("appliedCoupon");
                session.setAttribute("cartCount", 0);

                resp.sendRedirect(req.getContextPath() + "/order-details?id=" + order.getOrderId() + "&success=Order+placed+successfully!");
            } else {
                resp.sendRedirect(req.getContextPath() + "/checkout?error=Could+not+complete+order+transaction");
            }
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/checkout?error=" + java.net.URLEncoder.encode(e.getMessage(), "UTF-8"));
        }
    }
}
