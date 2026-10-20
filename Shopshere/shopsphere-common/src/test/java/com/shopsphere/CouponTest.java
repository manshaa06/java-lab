package com.shopsphere;

import com.shopsphere.model.Coupon;
import com.shopsphere.util.PasswordUtil;
import org.junit.jupiter.api.Test;

import java.sql.Date;

import static org.junit.jupiter.api.Assertions.*;

public class CouponTest {

    @Test
    public void testPercentageCouponCalculation() {
        Coupon c = new Coupon(1, "WELCOME50", "PERCENTAGE", 50.0, 999.0, 500.0,
                Date.valueOf("2028-12-31"), "ACTIVE");

        // Below minimum order
        assertFalse(c.isValidFor(500.0));
        assertEquals(0.0, c.calculateDiscount(500.0));

        // Above minimum order, capped at maximum discount (500)
        assertTrue(c.isValidFor(1500.0));
        assertEquals(500.0, c.calculateDiscount(1500.0));

        // Percentage under cap
        assertEquals(500.0, c.calculateDiscount(1000.0));
    }

    @Test
    public void testFlatCouponCalculation() {
        Coupon c = new Coupon(2, "SHOP100", "FLAT", 100.0, 499.0, 100.0,
                Date.valueOf("2028-12-31"), "ACTIVE");

        assertTrue(c.isValidFor(500.0));
        assertEquals(100.0, c.calculateDiscount(500.0));
    }

    @Test
    public void testPasswordHashing() {
        String raw = "student123";
        String hashed = PasswordUtil.hashPassword(raw);
        assertNotNull(hashed);
        assertEquals(64, hashed.length()); // SHA-256 produces 64 hex characters
        assertTrue(PasswordUtil.verifyPassword(raw, hashed));
        assertFalse(PasswordUtil.verifyPassword("wrongpass", hashed));
    }
}
