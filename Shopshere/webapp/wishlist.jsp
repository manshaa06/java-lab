<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle" value="My Wishlist | ShopSphere" scope="request" />
<jsp:include page="fragments/header.jsp" />
<jsp:include page="fragments/navbar.jsp" />

<div class="container my-4">
    <!-- Breadcrumb -->
    <nav aria-label="breadcrumb" class="mb-4">
        <ol class="breadcrumb small">
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/" class="text-decoration-none">Home</a></li>
            <li class="breadcrumb-item active" aria-current="page">My Wishlist</li>
        </ol>
    </nav>

    <div class="d-flex justify-content-between align-items-center mb-4">
        <h3 class="fw-bold mb-0">Saved Wishlist Items</h3>
        <span class="badge bg-light text-dark border px-3 py-2 rounded-pill">${wishlist.size()} Items Saved</span>
    </div>

    <c:choose>
        <c:when test="${not empty wishlist}">
            <div class="row g-4">
                <c:forEach var="wItem" items="${wishlist}">
                    <div class="col-12 col-sm-6 col-md-4 col-lg-3">
                        <div class="card h-100 border-0 shadow-sm rounded-4 overflow-hidden bg-white">
                            <a href="${pageContext.request.contextPath}/product?id=${wItem.productId}">
                                <img src="${wItem.product.imageUrl}" class="card-img-top object-fit-cover" style="height: 200px;" alt="${wItem.product.name}">
                            </a>
                            <div class="card-body d-flex flex-column p-3">
                                <span class="small text-uppercase text-muted fw-bold">${wItem.product.brand}</span>
                                <h6 class="fw-semibold text-truncate mb-2">
                                    <a href="${pageContext.request.contextPath}/product?id=${wItem.productId}" class="text-dark text-decoration-none">
                                        ${wItem.product.name}
                                    </a>
                                </h6>
                                <div class="fs-5 fw-bold text-primary mb-3">
                                    ₹<fmt:formatNumber value="${wItem.product.discountedPrice}" minFractionDigits="2" maxFractionDigits="2"/>
                                </div>

                                <div class="mt-auto d-grid gap-2">
                                    <form action="${pageContext.request.contextPath}/wishlist" method="post" class="m-0">
                                        <input type="hidden" name="action" value="moveToCart">
                                        <input type="hidden" name="productId" value="${wItem.productId}">
                                        <button type="submit" class="btn btn-primary btn-sm rounded-pill w-100">
                                            <i class="bi bi-cart-plus me-1"></i> Move to Cart
                                        </button>
                                    </form>
                                    <form action="${pageContext.request.contextPath}/wishlist" method="post" class="m-0">
                                        <input type="hidden" name="action" value="remove">
                                        <input type="hidden" name="productId" value="${wItem.productId}">
                                        <button type="submit" class="btn btn-outline-danger btn-sm rounded-pill w-100">
                                            <i class="bi bi-trash me-1"></i> Remove
                                        </button>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:when>
        <c:otherwise>
            <div class="card border-0 shadow-sm rounded-4 p-5 text-center my-4 bg-white">
                <div class="text-muted mb-3">
                    <i class="bi bi-heart fs-1 text-secondary"></i>
                </div>
                <h4 class="fw-bold mb-2">Your Wishlist is Empty</h4>
                <p class="text-muted small mb-4">Save your favorite products to buy later or monitor discounts.</p>
                <div>
                    <a href="${pageContext.request.contextPath}/products" class="btn btn-primary rounded-pill px-4 shadow-sm">
                        Explore Catalog
                    </a>
                </div>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<jsp:include page="fragments/footer.jsp" />
