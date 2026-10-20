package com.shopsphere.tag;

import jakarta.servlet.jsp.JspException;
import jakarta.servlet.jsp.JspWriter;
import jakarta.servlet.jsp.tagext.SimpleTagSupport;

import java.io.IOException;

/**
 * Custom JSP Tag Handler to render star ratings.
 * RTU Syllabus Requirement: Tag Extensions / Tag Handlers.
 */
public class RatingTag extends SimpleTagSupport {

    private double rating;
    private int maxStars = 5;

    public void setRating(double rating) {
        this.rating = rating;
    }

    public void setMaxStars(int maxStars) {
        this.maxStars = maxStars;
    }

    @Override
    public void doTag() throws JspException, IOException {
        JspWriter out = getJspContext().getOut();
        StringBuilder sb = new StringBuilder();
        sb.append("<span class=\"shopsphere-rating-stars\" title=\"Rating: ").append(rating).append("/").append(maxStars).append("\">");

        int fullStars = (int) Math.floor(rating);
        boolean halfStar = (rating - fullStars) >= 0.5;

        for (int i = 1; i <= maxStars; i++) {
            if (i <= fullStars) {
                sb.append("<i class=\"bi bi-star-fill text-warning\"></i> ");
            } else if (i == fullStars + 1 && halfStar) {
                sb.append("<i class=\"bi bi-star-half text-warning\"></i> ");
            } else {
                sb.append("<i class=\"bi bi-star text-muted\"></i> ");
            }
        }
        sb.append("<span class=\"ms-1 small text-muted font-monospace\">(").append(rating).append(")</span>");
        sb.append("</span>");

        out.print(sb.toString());
    }
}
