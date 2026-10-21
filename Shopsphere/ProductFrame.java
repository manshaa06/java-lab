package com.shopsphere.swing.view;

import com.shopsphere.swing.model.ProductTableModel;
import java.awt.*;
import javax.swing.*;

/** MVC "View": product management window with a JTable and a data-entry form. */
public class ProductFrame extends JFrame {

    /** Item shown in the category combo box. */
    public static class CategoryItem {
        public final int id;
        public final String name;
        public CategoryItem(int id, String name) { this.id = id; this.name = name; }
        @Override public String toString() { return name; }
    }

    public final ProductTableModel tableModel = new ProductTableModel();
    public final JTable table = new JTable(tableModel);

    public final JTextField nameField = new JTextField(15);
    public final JTextField brandField = new JTextField(15);
    public final JTextField priceField = new JTextField(8);
    public final JTextField discountField = new JTextField("0", 8);
    public final JTextField stockField = new JTextField("0", 8);
    public final JTextField imageField = new JTextField(20);
    public final JComboBox<CategoryItem> categoryBox = new JComboBox<>();
    public final JCheckBox activeBox = new JCheckBox("Active", true);

    public final JRadioButton allRadio = new JRadioButton("All", true);
    public final JRadioButton activeRadio = new JRadioButton("Active only");
    public final JRadioButton lowRadio = new JRadioButton("Low stock (<= 5)");

    public final JButton addButton = new JButton("Add");
    public final JButton updateButton = new JButton("Update");
    public final JButton deleteButton = new JButton("Delete");
    public final JButton clearButton = new JButton("Clear form");
    public final JButton refreshButton = new JButton("Refresh");
    public final JButton rmiButton = new JButton("Check stock via RMI");

    public ProductFrame(String adminName) {
        super("ShopSphere Admin - Products (logged in as " + adminName + ")");
        setDefaultCloseOperation(EXIT_ON_CLOSE);
        setLayout(new BorderLayout(8, 8));

        // top: filter radio buttons
        ButtonGroup group = new ButtonGroup();
        JPanel filters = new JPanel(new FlowLayout(FlowLayout.LEFT));
        filters.add(new JLabel("Show:"));
        for (JRadioButton r : new JRadioButton[]{allRadio, activeRadio, lowRadio}) {
            group.add(r);
            filters.add(r);
        }
        filters.add(refreshButton);
        add(filters, BorderLayout.NORTH);

        // centre: table
        table.setSelectionMode(ListSelectionModel.SINGLE_SELECTION);
        table.setAutoCreateRowSorter(true);
        add(new JScrollPane(table), BorderLayout.CENTER);

        // bottom: form
        JPanel form = new JPanel(new GridLayout(0, 4, 6, 6));
        form.setBorder(BorderFactory.createTitledBorder("Product details"));
        form.add(new JLabel("Name"));      form.add(nameField);
        form.add(new JLabel("Brand"));     form.add(brandField);
        form.add(new JLabel("Category"));  form.add(categoryBox);
        form.add(new JLabel("Price"));     form.add(priceField);
        form.add(new JLabel("Discount %")); form.add(discountField);
        form.add(new JLabel("Stock"));     form.add(stockField);
        form.add(new JLabel("Image URL")); form.add(imageField);
        form.add(activeBox);               form.add(new JLabel(""));

        JPanel buttons = new JPanel(new FlowLayout(FlowLayout.LEFT));
        for (JButton b : new JButton[]{addButton, updateButton, deleteButton, clearButton, rmiButton}) buttons.add(b);

        JPanel bottom = new JPanel(new BorderLayout());
        bottom.add(form, BorderLayout.CENTER);
        bottom.add(buttons, BorderLayout.SOUTH);
        add(bottom, BorderLayout.SOUTH);

        setSize(900, 650);
        setLocationRelativeTo(null);
    }
}
