package com.shopsphere.swing.model;

import com.shopsphere.model.Product;
import java.util.ArrayList;
import java.util.List;
import javax.swing.table.AbstractTableModel;

/** MVC "Model" for the JTable: wraps a list of products. */
public class ProductTableModel extends AbstractTableModel {
    private static final String[] COLUMNS = {"ID", "Name", "Brand", "Category", "Price", "Disc %", "Stock", "Active"};
    private List<Product> rows = new ArrayList<>();

    public void setRows(List<Product> rows) {
        this.rows = rows;
        fireTableDataChanged();
    }

    public Product getProductAt(int row) { return rows.get(row); }

    @Override public int getRowCount() { return rows.size(); }
    @Override public int getColumnCount() { return COLUMNS.length; }
    @Override public String getColumnName(int c) { return COLUMNS[c]; }

    @Override
    public Class<?> getColumnClass(int c) {
        return c == 7 ? Boolean.class : Object.class;
    }

    @Override
    public Object getValueAt(int r, int c) {
        Product p = rows.get(r);
        switch (c) {
            case 0: return p.getProductId();
            case 1: return p.getName();
            case 2: return p.getBrand();
            case 3: return p.getCategoryName();
            case 4: return p.getPrice();
            case 5: return p.getDiscount();
            case 6: return p.getStock();
            default: return p.isStatus();
        }
    }
}
