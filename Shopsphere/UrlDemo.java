package com.shopsphere.demo;

import java.io.*;
import java.net.*;
import java.nio.charset.StandardCharsets;

/**
 * URL / URLConnection demo + a tiny custom protocol handler.
 *  1) shop://  - our own protocol, served by a URLStreamHandler (no network needed)
 *  2) http(s)  - a real URLConnection (needs internet): java ... UrlDemo https://example.com
 */
public class UrlDemo {

    /** Custom protocol handler: knows how to open "shop:" URLs. */
    static class ShopHandler extends URLStreamHandler {
        @Override
        protected URLConnection openConnection(URL u) {
            return new URLConnection(u) {
                @Override public void connect() { connected = true; }
                @Override public String getContentType() { return "text/plain"; }
                @Override public InputStream getInputStream() {
                    String body = "ShopSphere custom protocol -> host=" + u.getHost() + ", path=" + u.getPath();
                    return new ByteArrayInputStream(body.getBytes(StandardCharsets.UTF_8));
                }
            };
        }
    }

    public static void main(String[] args) throws Exception {
        URL custom = new URL(null, "shop://inventory/stock/1", new ShopHandler());
        System.out.println("Protocol: " + custom.getProtocol() + ", host: " + custom.getHost() + ", path: " + custom.getPath());
        try (BufferedReader r = new BufferedReader(new InputStreamReader(custom.openStream(), StandardCharsets.UTF_8))) {
            System.out.println(r.readLine());
        }

        String address = args.length > 0 ? args[0] : "https://example.com";
        try {
            URLConnection con = URI.create(address).toURL().openConnection();
            con.setConnectTimeout(5000);
            con.setReadTimeout(5000);
            System.out.println("\nContent-Type: " + con.getContentType());
            System.out.println("Content-Length: " + con.getContentLength());
            System.out.println("Date header: " + con.getHeaderField("Date"));
        } catch (IOException e) {
            System.out.println("\n(No internet for " + address + ": " + e.getMessage() + ")");
        }
    }
}
