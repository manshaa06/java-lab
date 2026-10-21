package com.shopsphere.model;

import java.io.Serializable;

/**
 * Serializable product. Instances travel over the Socket module (ObjectOutputStream)
 * and over RMI (as a return value), which demonstrates Java object serialization.
 */
public class Product implements Serializable {
    private static final long serialVersionUID = 1L;

    private int productId, categoryId, stock;
    private String name, brand, description, imageUrl, categoryName;
    private double price, discount;
    private boolean status = true;

    public double getFinalPrice() { return Math.round(price * (100 - discount)) / 100.0; }

    public int getProductId() { return productId; }
    public void setProductId(int productId) { this.productId = productId; }
    public int getCategoryId() { return categoryId; }
    public void setCategoryId(int categoryId) { this.categoryId = categoryId; }
    public int getStock() { return stock; }
    public void setStock(int stock) { this.stock = stock; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getBrand() { return brand; }
    public void setBrand(String brand) { this.brand = brand; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }
    public String getCategoryName() { return categoryName; }
    public void setCategoryName(String categoryName) { this.categoryName = categoryName; }
    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }
    public double getDiscount() { return discount; }
    public void setDiscount(double discount) { this.discount = discount; }
    public boolean isStatus() { return status; }
    public void setStatus(boolean status) { this.status = status; }

    @Override
    public String toString() {
        return "#" + productId + " " + name + " | Rs " + getFinalPrice() + " | stock " + stock;
    }
}
