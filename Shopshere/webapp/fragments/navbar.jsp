<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<!-- Top Info Bar -->
<div class="top-announcement-bar py-1 bg-dark text-light border-bottom border-secondary border-opacity-25" style="font-size: 0.8rem;">
    <div class="container d-flex justify-content-between align-items-center">
        <div class="d-none d-md-flex align-items-center gap-3">
            <span><i class="bi bi-mortarboard-fill text-warning me-1"></i> RTU Advanced Java Capstone Project</span>
            <span class="text-white-50">|</span>
            <span><i class="bi bi-shield-check text-success me-1"></i> ACID Transactions &amp; Layered MVC</span>
        </div>
        <div class="d-flex align-items-center gap-3 ms-auto">
            <!-- Language Switcher (Section 23 I18N) -->
            <div class="dropdown">
                <a class="dropdown-toggle text-white text-decoration-none" href="#" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                    <i class="bi bi-globe2 me-1"></i> ${sessionScope.lang == 'hi' ? 'हिन्दी (HI)' : 'English (EN)'}
                </a>
                <ul class="dropdown-menu dropdown-menu-end shadow-sm">
                    <li><a class="dropdown-item ${sessionScope.lang != 'hi' ? 'active' : ''}" href="${pageContext.request.contextPath}/profile?action=setLang&lang=en">English (US/UK)</a></li>
                    <li><a class="dropdown-item ${sessionScope.lang == 'hi' ? 'active' : ''}" href="${pageContext.request.contextPath}/profile?action=setLang&lang=hi">हिन्दी (Hindi)</a></li>
                </ul>
            </div>
            <a href="${pageContext.request.contextPath}/syllabus-demo" class="text-warning text-decoration-none fw-semibold">
                <i class="bi bi-cpu me-1"></i> RTU Syllabus Lab
            </a>
        </div>
    </div>
</div>

<!-- Main Navigation Bar -->
<nav class="navbar navbar-expand-lg navbar-dark bg-dark sticky-top shadow-sm py-2">
    <div class="container">
        <!-- Brand Logo -->
        <a class="navbar-brand d-flex align-items-center gap-2 fw-bold" href="${pageContext.request.contextPath}/">
            <span class="brand-icon-box bg-primary text-white rounded-3 d-inline-flex align-items-center justify-content-center" style="width: 38px; height: 38px;">
                <i class="bi bi-gem fs-5"></i>
            </span>
            <span class="fs-4 brand-text" style="font-family: 'Outfit', sans-serif; letter-spacing: -0.5px;">Shop<span class="text-primary">Sphere</span></span>
        </a>

        <!-- Mobile Toggler -->
        <button class="navbar-toggler border-0" type="button" data-bs-toggle="collapse" data-bs-target="#mainNavbar" aria-controls="mainNavbar" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="mainNavbar">
            <!-- Nav Links -->
            <ul class="navbar-nav me-auto mb-2 mb-lg-0 align-items-lg-center">
                <li class="nav-item">
                    <a class="nav-link active" href="${pageContext.request.contextPath}/">
                        <i class="bi bi-house-door me-1"></i> Home
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/products">
                        <i class="bi bi-grid me-1"></i> Catalog
                    </a>
                </li>
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                        <i class="bi bi-tags me-1"></i> Categories
                    </a>
                    <ul class="dropdown-menu shadow-sm">
                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/products?category=1"><i class="bi bi-laptop me-2"></i> Electronics</a></li>
                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/products?category=2"><i class="bi bi-bag me-2"></i> Fashion &amp; Apparel</a></li>
                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/products?category=3"><i class="bi bi-cup-hot me-2"></i> Home &amp; Kitchen</a></li>
                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/products?category=4"><i class="bi bi-book me-2"></i> Books &amp; Stationery</a></li>
                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/products?category=5"><i class="bi bi-activity me-2"></i> Fitness &amp; Sports</a></li>
                    </ul>
                </li>
            </ul>

            <!-- Search Bar -->
            <form action="${pageContext.request.contextPath}/products" method="get" class="d-flex mx-lg-3 my-2 my-lg-0 flex-grow-1" style="max-width: 450px;">
                <div class="input-group">
                    <input class="form-control bg-dark-subtle text-white border-secondary border-opacity-50 search-input" 
                           type="search" name="query" placeholder="Search laptops, sneakers, coffee..." 
                           value="${param.query}" aria-label="Search">
                    <button class="btn btn-primary" type="submit">
                        <i class="bi bi-search"></i>
                    </button>
                </div>
            </form>

            <!-- User and Cart Actions -->
            <div class="d-flex align-items-center gap-2 mt-2 mt-lg-0">
                <!-- Wishlist -->
                <a href="${pageContext.request.contextPath}/wishlist" class="btn btn-outline-light btn-sm rounded-pill position-relative px-3" title="My Wishlist">
                    <i class="bi bi-heart"></i>
                </a>

                <!-- Cart -->
                <a href="${pageContext.request.contextPath}/cart" class="btn btn-primary btn-sm rounded-pill position-relative px-3 d-flex align-items-center gap-2 shadow-sm">
                    <i class="bi bi-cart3"></i>
                    <span class="d-none d-sm-inline">Cart</span>
                    <c:if test="${sessionScope.cartCount != null && sessionScope.cartCount > 0}">
                        <span class="badge bg-danger rounded-pill">${sessionScope.cartCount}</span>
                    </c:if>
                </a>

                <!-- User Dropdown -->
                <c:choose>
                    <c:when test="${sessionScope.user != null}">
                        <div class="dropdown">
                            <button class="btn btn-outline-light btn-sm rounded-pill dropdown-toggle d-flex align-items-center gap-2" type="button" data-bs-toggle="dropdown" aria-expanded="false">
                                <i class="bi bi-person-circle fs-6"></i>
                                <span class="d-inline-block text-truncate" style="max-width: 100px;">${sessionScope.user.name}</span>
                            </button>
                            <ul class="dropdown-menu dropdown-menu-end shadow-sm">
                                <li class="px-3 py-2 border-bottom">
                                    <div class="fw-bold">${sessionScope.user.name}</div>
                                    <div class="small text-muted">${sessionScope.user.email}</div>
                                    <span class="badge bg-primary-subtle text-primary rounded-pill mt-1">${sessionScope.user.role}</span>
                                </li>
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/profile"><i class="bi bi-person me-2"></i> My Profile</a></li>
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/orders"><i class="bi bi-box-seam me-2"></i> My Orders</a></li>
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/wishlist"><i class="bi bi-heart me-2"></i> Wishlist</a></li>
                                <c:if test="${sessionScope.user.admin}">
                                    <li><hr class="dropdown-divider"></li>
                                    <li><a class="dropdown-item text-danger fw-semibold" href="${pageContext.request.contextPath}/admin/dashboard"><i class="bi bi-speedometer2 me-2"></i> Admin Panel</a></li>
                                </c:if>
                                <li><hr class="dropdown-divider"></li>
                                <li><a class="dropdown-item text-danger" href="${pageContext.request.contextPath}/logout"><i class="bi bi-box-arrow-right me-2"></i> Logout</a></li>
                            </ul>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <a href="${pageContext.request.contextPath}/login" class="btn btn-outline-light btn-sm rounded-pill px-3">
                            <i class="bi bi-box-arrow-in-right me-1"></i> Login
                        </a>
                        <a href="${pageContext.request.contextPath}/register" class="btn btn-light btn-sm rounded-pill px-3 fw-semibold">
                            Register
                        </a>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</nav>

<!-- Alert messages flash display -->
<c:if test="${param.success != null}">
    <div class="container mt-3">
        <div class="alert alert-success alert-dismissible fade show shadow-sm" role="alert">
            <i class="bi bi-check-circle-fill me-2"></i> ${param.success}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    </div>
</c:if>
<c:if test="${param.error != null}">
    <div class="container mt-3">
        <div class="alert alert-danger alert-dismissible fade show shadow-sm" role="alert">
            <i class="bi bi-exclamation-triangle-fill me-2"></i> ${param.error}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    </div>
</c:if>
