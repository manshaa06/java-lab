<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle" value="My Orders | ShopSphere" scope="request" />
<jsp:include page="fragments/header.jsp" />
<jsp:include page="fragments/navbar.jsp" />

<div class="container my-4">
    <!-- Breadcrumb -->
    <nav aria-label="breadcrumb" class="mb-4">
        <ol class="breadcrumb small">
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/" class="text-decoration-none">Home</a></li>
            <li class="breadcrumb-item active" aria-current="page">My Orders</li>
        </ol>
    </nav>

    <div class="d-flex justify-content-between align-items-center mb-4">
        <h3 class="fw-bold mb-0">Order History &amp; Tracking</h3>
        <span class="badge bg-light text-dark border px-3 py-2 rounded-pill">${orders.size()} Orders Found</span>
    </div>

    <c:choose>
        <c:when test="${not empty orders}">
            <div class="d-flex flex-column gap-3">
                <c:forEach var="ord" items="${orders}">
                    <div class="card border-0 shadow-sm rounded-4 overflow-hidden bg-white">
                        <div class="card-header bg-light py-3 border-0 d-flex flex-wrap justify-content-between align-items-center gap-2">
                            <div class="d-flex gap-4 small text-secondary">
                                <div>
                                    <span class="text-uppercase text-muted" style="font-size: 0.72rem;">Order Placed</span>
                                    <div class="fw-semibold text-dark">${ord.createdAt}</div>
                                </div>
                                <div>
                                    <span class="text-uppercase text-muted" style="font-size: 0.72rem;">Total Amount</span>
                                    <div class="fw-bold text-primary">₹<fmt:formatNumber value="${ord.totalAmount}" minFractionDigits="2" maxFractionDigits="2"/></div>
                                </div>
                                <div>
                                    <span class="text-uppercase text-muted" style="font-size: 0.72rem;">Ship To</span>
                                    <div class="fw-semibold text-dark">${ord.address.city}, ${ord.address.state}</div>
                                </div>
                            </div>

                            <div class="d-flex align-items-center gap-2">
                                <span class="badge ${ord.orderStatus == 'DELIVERED' ? 'bg-success' : (ord.orderStatus == 'CANCELLED' ? 'bg-danger' : 'bg-primary')} px-3 py-2 rounded-pill">
                                    ${ord.orderStatus}
                                </span>
                                <a href="${pageContext.request.contextPath}/order-details?id=${ord.orderId}" class="btn btn-outline-primary btn-sm rounded-pill px-3">
                                    Track Order <i class="bi bi-chevron-right ms-1"></i>
                                </a>
                            </div>
                        </div>

                        <div class="card-body p-3">
                            <div class="d-flex flex-wrap align-items-center gap-3">
                                <c:forEach var="item" items="${ord.items}">
                                    <div class="d-flex align-items-center gap-2 bg-light-subtle p-2 rounded-3 border">
                                        <img src="${item.product.imageUrl}" class="rounded-2 object-fit-cover" style="width: 48px; height: 48px;" alt="${item.product.name}">
                                        <div>
                                            <div class="small fw-semibold text-truncate" style="max-width: 180px;">${item.product.name}</div>
                                            <span class="small text-muted">Qty: ${item.quantity}</span>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:when>

        <c:otherwise>
            <div class="card border-0 shadow-sm rounded-4 p-5 text-center my-4 bg-white">
                <div class="text-muted mb-3">
                    <i class="bi bi-box2 fs-1 text-secondary"></i>
                </div>
                <h4 class="fw-bold mb-2">No Orders Found</h4>
                <p class="text-muted small mb-4">You have not placed any orders yet.</p>
                <div>
                    <a href="${pageContext.request.contextPath}/products" class="btn btn-primary rounded-pill px-4 shadow-sm">
                        Browse Products Catalog
                    </a>
                </div>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<jsp:include page="fragments/footer.jsp" />
