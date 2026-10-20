<%@ tag language="java" pageEncoding="UTF-8" description="Rating Star Component Tag File" %>
<%@ attribute name="value" required="true" type="java.lang.Double" description="Rating score 1 to 5" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<div class="d-inline-flex align-items-center">
    <c:forEach var="i" begin="1" end="5">
        <c:choose>
            <c:when test="${value >= i}">
                <i class="bi bi-star-fill text-warning" style="font-size: 0.85rem;"></i>
            </c:when>
            <c:when test="${value >= (i - 0.5)}">
                <i class="bi bi-star-half text-warning" style="font-size: 0.85rem;"></i>
            </c:when>
            <c:otherwise>
                <i class="bi bi-star text-secondary" style="font-size: 0.85rem;"></i>
            </c:otherwise>
        </c:choose>
    </c:forEach>
    <span class="ms-1 small text-muted font-monospace">(${value != null ? value : '4.5'})</span>
</div>
