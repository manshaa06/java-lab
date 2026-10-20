<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle" value="Shopping Cart | ShopSphere" scope="request" />
<jsp:include page="fragments/header.jsp" />
<jsp:include page="fragments/navbar.jsp" />

<div class="container my-4">
    <!-- Breadcrumb -->
    <nav aria-label="breadcrumb" class="mb-4">
        <ol class="breadcrumb small">
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/" class="text-decoration-none">Home</a></li>
            <li class="breadcrumb-item active" aria-current="page">Shopping Cart</li>
        </ol>
    </nav>

    <div class="d-flex justify-content-between align-items-center mb-4">
        <h3 class="fw-bold mb-0">Your Shopping Cart</h3>
        <c:if test="${not empty cartItems}">
            <form action="${pageContext.request.contextPath}/cart" method="post" class="m-0">
                <input type="hidden" name="action" value="clear">
                <button type="submit" class="btn btn-outline-danger btn-sm rounded-pill" onclick="return confirm('Are you sure you want to empty your cart?')">
                    <i class="bi bi-trash3 me-1"></i> Clear Cart
                </button>
            </form>
        </c:if>
    </div>

    <c:choose>
        <c:when test="${not empty cartItems}">
            <div class="row g-4">
                <!-- Cart Items List Column -->
                <div class="col-lg-8">
                    <div class="card border-0 shadow-sm rounded-4 overflow-hidden bg-white mb-4">
                        <div class="table-responsive">
                            <table class="table align-middle mb-0">
                                <thead class="table-light small text-uppercase text-muted">
                                    <tr>
                                        <th class="ps-4">Product</th>
                                        <th>Price</th>
                                        <th>Quantity</th>
                                        <th>Subtotal</th>
                                        <th class="pe-4 text-end">Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="item" items="${cartItems}">
                                        <tr>
                                            <td class="ps-4 py-3">
                                                <div class="d-flex align-items-center gap-3">
                                                    <img src="${item.product.imageUrl}" class="rounded-3 object-fit-cover shadow-sm" style="width: 60px; height: 60px;" alt="${item.product.name}">
                                                    <div>
                                                        <div class="fw-semibold text-dark mb-0">
                                                            <a href="${pageContext.request.contextPath}/product?id=${item.productId}" class="text-dark text-decoration-none">
                                                                ${item.product.name}
                                                            </a>
                                                        </div>
                                                        <span class="small text-muted">${item.product.brand}</span>
                                                    </div>
                                                </div>
                                            </td>
                                            <td class="fw-semibold">
                                                ₹<fmt:formatNumber value="${item.product.discountedPrice}" minFractionDigits="2" maxFractionDigits="2"/>
                                            </td>
                                            <td>
                                                <form action="${pageContext.request.contextPath}/cart" method="post" class="d-flex align-items-center gap-1 m-0">
                                                    <input type="hidden" name="action" value="update">
                                                    <input type="hidden" name="cartId" value="${item.cartId}">
                                                    <button type="submit" name="quantity" value="${item.quantity - 1}" class="btn btn-sm btn-outline-secondary rounded-circle" style="width: 28px; height: 28px; padding: 0;">-</button>
                                                    <span class="px-2 fw-bold font-monospace">${item.quantity}</span>
                                                    <button type="submit" name="quantity" value="${item.quantity + 1}" class="btn btn-sm btn-outline-secondary rounded-circle" style="width: 28px; height: 28px; padding: 0;">+</button>
                                                </form>
                                            </td>
                                            <td class="fw-bold text-primary">
                                                ₹<fmt:formatNumber value="${item.subtotal}" minFractionDigits="2" maxFractionDigits="2"/>
                                            </td>
                                            <td class="pe-4 text-end">
                                                <form action="${pageContext.request.contextPath}/cart" method="post" class="m-0">
                                                    <input type="hidden" name="action" value="remove">
                                                    <input type="hidden" name="cartId" value="${item.cartId}">
                                                    <button type="submit" class="btn btn-link text-danger p-0" title="Remove item">
                                                        <i class="bi bi-trash fs-5"></i>
                                                    </button>
                                                </form>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <!-- Available Discount Coupons Callout -->
                    <div class="card border-0 shadow-sm rounded-4 p-3 bg-light-subtle mb-4">
                        <div class="d-flex align-items-center gap-2 mb-2">
                            <i class="bi bi-ticket-perforated-fill text-warning fs-5"></i>
                            <h6 class="fw-bold mb-0">Available Promotional Coupons</h6>
                        </div>
                        <div class="d-flex flex-wrap gap-2">
                            <span class="badge bg-white text-dark border p-2 rounded-3">
                                <strong>WELCOME50</strong> (50% OFF up to ₹500, Min ₹999)
                            </span>
                            <span class="badge bg-white text-dark border p-2 rounded-3">
                                <strong>SHOP100</strong> (Flat ₹100 OFF, Min ₹499)
                            </span>
                            <span class="badge bg-white text-dark border p-2 rounded-3">
                                <strong>FESTIVE20</strong> (20% OFF up to ₹1000, Min ₹1500)
                            </span>
                        </div>
                    </div>
                </div>

                <!-- Order Summary Column -->
                <div class="col-lg-4">
                    <div class="card border-0 shadow-sm rounded-4 p-4 bg-white sticky-top" style="top: 90px;">
                        <h5 class="fw-bold mb-3 pb-2 border-bottom">Order Summary</h5>

                        <!-- Coupon Input Form -->
                        <form action="${pageContext.request.contextPath}/cart" method="post" class="mb-4">
                            <input type="hidden" name="action" value="applyCoupon">
                            <label class="form-label small fw-semibold text-muted">Promo / Coupon Code</label>
                            <div class="input-group">
                                <input type="text" name="couponCode" class="form-control form-control-sm text-uppercase font-monospace" placeholder="Enter coupon code" value="${sessionScope.appliedCoupon}">
                                <button type="submit" class="btn btn-dark btn-sm px-3">Apply</button>
                            </div>
                            <c:if test="${not empty sessionScope.appliedCoupon}">
                                <div class="mt-2 d-flex justify-content-between align-items-center">
                                    <span class="badge bg-success-subtle text-success">
                                        <i class="bi bi-check2"></i> ${sessionScope.appliedCoupon} applied
                                    </span>
                                    <a href="${pageContext.request.contextPath}/cart?action=removeCoupon" class="text-danger small text-decoration-none">Remove</a>
                                </div>
                            </c:if>
                        </form>

                        <div class="d-flex justify-content-between mb-2 small text-secondary">
                            <span>Subtotal</span>
                            <span class="fw-semibold text-dark">₹<fmt:formatNumber value="${summary.subtotal}" minFractionDigits="2" maxFractionDigits="2"/></span>
                        </div>

                        <c:if test="${summary.discount > 0}">
                            <div class="d-flex justify-content-between mb-2 small text-success">
                                <span>Coupon Discount</span>
                                <span class="fw-semibold">-₹<fmt:formatNumber value="${summary.discount}" minFractionDigits="2" maxFractionDigits="2"/></span>
                            </div>
                        </c:if>

                        <div class="d-flex justify-content-between mb-3 small text-secondary">
                            <span>Shipping Estimated</span>
                            <span class="fw-semibold text-dark">
                                ${summary.shippingFee == 0.0 ? '<span class="badge bg-success-subtle text-success">FREE</span>' : '₹'.concat(summary.shippingFee)}
                            </span>
                        </div>

                        <div class="pt-3 border-top mb-4 d-flex justify-content-between align-items-center">
                            <span class="fw-bold fs-5">Grand Total</span>
                            <span class="fw-bold fs-4 text-primary">₹<fmt:formatNumber value="${summary.grandTotal}" minFractionDigits="2" maxFractionDigits="2"/></span>
                        </div>

                        <a href="${pageContext.request.contextPath}/checkout" class="btn btn-primary w-100 py-3 rounded-pill fw-semibold shadow-sm d-flex align-items-center justify-content-center gap-2">
                            <i class="bi bi-credit-card"></i> Proceed to Checkout
                        </a>
                    </div>
                </div>
            </div>
        </c:when>

        <c:otherwise>
            <div class="card border-0 shadow-sm rounded-4 p-5 text-center my-4 bg-white">
                <div class="text-muted mb-3">
                    <i class="bi bi-cart-x fs-1 text-secondary"></i>
                </div>
                <h4 class="fw-bold mb-2">Your Shopping Cart is Empty</h4>
                <p class="text-muted small mb-4">Looks like you haven't added anything to your cart yet.</p>
                <div>
                    <a href="${pageContext.request.contextPath}/products" class="btn btn-primary rounded-pill px-4 shadow-sm">
                        <i class="bi bi-bag-plus me-1"></i> Start Shopping Catalog
                    </a>
                </div>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<jsp:include page="fragments/footer.jsp" />
