-- ========================================================
-- SHOPSPHERE E-COMMERCE DATABASE SCRIPT
-- RTU Advanced Java / Java Enterprise Laboratory Project
-- Compatible with MySQL 8.x / MariaDB 10.x
-- ========================================================

CREATE DATABASE IF NOT EXISTS shopsphere CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE shopsphere;

-- 1. USERS TABLE
DROP TABLE IF EXISTS coupon_usage;
DROP TABLE IF EXISTS coupons;
DROP TABLE IF EXISTS reviews;
DROP TABLE IF EXISTS payments;
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS wishlist;
DROP TABLE IF EXISTS cart;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS categories;
DROP TABLE IF EXISTS addresses;
DROP TABLE IF EXISTS users;

CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    mobile VARCHAR(20) NOT NULL,
    role VARCHAR(20) NOT NULL DEFAULT 'CUSTOMER', -- 'CUSTOMER', 'ADMIN'
    status VARCHAR(20) NOT NULL DEFAULT 'ACTIVE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- 2. ADDRESSES TABLE
CREATE TABLE addresses (
    address_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    address_line VARCHAR(255) NOT NULL,
    city VARCHAR(100) NOT NULL,
    state VARCHAR(100) NOT NULL,
    pincode VARCHAR(20) NOT NULL,
    address_type VARCHAR(20) NOT NULL DEFAULT 'HOME',
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- 3. CATEGORIES TABLE
CREATE TABLE categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    status VARCHAR(20) NOT NULL DEFAULT 'ACTIVE'
) ENGINE=InnoDB;

-- 4. PRODUCTS TABLE
CREATE TABLE products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    category_id INT NOT NULL,
    name VARCHAR(150) NOT NULL,
    brand VARCHAR(100) NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL,
    discount DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    stock INT NOT NULL DEFAULT 0,
    image_url VARCHAR(500),
    status BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES categories(category_id) ON DELETE RESTRICT
) ENGINE=InnoDB;

-- 5. CART TABLE
CREATE TABLE cart (
    cart_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE,
    UNIQUE KEY uq_user_product (user_id, product_id)
) ENGINE=InnoDB;

-- 6. WISHLIST TABLE
CREATE TABLE wishlist (
    wishlist_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    product_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE,
    UNIQUE KEY uq_wishlist_user_product (user_id, product_id)
) ENGINE=InnoDB;

-- 7. ORDERS TABLE
CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    address_id INT NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL,
    discount DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    payment_method VARCHAR(50) NOT NULL,
    payment_status VARCHAR(50) NOT NULL DEFAULT 'PAID',
    order_status VARCHAR(50) NOT NULL DEFAULT 'CONFIRMED', -- 'PENDING','CONFIRMED','SHIPPED','DELIVERED','CANCELLED'
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE RESTRICT,
    FOREIGN KEY (address_id) REFERENCES addresses(address_id) ON DELETE RESTRICT
) ENGINE=InnoDB;

-- 8. ORDER ITEMS TABLE
CREATE TABLE order_items (
    order_item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE RESTRICT
) ENGINE=InnoDB;

-- 9. PAYMENTS TABLE
CREATE TABLE payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    payment_method VARCHAR(50) NOT NULL,
    transaction_reference VARCHAR(100) NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    payment_status VARCHAR(50) NOT NULL DEFAULT 'COMPLETED',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- 10. REVIEWS TABLE
CREATE TABLE reviews (
    review_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    product_id INT NOT NULL,
    rating INT NOT NULL CHECK (rating >= 1 AND rating <= 5),
    review_text TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- 11. COUPONS TABLE
CREATE TABLE coupons (
    coupon_id INT AUTO_INCREMENT PRIMARY KEY,
    code VARCHAR(50) NOT NULL UNIQUE,
    discount_type VARCHAR(20) NOT NULL DEFAULT 'PERCENTAGE', -- 'PERCENTAGE', 'FLAT'
    discount_value DECIMAL(10,2) NOT NULL,
    minimum_order DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    maximum_discount DECIMAL(10,2) NOT NULL DEFAULT 500.00,
    expiry_date DATE NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'ACTIVE'
) ENGINE=InnoDB;

-- 12. COUPON USAGE TABLE
CREATE TABLE coupon_usage (
    usage_id INT AUTO_INCREMENT PRIMARY KEY,
    coupon_id INT NOT NULL,
    user_id INT NOT NULL,
    order_id INT NOT NULL,
    used_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (coupon_id) REFERENCES coupons(coupon_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- ========================================================
-- INITIAL SEED DATA
-- SHA-256 Password Hash Reference:
-- 'admin123'    -> 240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9
-- 'password123' -> ef92b778bafe771e89245b89ecbc08a44a4e166c06659911881f383d4473e94f
-- 'student123'  -> a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3
-- ========================================================

-- Insert Users
INSERT INTO users (user_id, name, email, password, mobile, role, status) VALUES
(1, 'Admin User', 'admin@shopsphere.com', '240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9', '9876543210', 'ADMIN', 'ACTIVE'),
(2, 'Nikhil Sharma', 'nikhil@shopsphere.com', 'ef92b778bafe771e89245b89ecbc08a44a4e166c06659911881f383d4473e94f', '9123456780', 'CUSTOMER', 'ACTIVE'),
(3, 'Student Scholar', 'student@shopsphere.com', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', '9988776655', 'CUSTOMER', 'ACTIVE');

-- Insert Addresses
INSERT INTO addresses (address_id, user_id, address_line, city, state, pincode, address_type) VALUES
(1, 2, 'Plot 42, Malviya Nagar, Sector 3', 'Jaipur', 'Rajasthan', '302017', 'HOME'),
(2, 2, 'Tech Park, Sitapura Industrial Area', 'Jaipur', 'Rajasthan', '302022', 'WORK'),
(3, 3, 'Campus Hostel Block B, RTU Campus', 'Kota', 'Rajasthan', '324010', 'HOME');

-- Insert Categories
INSERT INTO categories (category_id, name, description, status) VALUES
(1, 'Electronics & Gadgets', 'Smartphones, Laptops, Audio gear, and smart wearable accessories', 'ACTIVE'),
(2, 'Fashion & Apparel', 'Trendy wear, formal apparel, footwear, and designer collections', 'ACTIVE'),
(3, 'Home & Kitchen', 'Modern appliances, cookware, smart decor, and essentials', 'ACTIVE'),
(4, 'Books & Stationery', 'Computer Science, Engineering textbooks, notes, and fine stationery', 'ACTIVE'),
(5, 'Fitness & Sports', 'Workout equipment, activewear, sports kits, and supplements', 'ACTIVE');

-- Insert Products
INSERT INTO products (product_id, category_id, name, brand, description, price, discount, stock, image_url, status) VALUES
(1, 1, 'SphereBook Pro M3 Laptop', 'SphereTech', '15.6 inch Retina-grade 4K display, 32GB RAM, 1TB NVMe SSD, ultra-thin aluminum chassis.', 89999.00, 10.00, 18, 'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?auto=format&fit=crop&w=600&q=80', TRUE),
(2, 1, 'AuraSound Noise Cancelling Headphones', 'AuraSound', 'Active Hybrid Noise Cancellation, 40hr battery life, hi-res lossless spatial audio codec.', 12499.00, 15.00, 42, 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?auto=format&fit=crop&w=600&q=80', TRUE),
(3, 1, 'PulseSync Smart Health Watch V2', 'PulseTech', 'AMOLED display, 24/7 ECG & SpO2 tracking, Titanium bezel, 100+ sport modes with GPS.', 6999.00, 20.00, 35, 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=600&q=80', TRUE),
(4, 1, 'CyberPixel Ultra 5G Smartphone', 'CyberPixel', '6.8 inch 120Hz LTPO OLED, 200MP Triple camera, Snapdragon 8 Gen 3, 5000mAh battery.', 54999.00, 5.00, 15, 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?auto=format&fit=crop&w=600&q=80', TRUE),
(5, 2, 'Classic Tailored Oxford Shirt', 'Stitch & Co', '100% Egyptian breathable cotton, slim-fit silhouette, crease-resistant luxury fabric.', 2199.00, 25.00, 60, 'https://images.unsplash.com/photo-1596755094514-f87e34085b2c?auto=format&fit=crop&w=600&q=80', TRUE),
(6, 2, 'Urban Velocity Street Sneakers', 'AeroKicks', 'CloudFoam cushioning, responsive rubber grip, stylish breathable knitted upper.', 3899.00, 18.00, 28, 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?auto=format&fit=crop&w=600&q=80', TRUE),
(7, 3, 'SmartBrew Programmable Espresso Machine', 'BaristaPro', '19-bar Italian pressure pump, dual boiler heating, thermal milk frothing wand.', 15999.00, 12.00, 12, 'https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd?auto=format&fit=crop&w=600&q=80', TRUE),
(8, 3, 'AromaMist Ultrasonic Air Purifier', 'PureAir', 'HEPA H13 True filter, ambient RGB illumination, ultra-quiet 22dB sleep operation.', 4499.00, 10.00, 25, 'https://images.unsplash.com/photo-1585771724684-38269d6639fd?auto=format&fit=crop&w=600&q=80', TRUE),
(9, 4, 'Advanced Java: Enterprise & Distributed Systems', 'TechPress', 'Comprehensive textbook covering Servlets, JSP, EJB, JDBC, RMI, Sockets and Web Architecture.', 850.00, 10.00, 100, 'https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?auto=format&fit=crop&w=600&q=80', TRUE),
(10, 4, 'Executive Matte Fountain Pen Set', 'SignatureCraft', 'Hand-finished iridium nib, refillable converter, luxury weighted brass barrel in wooden case.', 1499.00, 15.00, 50, 'https://images.unsplash.com/photo-1583485088034-697b5bc54ccd?auto=format&fit=crop&w=600&q=80', TRUE),
(11, 5, 'FlexPro Adjustable Dumbbells Pair (24kg)', 'TitanGrip', 'Quick dial weight selector from 2.5kg to 24kg, anti-slip textured grip, compact tray.', 11999.00, 20.00, 14, 'https://images.unsplash.com/photo-1583454110551-21f2fa2afe61?auto=format&fit=crop&w=600&q=80', TRUE),
(12, 5, 'ProGrip Non-Slip Eco Yoga Mat', 'ZenithFit', '6mm high-density natural tree rubber, alignment guidelines, carrying strap included.', 1899.00, 20.00, 45, 'https://images.unsplash.com/photo-1601925260368-ae2f83cf8b7f?auto=format&fit=crop&w=600&q=80', TRUE);

-- Insert Coupons
INSERT INTO coupons (coupon_id, code, discount_type, discount_value, minimum_order, maximum_discount, expiry_date, status) VALUES
(1, 'WELCOME50', 'PERCENTAGE', 50.00, 999.00, 500.00, '2027-12-31', 'ACTIVE'),
(2, 'SHOP100', 'FLAT', 100.00, 499.00, 100.00, '2027-12-31', 'ACTIVE'),
(3, 'FESTIVE20', 'PERCENTAGE', 20.00, 1500.00, 1000.00, '2027-12-31', 'ACTIVE'),
(4, 'FREESHIP', 'FLAT', 50.00, 299.00, 50.00, '2027-12-31', 'ACTIVE');

-- Insert Sample Reviews
INSERT INTO reviews (review_id, user_id, product_id, rating, review_text) VALUES
(1, 2, 1, 5, 'Outstanding build quality and blistering fast performance. Handles Java IDEs and multi-tier servers effortlessly!'),
(2, 3, 2, 4, 'Great noise cancellation for campus library study sessions. Sound profile is warm and punchy.'),
(3, 2, 3, 5, 'Battery lasts over a week. The heart rate and sleep tracking sensors are spot on.'),
(4, 3, 9, 5, 'The best textbook for RTU Advanced Java examination. Explains RMI, JDBC and Servlets with lucid code examples.');

-- Insert Sample Orders for demonstration
INSERT INTO orders (order_id, user_id, address_id, total_amount, discount, payment_method, payment_status, order_status, created_at) VALUES
(1001, 2, 1, 10624.15, 500.00, 'UPI', 'PAID', 'DELIVERED', DATE_SUB(NOW(), INTERVAL 5 DAY)),
(1002, 2, 2, 3197.18, 100.00, 'CREDIT_CARD', 'PAID', 'SHIPPED', DATE_SUB(NOW(), INTERVAL 2 DAY)),
(1003, 3, 3, 765.00, 0.00, 'NET_BANKING', 'PAID', 'CONFIRMED', NOW());

-- Insert Order Items
INSERT INTO order_items (order_item_id, order_id, product_id, quantity, price) VALUES
(1, 1001, 2, 1, 10624.15),
(2, 1002, 6, 1, 3197.18),
(3, 1003, 9, 1, 765.00);

-- Insert Payments
INSERT INTO payments (payment_id, order_id, payment_method, transaction_reference, amount, payment_status) VALUES
(1, 1001, 'UPI', 'TXN-UPI-982341982', 10624.15, 'COMPLETED'),
(2, 1002, 'CREDIT_CARD', 'TXN-CC-487291034', 3197.18, 'COMPLETED'),
(3, 1003, 'NET_BANKING', 'TXN-NB-102938475', 765.00, 'COMPLETED');

-- Insert Sample Wishlist item
INSERT INTO wishlist (user_id, product_id) VALUES
(2, 1),
(2, 7),
(3, 10);

-- Insert Sample Cart item for student user
INSERT INTO cart (user_id, product_id, quantity) VALUES
(2, 3, 1),
(3, 2, 1);
