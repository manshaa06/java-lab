<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.shopsphere.service.ProductService, com.shopsphere.model.Product, com.shopsphere.model.Category, java.util.List" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>

<%
    // Ensure featured products and categories are loaded for home display
    ProductService ps = new ProductService();
    List<Product> featured = ps.getAllActiveProducts();
    if (featured.size() > 8) featured = featured.subList(0, 8);
    request.setAttribute("featuredProducts", featured);
    request.setAttribute("homeCategories", ps.getAllCategories());
    request.setAttribute("pageTitle", "ShopSphere - Enterprise Java E-Commerce Platform");
%>

<jsp:include page="fragments/header.jsp" />
<jsp:include page="fragments/navbar.jsp" />

<main class="flex-grow-1">
    <!-- Hero Banner -->
    <div class="container my-4">
        <div class="hero-banner text-white p-5 p-lg-5 shadow-lg position-relative">
            <div class="row align-items-center position-relative" style="z-index: 2;">
                <div class="col-lg-7">
                    <span class="badge bg-primary-subtle text-primary border border-primary border-opacity-25 px-3 py-2 rounded-pill fw-semibold mb-3">
                        <i class="bi bi-stars me-1"></i> RTU Advanced Java Capstone Project
                    </span>
                    <h1 class="display-4 fw-extrabold mb-3" style="letter-spacing: -1px; line-height: 1.15;">
                        Next-Generation <span class="text-info">Java Enterprise</span> E-Commerce
                    </h1>
                    <p class="lead text-white-50 mb-4 pe-lg-4">
                        A robust, distributed multi-tier system engineered with Jakarta Servlets, JSP 3.1, JDBC ACID transactions, Java RMI, and Socket communication.
                    </p>
                    <div class="d-flex flex-wrap gap-3">
                        <a href="${pageContext.request.contextPath}/products" class="btn btn-primary btn-lg rounded-pill px-4 shadow">
                            <i class="bi bi-bag-check me-2"></i> Explore Catalog
                        </a>
                        <a href="${pageContext.request.contextPath}/syllabus-demo" class="btn btn-outline-light btn-lg rounded-pill px-4">
                            <i class="bi bi-cpu me-2"></i> View Syllabus Lab
                        </a>
                    </div>
                </div>
                <div class="col-lg-5 d-none d-lg-block text-center">
                    <div class="bg-dark bg-opacity-50 p-4 rounded-4 border border-secondary border-opacity-25 shadow-sm text-start">
                        <div class="d-flex align-items-center gap-2 mb-3 pb-2 border-bottom border-secondary border-opacity-25">
                            <span class="badge bg-success rounded-pill">&nbsp;</span>
                            <span class="fw-bold small text-uppercase text-white-50" style="letter-spacing: 1px;">RTU Architecture Stack</span>
                        </div>
                        <ul class="list-unstyled mb-0 d-flex flex-column gap-2 small font-monospace">
                            <li><i class="bi bi-check2-circle text-info me-2"></i>Jakarta Servlet 6.1.0</li>
                            <li><i class="bi bi-check2-circle text-info me-2"></i>Apache Tomcat 11.0.26</li>
                            <li><i class="bi bi-check2-circle text-info me-2"></i>MySQL 8 / MariaDB (ACID)</li>
                            <li><i class="bi bi-check2-circle text-info me-2"></i>Java RMI Remote Inventory</li>
                            <li><i class="bi bi-check2-circle text-info me-2"></i>java.net Object Sockets</li>
                            <li><i class="bi bi-check2-circle text-info me-2"></i>Swing Desktop Admin App</li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Quick Category Bar -->
    <div class="container mb-5">
        <div class="d-flex justify-content-between align-items-center mb-3">
            <h5 class="fw-bold mb-0">Browse by Category</h5>
            <a href="${pageContext.request.contextPath}/products" class="text-primary text-decoration-none small fw-semibold">View All <i class="bi bi-arrow-right"></i></a>
        </div>
        <div class="row g-3">
            <c:forEach var="cat" items="${homeCategories}">
                <div class="col-6 col-md-4 col-lg">
                    <a href="${pageContext.request.contextPath}/products?category=${cat.categoryId}" class="category-badge-card text-center d-flex flex-column align-items-center py-3">
                        <div class="bg-primary-subtle text-primary rounded-circle p-3 mb-2 d-inline-flex align-items-center justify-content-center" style="width: 52px; height: 52px;">
                            <c:choose>
                                <c:when test="${cat.categoryId == 1}"><i class="bi bi-laptop fs-4"></i></c:when>
                                <c:when test="${cat.categoryId == 2}"><i class="bi bi-bag fs-4"></i></c:when>
                                <c:when test="${cat.categoryId == 3}"><i class="bi bi-cup-hot fs-4"></i></c:when>
                                <c:when test="${cat.categoryId == 4}"><i class="bi bi-book fs-4"></i></c:when>
                                <c:otherwise><i class="bi bi-activity fs-4"></i></c:otherwise>
                            </c:choose>
                        </div>
                        <span class="fw-semibold text-truncate w-100">${cat.name}</span>
                        <span class="small text-muted">${cat.productCount} items</span>
                    </a>
                </div>
            </c:forEach>
        </div>
    </div>

    <!-- Featured Products Grid (Tag File Demonstration) -->
    <div class="container mb-5">
        <div class="d-flex justify-content-between align-items-end mb-4">
            <div>
                <span class="badge bg-primary-subtle text-primary px-3 py-1 rounded-pill fw-semibold mb-2">Curated Picks</span>
                <h3 class="fw-bold mb-0">Featured Products</h3>
            </div>
            <a href="${pageContext.request.contextPath}/products" class="btn btn-outline-primary rounded-pill btn-sm px-3">
                See All Products <i class="bi bi-chevron-right ms-1"></i>
            </a>
        </div>

        <div class="row g-4">
            <c:forEach var="prod" items="${featuredProducts}">
                <tags:productCard product="${prod}" />
            </c:forEach>
        </div>
    </div>

    <!-- Active Promo / Discount Banner -->
    <div class="container mb-5">
        <div class="card border-0 shadow-sm rounded-4 overflow-hidden" style="background: linear-gradient(135deg, #1e1b4b 0%, #4338ca 100%);">
            <div class="card-body p-4 p-md-5 text-white">
                <div class="row align-items-center">
                    <div class="col-md-8">
                        <span class="badge bg-warning text-dark px-3 py-1 rounded-pill fw-bold mb-2">Special Offer</span>
                        <h2 class="fw-bold mb-2">Save 50% on Your First Order!</h2>
                        <p class="text-white-50 mb-3 mb-md-0">Use promo coupon code <strong class="text-white bg-dark bg-opacity-50 px-2 py-1 rounded font-monospace">WELCOME50</strong> during checkout to claim your discount.</p>
                    </div>
                    <div class="col-md-4 text-md-end">
                        <button class="btn btn-warning rounded-pill px-4 py-2 fw-bold btn-copy-code shadow" data-code="WELCOME50">
                            <i class="bi bi-clipboard me-1"></i> Copy Code: WELCOME50
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Value Propositions -->
    <div class="container mb-5 pb-3">
        <div class="row g-4 text-center">
            <div class="col-md-3 col-6">
                <div class="p-3 bg-white rounded-4 shadow-sm border border-light-subtle h-100">
                    <i class="bi bi-truck fs-1 text-primary mb-2 d-block"></i>
                    <h6 class="fw-bold mb-1">Fast Delivery</h6>
                    <p class="small text-muted mb-0">Track order timeline in real-time</p>
                </div>
            </div>
            <div class="col-md-3 col-6">
                <div class="p-3 bg-white rounded-4 shadow-sm border border-light-subtle h-100">
                    <i class="bi bi-shield-check fs-1 text-success mb-2 d-block"></i>
                    <h6 class="fw-bold mb-1">Secure Payments</h6>
                    <p class="small text-muted mb-0">UPI, Net Banking &amp; Cards</p>
                </div>
            </div>
            <div class="col-md-3 col-6">
                <div class="p-3 bg-white rounded-4 shadow-sm border border-light-subtle h-100">
                    <i class="bi bi-arrow-repeat fs-1 text-info mb-2 d-block"></i>
                    <h6 class="fw-bold mb-1">ACID Guarantees</h6>
                    <p class="small text-muted mb-0">Atomic inventory updates</p>
                </div>
            </div>
            <div class="col-md-3 col-6">
                <div class="p-3 bg-white rounded-4 shadow-sm border border-light-subtle h-100">
                    <i class="bi bi-headset fs-1 text-warning mb-2 d-block"></i>
                    <h6 class="fw-bold mb-1">RTU Lab Ready</h6>
                    <p class="small text-muted mb-0">Full viva demonstration suite</p>
                </div>
            </div>
        </div>
    </div>
</main>

<jsp:include page="fragments/footer.jsp" />
