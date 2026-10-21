package com.shopsphere.swing.controller;

import com.shopsphere.dao.ProductDao;
import com.shopsphere.model.Product;
import com.shopsphere.rmi.InventoryService;
import com.shopsphere.rmi.RmiServer;
import com.shopsphere.swing.view.ProductFrame;
import com.shopsphere.swing.view.ProductFrame.CategoryItem;
import java.rmi.Naming;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import javax.swing.JOptionPane;

/** MVC "Controller": connects ProductFrame (view) with ProductDao (data access). */
public class ProductController {
    private final ProductFrame view;
    private final ProductDao dao;

    public ProductController(ProductFrame view, ProductDao dao) {
        this.view = view;
        this.dao = dao;
        loadCategories();
        refresh();

        view.refreshButton.addActionListener(e -> refresh());
        view.allRadio.addActionListener(e -> refresh());
        view.activeRadio.addActionListener(e -> refresh());
        view.lowRadio.addActionListener(e -> refresh());
        view.addButton.addActionListener(e -> save(true));
        view.updateButton.addActionListener(e -> save(false));
        view.deleteButton.addActionListener(e -> delete());
        view.clearButton.addActionListener(e -> clearForm());
        view.rmiButton.addActionListener(e -> checkStockViaRmi());
        view.table.getSelectionModel().addListSelectionListener(e -> {
            if (!e.getValueIsAdjusting()) fillForm();
        });
    }

    private void loadCategories() {
        try {
            Map<Integer, String> cats = dao.categories();
            for (Map.Entry<Integer, String> en : cats.entrySet())
                view.categoryBox.addItem(new CategoryItem(en.getKey(), en.getValue()));
        } catch (SQLException ex) {
            error(ex);
        }
    }

    private void refresh() {
        try {
            List<Product> all = dao.findAll();
            List<Product> shown = new ArrayList<>();
            for (Product p : all) {
                if (view.activeRadio.isSelected() && !p.isStatus()) continue;
                if (view.lowRadio.isSelected() && p.getStock() > 5) continue;
                shown.add(p);
            }
            view.tableModel.setRows(shown);
        } catch (SQLException ex) {
            error(ex);
        }
    }

    private Product selected() {
        int row = view.table.getSelectedRow();
        if (row < 0) return null;
        return view.tableModel.getProductAt(view.table.convertRowIndexToModel(row));
    }

    private void fillForm() {
        Product p = selected();
        if (p == null) return;
        view.nameField.setText(p.getName());
        view.brandField.setText(p.getBrand());
        view.priceField.setText(String.valueOf(p.getPrice()));
        view.discountField.setText(String.valueOf(p.getDiscount()));
        view.stockField.setText(String.valueOf(p.getStock()));
        view.imageField.setText(p.getImageUrl());
        view.activeBox.setSelected(p.isStatus());
        for (int i = 0; i < view.categoryBox.getItemCount(); i++) {
            if (view.categoryBox.getItemAt(i).id == p.getCategoryId()) view.categoryBox.setSelectedIndex(i);
        }
    }

    private void clearForm() {
        view.table.clearSelection();
        view.nameField.setText("");
        view.brandField.setText("");
        view.priceField.setText("");
        view.discountField.setText("0");
        view.stockField.setText("0");
        view.imageField.setText("");
        view.activeBox.setSelected(true);
    }

    private void save(boolean isNew) {
        try {
            Product p = new Product();
            if (!isNew) {
                Product sel = selected();
                if (sel == null) { message("Select a product in the table first."); return; }
                p.setProductId(sel.getProductId());
            }
            String name = view.nameField.getText().trim();
            if (name.isEmpty()) { message("Name is required."); return; }
            CategoryItem cat = (CategoryItem) view.categoryBox.getSelectedItem();
            if (cat == null) { message("Choose a category."); return; }
            p.setName(name);
            p.setBrand(view.brandField.getText().trim());
            p.setCategoryId(cat.id);
            p.setPrice(Double.parseDouble(view.priceField.getText().trim()));
            p.setDiscount(Double.parseDouble(view.discountField.getText().trim()));
            p.setStock(Integer.parseInt(view.stockField.getText().trim()));
            p.setImageUrl(view.imageField.getText().trim());
            p.setStatus(view.activeBox.isSelected());
            if (p.getPrice() <= 0 || p.getDiscount() < 0 || p.getDiscount() > 90 || p.getStock() < 0) {
                message("Price must be > 0, discount 0-90 and stock >= 0.");
                return;
            }
            if (isNew) dao.insert(p); else dao.update(p);
            refresh();
            clearForm();
        } catch (NumberFormatException ex) {
            message("Price, discount and stock must be valid numbers.");
        } catch (SQLException ex) {
            error(ex);
        }
    }

    private void delete() {
        Product p = selected();
        if (p == null) { message("Select a product in the table first."); return; }
        int ok = JOptionPane.showConfirmDialog(view, "Remove '" + p.getName() + "' from the store?",
                "Confirm", JOptionPane.YES_NO_OPTION);
        if (ok != JOptionPane.YES_OPTION) return;
        try {
            dao.deactivate(p.getProductId());
            refresh();
        } catch (SQLException ex) {
            error(ex);
        }
    }

    /** Desktop admin calling the remote inventory service (RMI module must be running). */
    private void checkStockViaRmi() {
        Product p = selected();
        if (p == null) { message("Select a product in the table first."); return; }
        try {
            InventoryService svc = (InventoryService)
                    Naming.lookup("rmi://localhost:" + RmiServer.PORT + "/InventoryService");
            message("Remote stock of '" + p.getName() + "' = " + svc.getStock(p.getProductId()));
        } catch (Exception ex) {
            message("RMI server not reachable. Start com.shopsphere.rmi.RmiServer first.\n" + ex.getMessage());
        }
    }

    private void message(String text) { JOptionPane.showMessageDialog(view, text); }
    private void error(SQLException ex) {
        JOptionPane.showMessageDialog(view, "Database error: " + ex.getMessage(), "Error", JOptionPane.ERROR_MESSAGE);
    }
}
