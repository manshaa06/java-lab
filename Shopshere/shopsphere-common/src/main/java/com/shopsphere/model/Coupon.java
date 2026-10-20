package com.shopsphere.model;

import java.io.Serializable;
import java.sql.Date;

/**
 * Model class representing a Discount Coupon.
 */
public class Coupon implements Serializable {
    private static final long serialVersionUID = 1L;

    private int couponId;
    private String code;
    private String discountType; // 'PERCENTAGE', 'FLAT'
    private double discountValue;
    private double minimumOrder;
    private double maximumDiscount;
    private Date expiryDate;
    private String status; // 'ACTIVE', 'EXPIRED', 'DISABLED'

    public Coupon() {
        this.status = "ACTIVE";
    }

    public Coupon(int couponId, String code, String discountType, double discountValue,
                  double minimumOrder, double maximumDiscount, Date expiryDate, String status) {
        this.couponId = couponId;
        this.code = code;
        this.discountType = discountType;
        this.discountValue = discountValue;
        this.minimumOrder = minimumOrder;
        this.maximumDiscount = maximumDiscount;
        this.expiryDate = expiryDate;
        this.status = status;
    }

    public int getCouponId() {
        return couponId;
    }

    public void setCouponId(int couponId) {
        this.couponId = couponId;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getDiscountType() {
        return discountType;
    }

    public void setDiscountType(String discountType) {
        this.discountType = discountType;
    }

    public double getDiscountValue() {
        return discountValue;
    }

    public void setDiscountValue(double discountValue) {
        this.discountValue = discountValue;
    }

    public double getMinimumOrder() {
        return minimumOrder;
    }

    public void setMinimumOrder(double minimumOrder) {
        this.minimumOrder = minimumOrder;
    }

    public double getMaximumDiscount() {
        return maximumDiscount;
    }

    public void setMaximumDiscount(double maximumDiscount) {
        this.maximumDiscount = maximumDiscount;
    }

    public Date getExpiryDate() {
        return expiryDate;
    }

    public void setExpiryDate(Date expiryDate) {
        this.expiryDate = expiryDate;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public boolean isExpired() {
        if (expiryDate != null) {
            long now = System.currentTimeMillis();
            return expiryDate.getTime() < now;
        }
        return false;
    }

    public boolean isValidFor(double cartTotal) {
        if (!"ACTIVE".equalsIgnoreCase(status) || isExpired()) {
            return false;
        }
        return cartTotal >= minimumOrder;
    }

    public double calculateDiscount(double cartTotal) {
        if (!isValidFor(cartTotal)) {
            return 0.0;
        }
        double discount = 0.0;
        if ("PERCENTAGE".equalsIgnoreCase(discountType)) {
            discount = cartTotal * (discountValue / 100.0);
            if (discount > maximumDiscount && maximumDiscount > 0) {
                discount = maximumDiscount;
            }
        } else if ("FLAT".equalsIgnoreCase(discountType)) {
            discount = Math.min(discountValue, cartTotal);
        }
        return Math.round(discount * 100.0) / 100.0;
    }
}
