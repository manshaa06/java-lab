package com.shopsphere.util;

import java.text.NumberFormat;
import java.util.Locale;
import java.util.ResourceBundle;

/**
 * Utility for Internationalization (I18N) and Localization (L10N).
 * Demonstrates Locale, ResourceBundle, and formatted monetary values as per Section 23 of RTU syllabus.
 */
public class I18nUtil {

    private static final String BUNDLE_BASE_NAME = "messages";

    public static final Locale LOCALE_EN = new Locale("en", "US");
    public static final Locale LOCALE_HI = new Locale("hi", "IN");

    /**
     * Retrieves a localized message by key and locale code.
     * @param key message key in properties file
     * @param lang language code ('en' or 'hi')
     * @return localized string
     */
    public static String getMessage(String key, String lang) {
        Locale locale = "hi".equalsIgnoreCase(lang) ? LOCALE_HI : LOCALE_EN;
        try {
            ResourceBundle bundle = ResourceBundle.getBundle(BUNDLE_BASE_NAME, locale);
            return bundle.getString(key);
        } catch (Exception e) {
            return "[" + key + "]";
        }
    }

    /**
     * Formats an amount as Indian Rupee currency.
     */
    public static String formatCurrency(double amount) {
        NumberFormat nf = NumberFormat.getCurrencyInstance(new Locale("en", "IN"));
        return nf.format(amount).replace("INR", "₹").trim();
    }
}
