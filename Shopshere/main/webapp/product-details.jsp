<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="shopsphere" uri="http://shopsphere.com/tags" %>

<c:set var="pageTitle" value="${product.name} | ShopSphere" scope="request" />
<jsp:include page="fragments/header.jsp" />
<jsp:include page="fragments/navbar.jsp" />

<div class="container my-4">
    <!-- Breadcrumb -->
    <nav aria-label="breadcrumb" class="mb-4">
        <ol class="breadcrumb small">
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/" class="text-decoration-none">Home</a></li>
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/products" class="text-decoration-none">Catalog</a></li>
            <li class="breadcrumb-item active" aria-current="page">${product.name}</li>
        </ol>
    </nav>

    <!-- Product Showcase Row -->
    <div class="card border-0 shadow-sm rounded-4 overflow-hidden bg-white mb-5">
        <div class="row g-0">
            <!-- Product Media Gallery -->
            <div class="col-lg-5 p-4 d-flex align-items-center justify-content-center bg-light-subtle">
                <div class="position-relative w-100 text-center" style="max-height: 480px;">
                    <c:if test="${product.discount > 0}">
                        <span class="badge bg-danger position-absolute top-0 start-0 m-2 px-3 py-2 rounded-pill shadow-sm fs-6">
                            -${Math.round(product.discount)}% OFF
                        </span>
                    </c:if>
                    <img src="${product.imageUrl != null ? product.imageUrl : 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=600&q=80'}" 
                         class="img-fluid rounded-4 shadow-sm object-fit-contain" 
                         style="max-height: 400px; width: 100%;" 
                         alt="${product.name}"
                         onerror="this.src='https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=600&q=80'">
                </div>
            </div>

            <!-- Product Information & Purchase Column -->
            <div class="col-lg-7 p-4 p-md-5 d-flex flex-column justify-content-between">
                <div>
                    <div class="d-flex justify-content-between align-items-center mb-2">
                        <span class="badge bg-primary-subtle text-primary text-uppercase px-3 py-1 rounded-pill fw-bold" style="letter-spacing: 0.5px;">
                            ${product.brand}
                        </span>
                        <span class="badge ${product.stock > 0 ? 'bg-success-subtle text-success' : 'bg-danger-subtle text-danger'} px-3 py-1 rounded-pill">
                            <i class="bi ${product.stock > 0 ? 'bi-check-circle-fill' : 'bi-x-circle-fill'} me-1"></i>
                            ${product.stock > 0 ? 'In Stock ('.concat(product.stock).concat(' units left)') : 'Currently Out of Stock'}
                        </span>
                    </div>

                    <h2 class="fw-bold mb-3">${product.name}</h2>

                    <!-- Star Rating (Section 17 Custom Tag Demonstration) -->
                    <div class="d-flex align-items-center gap-3 mb-3 pb-3 border-bottom">
                        <shopsphere:rating rating="${avgRating}" maxStars="5" />
                        <span class="text-muted small">|</span>
                        <a href="#reviewsSection" class="text-muted text-decoration-none small">
                            ${reviews.size()} Customer Reviews
                        </a>
                    </div>

                    <!-- Pricing Block -->
                    <div class="mb-4">
                        <div class="d-flex align-items-baseline gap-3 mb-1">
                            <span class="display-6 fw-bold text-primary">₹<fmt:formatNumber value="${product.discountedPrice}" type="number" minFractionDigits="2" maxFractionDigits="2"/></span>
                            <c:if test="${product.discount > 0}">
                                <span class="fs-5 text-decoration-line-through text-muted">₹<fmt:formatNumber value="${product.price}" type="number" minFractionDigits="2" maxFractionDigits="2"/></span>
                                <span class="badge bg-success-subtle text-success fw-bold">Save ₹<fmt:formatNumber value="${product.price - product.discountedPrice}" minFractionDigits="2" maxFractionDigits="2"/></span>
                            </c:if>
                        </div>
                        <small class="text-muted d-block">Inclusive of all taxes &amp; standard warranty</small>
                    </div>

                    <!-- Description -->
                    <div class="mb-4">
                        <h6 class="fw-bold text-uppercase text-muted small" style="letter-spacing: 0.5px;">Description &amp; Specifications</h6>
                        <p class="text-secondary leading-relaxed">${product.description}</p>
                    </div>
                </div>

                <!-- Add to Cart / Buy Action Buttons -->
                <div class="pt-4 border-top">
                    <c:choose>
                        <c:when test="${product.stock > 0}">
                            <form action="${pageContext.request.contextPath}/cart" method="post" class="row g-3 align-items-center">
                                <input type="hidden" name="action" value="add">
                                <input type="hidden" name="productId" value="${product.productId}">

                                <div class="col-auto">
                                    <label class="fw-semibold small text-muted me-2">Quantity:</label>
                                    <select name="quantity" class="form-select form-select-sm d-inline-block w-auto rounded-3">
                                        <c:forEach var="i" begin="1" end="${product.stock < 10 ? product.stock : 10}">
                                            <option value="${i}">${i}</option>
                                        </c:forEach>
                                    </select>
                                </div>

                                <div class="col">
                                    <button type="submit" class="btn btn-primary w-100 py-2 rounded-pill fw-semibold shadow-sm d-flex align-items-center justify-content-center gap-2">
                                        <i class="bi bi-cart-plus-fill"></i> Add to Shopping Cart
                                    </button>
                                </div>
                            </form>
                        </c:when>
                        <c:otherwise>
                            <div class="alert alert-warning mb-0 rounded-4">
                                <i class="bi bi-bell me-2"></i> This product is currently out of stock. We will notify you once restocked.
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>

    <!-- Customer Reviews Section -->
    <div class="row g-4 mb-5" id="reviewsSection">
        <div class="col-lg-7">
            <div class="card border-0 shadow-sm rounded-4 p-4 bg-white h-100">
                <div class="d-flex justify-content-between align-items-center mb-4 pb-2 border-bottom">
                    <h5 class="fw-bold mb-0">Customer Reviews &amp; Ratings</h5>
                    <span class="badge bg-light text-dark border">${reviews.size()} Reviews</span>
                </div>

                <c:choose>
                    <c:when test="${not empty reviews}">
                        <div class="d-flex flex-column gap-3">
                            <c:forEach var="rev" items="${reviews}">
                                <div class="p-3 bg-light rounded-3 border">
                                    <div class="d-flex justify-content-between align-items-center mb-1">
                                        <span class="fw-bold text-dark"><i class="bi bi-person-circle text-primary me-2"></i>${rev.userName}</span>
                                        <tags:rating value="${rev.rating + 0.0}" />
                                    </div>
                                    <p class="text-secondary small mb-1">${rev.reviewText}</p>
                                    <span class="text-muted" style="font-size: 0.72rem;">${rev.createdAt}</span>
                                </div>
                            </c:forEach>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <p class="text-muted small my-4 text-center">No reviews yet for this product. Be the first to share your experience!</p>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <!-- Add Review Form -->
        <div class="col-lg-5">
            <div class="card border-0 shadow-sm rounded-4 p-4 bg-white h-100">
                <h5 class="fw-bold mb-3">Write a Customer Review</h5>
                <c:choose>
                    <c:when test="${sessionScope.user != null}">
                        <form action="${pageContext.request.contextPath}/review" method="post">
                            <input type="hidden" name="productId" value="${product.productId}">

                            <div class="mb-3">
                                <label class="form-label small fw-semibold text-muted">Your Rating Score</label>
                                <select name="rating" class="form-select rounded-3">
                                    <option value="5">★★★★★ (5 Stars - Exceptional)</option>
                                    <option value="4">★★★★☆ (4 Stars - Good)</option>
                                    <option value="3">★★★☆☆ (3 Stars - Average)</option>
                                    <option value="2">★★☆☆☆ (2 Stars - Below Average)</option>
                                    <option value="1">★☆☆☆☆ (1 Star - Poor)</option>
                                </select>
                            </div>

                            <div class="mb-3">
                                <label class="form-label small fw-semibold text-muted">Review Details</label>
                                <textarea name="reviewText" rows="4" class="form-control rounded-3" placeholder="Share your feedback about product quality, performance, and durability..." required></textarea>
                            </div>

                            <button type="submit" class="btn btn-outline-primary rounded-pill w-100 fw-semibold">
                                <i class="bi bi-send me-1"></i> Submit Review
                            </button>
                        </form>
                    </c:when>
                    <c:otherwise>
                        <div class="text-center py-4">
                            <i class="bi bi-lock fs-1 text-muted d-block mb-2"></i>
                            <p class="text-muted small mb-3">Please sign in to your customer account to submit a review.</p>
                            <a href="${pageContext.request.contextPath}/login?redirect=${pageContext.request.contextPath}/product?id=${product.productId}" class="btn btn-primary btn-sm rounded-pill px-4">
                                Sign In to Review
                            </a>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>

    <!-- Section 15 Requirement: Recently Viewed Products (Cookie Based) -->
    <c:if test="${not empty recentlyViewed}">
        <div class="mb-5">
            <h5 class="fw-bold mb-3">Recently Viewed (Session Cookie Demonstration)</h5>
            <div class="row g-3">
                <c:forEach var="rProd" items="${recentlyViewed}">
                    <div class="col-6 col-md-3">
                        <div class="card h-100 border-0 shadow-sm rounded-3 p-2 bg-white">
                            <a href="${pageContext.request.contextPath}/product?id=${rProd.productId}" class="text-decoration-none">
                                <img src="${rProd.imageUrl}" class="card-img-top rounded-2 object-fit-cover" style="height: 120px;" alt="${rProd.name}">
                                <div class="card-body p-2">
                                    <div class="fw-semibold text-dark text-truncate small">${rProd.name}</div>
                                    <div class="fw-bold text-primary small">₹<fmt:formatNumber value="${rProd.discountedPrice}" minFractionDigits="2" maxFractionDigits="2"/></div>
                                </div>
                            </a>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>
    </c:if>
</div>

<jsp:include page="fragments/footer.jsp" />
