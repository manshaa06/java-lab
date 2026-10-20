<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle" value="Order #${order.orderId} Details | ShopSphere" scope="request" />
<jsp:include page="fragments/header.jsp" />
<jsp:include page="fragments/navbar.jsp" />

<div class="container my-4">
    <!-- Breadcrumb -->
    <nav aria-label="breadcrumb" class="mb-4">
        <ol class="breadcrumb small">
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/" class="text-decoration-none">Home</a></li>
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/orders" class="text-decoration-none">My Orders</a></li>
            <li class="breadcrumb-item active" aria-current="page">Order #${order.orderId}</li>
        </ol>
    </nav>

    <!-- Header Actions -->
    <div class="d-flex flex-wrap justify-content-between align-items-center gap-3 mb-4">
        <div>
            <h3 class="fw-bold mb-1">Order #${order.orderId}</h3>
            <span class="text-muted small">Placed on ${order.createdAt}</span>
        </div>
        <div class="d-flex gap-2">
            <button class="btn btn-outline-secondary btn-sm rounded-pill px-3" onclick="window.print()">
                <i class="bi bi-printer me-1"></i> Print Invoice
            </button>
            <a href="${pageContext.request.contextPath}/orders" class="btn btn-primary btn-sm rounded-pill px-3">
                <i class="bi bi-arrow-left me-1"></i> Back to Orders
            </a>
        </div>
    </div>

    <!-- Order Status Timeline Card -->
    <div class="card border-0 shadow-sm rounded-4 p-4 bg-white mb-4">
        <h6 class="fw-bold text-uppercase text-muted small mb-4" style="letter-spacing: 0.5px;">Order Fulfillment Timeline</h6>
        <div class="row text-center g-3 position-relative">
            <div class="col-3">
                <div class="p-2">
                    <div class="rounded-circle d-inline-flex align-items-center justify-content-center bg-success text-white mb-2" style="width: 44px; height: 44px;">
                        <i class="bi bi-check2 fs-5"></i>
                    </div>
                    <div class="fw-bold small text-dark">Confirmed</div>
                    <div class="text-muted" style="font-size: 0.72rem;">Order Received</div>
                </div>
            </div>
            <div class="col-3">
                <div class="p-2">
                    <div class="rounded-circle d-inline-flex align-items-center justify-content-center ${order.orderStatus == 'PROCESSING' || order.orderStatus == 'SHIPPED' || order.orderStatus == 'DELIVERED' ? 'bg-success text-white' : 'bg-light text-muted border'} mb-2" style="width: 44px; height: 44px;">
                        <i class="bi bi-box-seam fs-5"></i>
                    </div>
                    <div class="fw-bold small text-dark">Processing</div>
                    <div class="text-muted" style="font-size: 0.72rem;">Packed &amp; Assigned</div>
                </div>
            </div>
            <div class="col-3">
                <div class="p-2">
                    <div class="rounded-circle d-inline-flex align-items-center justify-content-center ${order.orderStatus == 'SHIPPED' || order.orderStatus == 'DELIVERED' ? 'bg-success text-white' : 'bg-light text-muted border'} mb-2" style="width: 44px; height: 44px;">
                        <i class="bi bi-truck fs-5"></i>
                    </div>
                    <div class="fw-bold small text-dark">Shipped</div>
                    <div class="text-muted" style="font-size: 0.72rem;">In Transit</div>
                </div>
            </div>
            <div class="col-3">
                <div class="p-2">
                    <div class="rounded-circle d-inline-flex align-items-center justify-content-center ${order.orderStatus == 'DELIVERED' ? 'bg-success text-white' : 'bg-light text-muted border'} mb-2" style="width: 44px; height: 44px;">
                        <i class="bi bi-house-door fs-5"></i>
                    </div>
                    <div class="fw-bold small text-dark">Delivered</div>
                    <div class="text-muted" style="font-size: 0.72rem;">Received by Customer</div>
                </div>
            </div>
        </div>
    </div>

    <!-- Items and Details Grid -->
    <div class="row g-4">
        <!-- Items Table Column -->
        <div class="col-lg-8">
            <div class="card border-0 shadow-sm rounded-4 overflow-hidden bg-white">
                <div class="card-header bg-white py-3 border-0">
                    <h5 class="fw-bold mb-0">Ordered Items (${order.items.size()})</h5>
                </div>
                <div class="table-responsive">
                    <table class="table align-middle mb-0">
                        <thead class="table-light small text-uppercase text-muted">
                            <tr>
                                <th class="ps-4">Item Details</th>
                                <th>Unit Price</th>
                                <th>Quantity</th>
                                <th class="pe-4 text-end">Total</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="item" items="${order.items}">
                                <tr>
                                    <td class="ps-4 py-3">
                                        <div class="d-flex align-items-center gap-3">
                                            <img src="${item.product.imageUrl}" class="rounded-3 object-fit-cover shadow-sm" style="width: 50px; height: 50px;" alt="">
                                            <div>
                                                <div class="fw-semibold text-dark">${item.product.name}</div>
                                                <span class="small text-muted">${item.product.brand}</span>
                                            </div>
                                        </div>
                                    </td>
                                    <td>₹<fmt:formatNumber value="${item.price}" minFractionDigits="2" maxFractionDigits="2"/></td>
                                    <td class="fw-bold font-monospace">${item.quantity}</td>
                                    <td class="pe-4 text-end fw-bold text-primary">₹<fmt:formatNumber value="${item.subtotal}" minFractionDigits="2" maxFractionDigits="2"/></td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <!-- Shipping & Payment Column -->
        <div class="col-lg-4">
            <!-- Shipping Card -->
            <div class="card border-0 shadow-sm rounded-4 p-4 bg-white mb-4">
                <h6 class="fw-bold text-uppercase text-muted small mb-3" style="letter-spacing: 0.5px;">Delivery Destination</h6>
                <div class="fw-bold text-dark mb-1">${order.user.name}</div>
                <div class="small text-secondary mb-2">${order.address.formattedAddress}</div>
                <div class="small text-muted"><i class="bi bi-telephone me-1"></i> ${order.user.mobile}</div>
            </div>

            <!-- Payment Card -->
            <div class="card border-0 shadow-sm rounded-4 p-4 bg-white">
                <h6 class="fw-bold text-uppercase text-muted small mb-3" style="letter-spacing: 0.5px;">Payment Summary</h6>
                <div class="d-flex justify-content-between mb-2 small text-secondary">
                    <span>Payment Method:</span>
                    <span class="fw-bold text-dark">${order.paymentMethod}</span>
                </div>
                <div class="d-flex justify-content-between mb-2 small text-secondary">
                    <span>Transaction Ref:</span>
                    <span class="font-monospace text-truncate" style="max-width: 140px;">${order.payment.transactionReference}</span>
                </div>
                <div class="d-flex justify-content-between mb-2 small text-secondary">
                    <span>Payment Status:</span>
                    <span class="badge bg-success-subtle text-success">${order.paymentStatus}</span>
                </div>
                <c:if test="${order.discount > 0}">
                    <div class="d-flex justify-content-between mb-2 small text-success">
                        <span>Discount Applied:</span>
                        <span class="fw-bold">-₹<fmt:formatNumber value="${order.discount}" minFractionDigits="2" maxFractionDigits="2"/></span>
                    </div>
                </c:if>
                <div class="pt-3 border-top d-flex justify-content-between align-items-center">
                    <span class="fw-bold fs-6">Total Paid:</span>
                    <span class="fw-bold fs-5 text-primary">₹<fmt:formatNumber value="${order.totalAmount}" minFractionDigits="2" maxFractionDigits="2"/></span>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="fragments/footer.jsp" />
