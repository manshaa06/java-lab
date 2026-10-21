package com.shopsphere.demo;

import java.text.DateFormat;
import java.text.NumberFormat;
import java.util.Date;
import java.util.Locale;
import java.util.ResourceBundle;

/** Internationalization demo: Locale, ResourceBundle and locale-sensitive number/date formatting. */
public class I18nDemo {
    public static void main(String[] args) {
        Locale[] locales = {Locale.ENGLISH, new Locale("hi")};
        double price = 1234567.5;
        Date now = new Date();

        for (Locale locale : locales) {
            ResourceBundle bundle = ResourceBundle.getBundle("messages", locale);
            System.out.println("---- " + locale.getDisplayLanguage(locale) + " ----");
            System.out.println(bundle.getString("welcome.title"));
            System.out.println(bundle.getString("nav.cart") + " | " + bundle.getString("btn.addToCart"));
        }
        // Indian formatting (lakh/crore grouping) for prices and a long date
        NumberFormat money = NumberFormat.getCurrencyInstance(new Locale("en", "IN"));
        System.out.println("Price: " + money.format(price));
        System.out.println("Date : " + DateFormat.getDateInstance(DateFormat.LONG, new Locale("en", "IN")).format(now));
    }
}
