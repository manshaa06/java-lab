<%@ tag language="java" pageEncoding="UTF-8" description="ShopSphere Reusable Product Card Tag File" %>
<%@ attribute name="product" required="true" type="com.shopsphere.model.Product" description="Product object" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>

<div class="col-12 col-sm-6 col-md-4 col-lg-3 mb-4">
    <div class="card h-100 product-card shadow-sm border-0 position-relative">
        <c:if test="${product.discount > 0}">
            <span class="badge bg-danger position-absolute top-0 start-0 m-3 px-2 py-1 shadow-sm">
                -${Math.round(product.discount)}% OFF
            </span>
        </c:if>

        <a href="${pageContext.request.contextPath}/product?id=${product.productId}" class="text-decoration-none">
            <div class="product-img-wrapper overflow-hidden bg-light position-relative" style="height: 220px;">
                <img src="${product.imageUrl != null ? product.imageUrl : 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=600&q=80'}"
                     class="card-img-top w-100 h-100 object-fit-cover product-zoom-img"
                     alt="${product.name}"
                     onerror="this.src='https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=600&q=80'">
            </div>
        </a>

        <div class="card-body d-flex flex-column p-3">
            <div class="d-flex justify-content-between align-items-center mb-1">
                <span class="text-uppercase text-muted fw-bold" style="font-size: 0.72rem; letter-spacing: 0.5px;">
                    ${product.brand}
                </span>
                <span class="badge ${product.stock > 0 ? 'bg-success-subtle text-success' : 'bg-danger-subtle text-danger'} rounded-pill" style="font-size: 0.7rem;">
                    ${product.stock > 0 ? 'In Stock' : 'Out of Stock'}
                </span>
            </div>

            <h6 class="card-title fw-semibold text-truncate mb-2" title="${product.name}">
                <a href="${pageContext.request.contextPath}/product?id=${product.productId}" class="text-dark text-decoration-none">
                    ${product.name}
                </a>
            </h6>

            <div class="mb-2">
                <tags:rating value="4.5" />
            </div>

            <div class="mt-auto pt-2 border-top">
                <div class="d-flex align-items-baseline mb-3">
                    <span class="fs-5 fw-bold text-primary">₹<fmt:formatNumber value="${product.discountedPrice}" type="number" minFractionDigits="2" maxFractionDigits="2"/></span>
                    <c:if test="${product.discount > 0}">
                        <span class="text-decoration-line-through text-muted small ms-2">₹<fmt:formatNumber value="${product.price}" type="number" minFractionDigits="2" maxFractionDigits="2"/></span>
                    </c:if>
                </div>

                <div class="d-grid gap-2 d-flex">
                    <c:choose>
                        <c:when test="${product.stock > 0}">
                            <form action="${pageContext.request.contextPath}/cart" method="post" class="flex-grow-1 m-0">
                                <input type="hidden" name="action" value="add">
                                <input type="hidden" name="productId" value="${product.productId}">
                                <input type="hidden" name="quantity" value="1">
                                <button type="submit" class="btn btn-primary btn-sm w-100 rounded-pill d-flex align-items-center justify-content-center gap-1 shadow-sm">
                                    <i class="bi bi-cart-plus"></i> Add to Cart
                                </button>
                            </form>
                        </c:when>
                        <c:otherwise>
                            <button class="btn btn-secondary btn-sm w-100 rounded-pill disabled" disabled>Sold Out</button>
                        </c:otherwise>
                    </c:choose>

                    <form action="${pageContext.request.contextPath}/wishlist" method="post" class="m-0">
                        <input type="hidden" name="action" value="add">
                        <input type="hidden" name="productId" value="${product.productId}">
                        <button type="submit" class="btn btn-outline-danger btn-sm rounded-circle p-2" title="Add to Wishlist" style="width: 34px; height: 34px; display: inline-flex; align-items: center; justify-content: center;">
                            <i class="bi bi-heart"></i>
                        </button>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>
