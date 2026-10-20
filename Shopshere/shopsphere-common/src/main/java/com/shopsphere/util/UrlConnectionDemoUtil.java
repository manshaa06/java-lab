package com.shopsphere.util;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.URL;
import java.net.URLConnection;
import java.util.HashMap;
import java.util.Map;

/**
 * Educational module demonstrating java.net URL and URLConnection content and protocol handlers.
 * RTU Syllabus Requirement: Content/Protocol Handlers demonstration.
 */
public class UrlConnectionDemoUtil {

    public static Map<String, Object> inspectUrl(String urlString) {
        Map<String, Object> result = new HashMap<>();
        try {
            URL url = new URL(urlString);
            result.put("protocol", url.getProtocol());
            result.put("host", url.getHost());
            result.put("port", url.getPort() != -1 ? url.getPort() : url.getDefaultPort());
            result.put("path", url.getPath());

            URLConnection connection = url.openConnection();
            connection.setConnectTimeout(3000);
            connection.setReadTimeout(3000);

            result.put("contentType", connection.getContentType());
            result.put("contentLength", connection.getContentLengthLong());
            result.put("date", connection.getDate());

            // Read first few lines of sample preview
            try (BufferedReader in = new BufferedReader(new InputStreamReader(connection.getInputStream()))) {
                StringBuilder snippet = new StringBuilder();
                String inputLine;
                int lines = 0;
                while ((inputLine = in.readLine()) != null && lines < 5) {
                    snippet.append(inputLine).append("\n");
                    lines++;
                }
                result.put("preview", snippet.toString());
            }
            result.put("status", "SUCCESS");
        } catch (Exception e) {
            result.put("status", "ERROR");
            result.put("error", e.getMessage());
        }
        return result;
    }
}
