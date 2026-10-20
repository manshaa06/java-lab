<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.shopsphere.service.ProductService, com.shopsphere.model.Product, com.shopsphere.model.Category, java.util.List" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>

<%
    // Fallback if products attribute was not populated by servlet
    if (request.getAttribute("products") == null) {
        ProductService ps = new ProductService();
        request.setAttribute("products", ps.getAllActiveProducts());
        request.setAttribute("categories", ps.getAllCategories());
    }
%>

<c:set var="pageTitle" value="Product Catalog | ShopSphere" scope="request" />
<jsp:include page="fragments/header.jsp" />
<jsp:include page="fragments/navbar.jsp" />

<div class="container my-4">
    <!-- Breadcrumb -->
    <nav aria-label="breadcrumb" class="mb-4">
        <ol class="breadcrumb small">
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/" class="text-decoration-none">Home</a></li>
            <li class="breadcrumb-item active" aria-current="page">Catalog</li>
            <c:if test="${not empty param.query}">
                <li class="breadcrumb-item active">Search: "${param.query}"</li>
            </c:if>
        </ol>
    </nav>

    <div class="row g-4">
        <!-- Sidebar Filter Column -->
        <div class="col-lg-3">
            <jsp:include page="fragments/sidebar.jsp" />
        </div>

        <!-- Products Main Grid Column -->
        <div class="col-lg-9">
            <div class="d-flex justify-content-between align-items-center mb-4 pb-2 border-bottom">
                <div>
                    <h4 class="fw-bold mb-0">Products Catalog</h4>
                    <span class="small text-muted">Showing ${products.size()} items</span>
                </div>
            </div>

            <c:choose>
                <c:when test="${not empty products}">
                    <div class="row g-4">
                        <c:forEach var="prod" items="${products}">
                            <tags:productCard product="${prod}" />
                        </c:forEach>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="card border-0 shadow-sm rounded-4 p-5 text-center my-4 bg-white">
                        <div class="text-muted mb-3">
                            <i class="bi bi-search fs-1"></i>
                        </div>
                        <h5 class="fw-bold mb-2">No Matching Products Found</h5>
                        <p class="text-muted small mb-4">Try clearing your filters or search with different keywords.</p>
                        <div>
                            <a href="${pageContext.request.contextPath}/products" class="btn btn-primary rounded-pill px-4">
                                Reset All Filters
                            </a>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>

<jsp:include page="fragments/footer.jsp" />
