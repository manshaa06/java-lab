package com.shopsphere.service;

import com.shopsphere.dao.*;
import com.shopsphere.model.*;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

/**
 * Service Layer for Checkout, Coupon Validation, and Atomic Order Placement.
 * Adheres to Section 26: Calculates all totals strictly on the server to prevent tamper.
 */
public class CheckoutService {

    private final CartDAO cartDAO = new CartDAO();
    private final CouponDAO couponDAO = new CouponDAO();
    private final OrderDAO orderDAO = new OrderDAO();
    private final ProductDAO productDAO = new ProductDAO();

    public static class CheckoutSummary {
        private double subtotal;
        private double discount;
        private double shippingFee;
        private double grandTotal;
        private Coupon appliedCoupon;
        private String message;

        public double getSubtotal() { return subtotal; }
        public void setSubtotal(double subtotal) { this.subtotal = subtotal; }
        public double getDiscount() { return discount; }
        public void setDiscount(double discount) { this.discount = discount; }
        public double getShippingFee() { return shippingFee; }
        public void setShippingFee(double shippingFee) { this.shippingFee = shippingFee; }
        public double getGrandTotal() { return grandTotal; }
        public void setGrandTotal(double grandTotal) { this.grandTotal = grandTotal; }
        public Coupon getAppliedCoupon() { return appliedCoupon; }
        public void setAppliedCoupon(Coupon appliedCoupon) { this.appliedCoupon = appliedCoupon; }
        public String getMessage() { return message; }
        public void setMessage(String message) { this.message = message; }
    }

    /**
     * Calculates validated order totals on the server side.
     */
    public CheckoutSummary calculateSummary(int userId, String couponCode) {
        CheckoutSummary summary = new CheckoutSummary();
        List<CartItem> items = cartDAO.getCartByUser(userId);

        double subtotal = 0.0;
        for (CartItem item : items) {
            subtotal += item.getSubtotal();
        }
        subtotal = Math.round(subtotal * 100.0) / 100.0;
        summary.setSubtotal(subtotal);

        double discount = 0.0;
        if (couponCode != null && !couponCode.trim().isEmpty()) {
            Coupon coupon = couponDAO.findByCode(couponCode.trim());
            if (coupon != null) {
                if (coupon.isValidFor(subtotal)) {
                    discount = coupon.calculateDiscount(subtotal);
                    summary.setAppliedCoupon(coupon);
                    summary.setMessage("Coupon " + coupon.getCode() + " applied successfully!");
                } else {
                    summary.setMessage("Coupon requires minimum order of ₹" + coupon.getMinimumOrder());
                }
            } else {
                summary.setMessage("Invalid or expired coupon code.");
            }
        }
        summary.setDiscount(discount);

        // Free shipping on orders above ₹1000, otherwise ₹50
        double shipping = (subtotal > 1000.0 || subtotal == 0.0) ? 0.0 : 50.0;
        summary.setShippingFee(shipping);

        double grandTotal = Math.max(0.0, subtotal - discount + shipping);
        summary.setGrandTotal(Math.round(grandTotal * 100.0) / 100.0);

        return summary;
    }

    /**
     * Places the order atomically using server-side validated cart contents and prices.
     */
    public Order processCheckout(int userId, int addressId, String paymentMethod, String couponCode) {
        List<CartItem> cartItems = cartDAO.getCartByUser(userId);
        if (cartItems == null || cartItems.isEmpty()) {
            return null;
        }

        // Verify stock availability
        for (CartItem ci : cartItems) {
            Product p = productDAO.findById(ci.getProductId());
            if (p == null || p.getStock() < ci.getQuantity()) {
                throw new IllegalStateException("Product " + (p != null ? p.getName() : "") + " is out of stock.");
            }
        }

        CheckoutSummary summary = calculateSummary(userId, couponCode);

        // Construct Order
        Order order = new Order();
        order.setUserId(userId);
        order.setAddressId(addressId);
        order.setTotalAmount(summary.getGrandTotal());
        order.setDiscount(summary.getDiscount());
        order.setPaymentMethod(paymentMethod != null ? paymentMethod : "UPI");
        order.setPaymentStatus("PAID");
        order.setOrderStatus("CONFIRMED");

        // Convert cart items to OrderItems
        List<OrderItem> orderItems = new ArrayList<>();
        for (CartItem ci : cartItems) {
            OrderItem oi = new OrderItem();
            oi.setProductId(ci.getProductId());
            oi.setQuantity(ci.getQuantity());
            oi.setPrice(ci.getProduct().getDiscountedPrice());
            orderItems.add(oi);
        }

        // Create Payment record
        Payment payment = new Payment();
        payment.setPaymentMethod(order.getPaymentMethod());
        payment.setTransactionReference("TXN-" + System.currentTimeMillis() + "-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase());
        payment.setAmount(order.getTotalAmount());
        payment.setPaymentStatus("COMPLETED");

        Integer couponId = (summary.getAppliedCoupon() != null) ? summary.getAppliedCoupon().getCouponId() : null;

        boolean success = orderDAO.placeOrder(order, orderItems, payment, couponId);
        if (success) {
            return order;
        }
        return null;
    }

    public List<Coupon> getAllCoupons() {
        return couponDAO.getAll();
    }

    public boolean addCoupon(Coupon coupon) {
        return couponDAO.insert(coupon);
    }

    public boolean deleteCoupon(int couponId) {
        return couponDAO.delete(couponId);
    }
}
