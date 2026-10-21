-- ShopSphere database (MySQL 8+)
-- Run:  mysql -u root -p < shopsphere.sql
CREATE DATABASE IF NOT EXISTS shopsphere CHARACTER SET utf8mb4;
USE shopsphere;

DROP TABLE IF EXISTS coupon_usage, payments, reviews, order_items, orders, wishlist, cart, products, categories, addresses, coupons, users;

CREATE TABLE users (
  user_id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  email VARCHAR(120) NOT NULL UNIQUE,
  password VARCHAR(200) NOT NULL,
  mobile VARCHAR(15),
  role VARCHAR(10) NOT NULL DEFAULT 'CUSTOMER',
  status BOOLEAN NOT NULL DEFAULT TRUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE addresses (
  address_id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  address_line VARCHAR(255) NOT NULL,
  city VARCHAR(80) NOT NULL,
  state VARCHAR(80) NOT NULL,
  pincode VARCHAR(10) NOT NULL,
  address_type VARCHAR(20) DEFAULT 'HOME',
  FOREIGN KEY (user_id) REFERENCES users(user_id)
);
CREATE TABLE categories (
  category_id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(80) NOT NULL,
  description VARCHAR(255),
  status BOOLEAN NOT NULL DEFAULT TRUE
);
CREATE TABLE products (
  product_id INT AUTO_INCREMENT PRIMARY KEY,
  category_id INT NOT NULL,
  name VARCHAR(150) NOT NULL,
  brand VARCHAR(80),
  description TEXT,
  price DECIMAL(10,2) NOT NULL,
  discount DECIMAL(5,2) NOT NULL DEFAULT 0,
  stock INT NOT NULL DEFAULT 0,
  image_url VARCHAR(300),
  status BOOLEAN NOT NULL DEFAULT TRUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (category_id) REFERENCES categories(category_id)
);
CREATE TABLE cart (
  cart_id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  product_id INT NOT NULL,
  quantity INT NOT NULL DEFAULT 1,
  UNIQUE KEY uq_cart (user_id, product_id),
  FOREIGN KEY (user_id) REFERENCES users(user_id),
  FOREIGN KEY (product_id) REFERENCES products(product_id)
);
CREATE TABLE wishlist (
  wishlist_id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  product_id INT NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(user_id),
  FOREIGN KEY (product_id) REFERENCES products(product_id)
);
CREATE TABLE orders (
  order_id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  address_id INT NOT NULL,
  total_amount DECIMAL(10,2) NOT NULL,
  discount DECIMAL(10,2) NOT NULL DEFAULT 0,
  payment_method VARCHAR(20) NOT NULL,
  payment_status VARCHAR(20) NOT NULL,
  order_status VARCHAR(20) NOT NULL DEFAULT 'PLACED',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(user_id),
  FOREIGN KEY (address_id) REFERENCES addresses(address_id)
);
CREATE TABLE order_items (
  order_item_id INT AUTO_INCREMENT PRIMARY KEY,
  order_id INT NOT NULL,
  product_id INT NOT NULL,
  quantity INT NOT NULL,
  price DECIMAL(10,2) NOT NULL,
  FOREIGN KEY (order_id) REFERENCES orders(order_id),
  FOREIGN KEY (product_id) REFERENCES products(product_id)
);
CREATE TABLE payments (
  payment_id INT AUTO_INCREMENT PRIMARY KEY,
  order_id INT NOT NULL,
  payment_method VARCHAR(20) NOT NULL,
  transaction_reference VARCHAR(60),
  amount DECIMAL(10,2) NOT NULL,
  payment_status VARCHAR(20) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (order_id) REFERENCES orders(order_id)
);
CREATE TABLE reviews (
  review_id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  product_id INT NOT NULL,
  rating INT NOT NULL,
  review_text VARCHAR(500),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(user_id),
  FOREIGN KEY (product_id) REFERENCES products(product_id)
);
CREATE TABLE coupons (
  coupon_id INT AUTO_INCREMENT PRIMARY KEY,
  code VARCHAR(30) NOT NULL UNIQUE,
  discount_type VARCHAR(10) NOT NULL,
  discount_value DECIMAL(10,2) NOT NULL,
  minimum_order DECIMAL(10,2) NOT NULL DEFAULT 0,
  maximum_discount DECIMAL(10,2) NOT NULL DEFAULT 0,
  expiry_date DATE NOT NULL,
  status BOOLEAN NOT NULL DEFAULT TRUE
);
CREATE TABLE coupon_usage (
  usage_id INT AUTO_INCREMENT PRIMARY KEY,
  coupon_id INT NOT NULL,
  user_id INT NOT NULL,
  order_id INT NOT NULL,
  used_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (coupon_id) REFERENCES coupons(coupon_id),
  FOREIGN KEY (user_id) REFERENCES users(user_id),
  FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

-- Seed data. Passwords are PBKDF2 hashes.
-- admin@shopsphere.com / admin123    user@shopsphere.com / user123
INSERT INTO users (name,email,password,mobile,role) VALUES
 ('Admin','admin@shopsphere.com','2f70a48be032a0e87b3dc7865f6f363b:cdb72a9f1b7d2a04d56d59836e038b44d7cd8e2ff40b4b972d5fd315dbff3444','9999999999','ADMIN'),
 ('Demo User','user@shopsphere.com','37fe6238116ed35deae91b7f3458e1b1:c55a4a70b452971c198813d8643c484d3d81bfa3e50092e6f31910fcd64718f2','8888888888','CUSTOMER');

INSERT INTO categories (name,description) VALUES
 ('Electronics','Phones, headphones and gadgets'),
 ('Fashion','Clothing and accessories'),
 ('Books','Study and reading books'),
 ('Home','Home and kitchen essentials');

INSERT INTO products (category_id,name,brand,description,price,discount,stock,image_url) VALUES
 (1,'Wireless Headphones','SoundMax','Bluetooth over-ear headphones with 30 hour battery.',2999,20,25,'https://placehold.co/400x300?text=Headphones'),
 (1,'Smart Watch','FitPro','Heart-rate and sleep tracking smart watch.',4499,10,15,'https://placehold.co/400x300?text=Smart+Watch'),
 (1,'Power Bank 10000mAh','ChargeUp','Fast charging power bank.',1299,5,50,'https://placehold.co/400x300?text=Power+Bank'),
 (2,'Cotton T-Shirt','UrbanWear','Soft cotton round-neck t-shirt.',599,15,100,'https://placehold.co/400x300?text=T-Shirt'),
 (2,'Running Shoes','StrideX','Lightweight running shoes.',2499,25,30,'https://placehold.co/400x300?text=Shoes'),
 (3,'Advanced Java Programming','TechPress','Servlets, JSP, JDBC, RMI and more.',699,10,40,'https://placehold.co/400x300?text=Java+Book'),
 (3,'Database System Concepts','TechPress','Relational databases and SQL.',899,0,3,'https://placehold.co/400x300?text=DBMS+Book'),
 (4,'Steel Water Bottle','HomeCare','1 litre insulated steel bottle.',499,0,60,'https://placehold.co/400x300?text=Bottle');

INSERT INTO coupons (code,discount_type,discount_value,minimum_order,maximum_discount,expiry_date) VALUES
 ('WELCOME10','PERCENT',10,500,300,'2030-12-31'),
 ('SAVE100','FLAT',100,1000,100,'2030-12-31');
