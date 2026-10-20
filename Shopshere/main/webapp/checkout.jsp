<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle" value="Secure Checkout | ShopSphere" scope="request" />
<jsp:include page="fragments/header.jsp" />
<jsp:include page="fragments/navbar.jsp" />

<div class="container my-4">
    <!-- Breadcrumb -->
    <nav aria-label="breadcrumb" class="mb-4">
        <ol class="breadcrumb small">
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/" class="text-decoration-none">Home</a></li>
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/cart" class="text-decoration-none">Cart</a></li>
            <li class="breadcrumb-item active" aria-current="page">Checkout</li>
        </ol>
    </nav>

    <div class="d-flex align-items-center gap-2 mb-4">
        <h3 class="fw-bold mb-0">Order Checkout &amp; Payment</h3>
        <span class="badge bg-success-subtle text-success ms-2"><i class="bi bi-shield-lock-fill me-1"></i>256-Bit Encrypted</span>
    </div>

    <form action="${pageContext.request.contextPath}/checkout" method="post" id="checkoutForm">
        <div class="row g-4">
            <!-- Left Column: Shipping & Payment Details -->
            <div class="col-lg-8">
                <!-- 1. Delivery Address Card -->
                <div class="card border-0 shadow-sm rounded-4 p-4 bg-white mb-4">
                    <div class="d-flex align-items-center gap-2 mb-3 pb-2 border-bottom">
                        <span class="badge bg-primary rounded-circle d-flex align-items-center justify-content-center" style="width: 28px; height: 28px;">1</span>
                        <h5 class="fw-bold mb-0">Delivery Address</h5>
                    </div>

                    <c:choose>
                        <c:when test="${not empty addresses}">
                            <div class="d-flex flex-column gap-3 mb-3">
                                <c:forEach var="addr" items="${addresses}" varStatus="status">
                                    <div class="form-check p-3 rounded-3 border bg-light-subtle address-select-item">
                                        <input class="form-check-input ms-0 me-3" type="radio" name="addressId" id="addr_${addr.addressId}" value="${addr.addressId}" ${status.first ? 'checked' : ''} onchange="toggleNewAddress(false)">
                                        <label class="form-check-label w-100" for="addr_${addr.addressId}">
                                            <div class="d-flex justify-content-between align-items-center mb-1">
                                                <span class="fw-bold text-dark">${sessionScope.user.name}</span>
                                                <span class="badge bg-secondary-subtle text-secondary">${addr.addressType}</span>
                                            </div>
                                            <div class="small text-secondary">${addr.formattedAddress}</div>
                                        </label>
                                    </div>
                                </c:forEach>

                                <div class="form-check p-3 rounded-3 border bg-white">
                                    <input class="form-check-input ms-0 me-3" type="radio" name="addressId" id="addr_new" value="new" onchange="toggleNewAddress(true)">
                                    <label class="form-check-label fw-semibold text-primary" for="addr_new">
                                        + Deliver to a Different / New Address
                                    </label>
                                </div>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <input type="hidden" name="addressId" value="new">
                        </c:otherwise>
                    </c:choose>

                    <!-- New Address Input Fields (Visible if no addresses or if user chose new) -->
                    <div id="newAddressSection" class="${not empty addresses ? 'd-none' : ''} p-3 rounded-3 bg-light border">
                        <h6 class="fw-bold mb-3 text-secondary">Enter Shipping Address Details</h6>
                        <div class="row g-3">
                            <div class="col-12">
                                <label class="form-label small fw-semibold">Street / Flat / House No.</label>
                                <input type="text" class="form-control" name="newAddressLine" placeholder="Plot 42, Malviya Nagar, Sector 3">
                            </div>
                            <div class="col-md-5">
                                <label class="form-label small fw-semibold">City</label>
                                <input type="text" class="form-control" name="newCity" placeholder="Jaipur">
                            </div>
                            <div class="col-md-4">
                                <label class="form-label small fw-semibold">State</label>
                                <input type="text" class="form-control" name="newState" placeholder="Rajasthan">
                            </div>
                            <div class="col-md-3">
                                <label class="form-label small fw-semibold">Pincode</label>
                                <input type="text" class="form-control" name="newPincode" placeholder="302017">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label small fw-semibold">Address Type</label>
                                <select name="newAddressType" class="form-select">
                                    <option value="HOME">Home (7am - 9pm)</option>
                                    <option value="WORK">Work / Office (9am - 6pm)</option>
                                    <option value="CAMPUS">Hostel / Campus</option>
                                </select>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- 2. Payment Method Card -->
                <div class="card border-0 shadow-sm rounded-4 p-4 bg-white mb-4">
                    <div class="d-flex align-items-center gap-2 mb-3 pb-2 border-bottom">
                        <span class="badge bg-primary rounded-circle d-flex align-items-center justify-content-center" style="width: 28px; height: 28px;">2</span>
                        <h5 class="fw-bold mb-0">Select Payment Method</h5>
                    </div>

                    <div class="d-flex flex-column gap-3">
                        <div class="form-check p-3 rounded-3 border bg-light-subtle">
                            <input class="form-check-input ms-0 me-3" type="radio" name="paymentMethod" id="payUPI" value="UPI" checked>
                            <label class="form-check-label d-flex align-items-center justify-content-between w-100" for="payUPI">
                                <div>
                                    <div class="fw-bold text-dark"><i class="bi bi-qr-code-scan text-primary me-2"></i>UPI (Google Pay / PhonePe / Paytm)</div>
                                    <div class="small text-muted">Instant zero-fee settlement via Virtual Payment Address</div>
                                </div>
                                <span class="badge bg-success-subtle text-success">Recommended</span>
                            </label>
                        </div>

                        <div class="form-check p-3 rounded-3 border bg-light-subtle">
                            <input class="form-check-input ms-0 me-3" type="radio" name="paymentMethod" id="payCard" value="CREDIT_CARD">
                            <label class="form-check-label" for="payCard">
                                <div class="fw-bold text-dark"><i class="bi bi-credit-card-2-front text-primary me-2"></i>Credit or Debit Card</div>
                                <div class="small text-muted">Visa, MasterCard, RuPay, Maestro</div>
                            </label>
                        </div>

                        <div class="form-check p-3 rounded-3 border bg-light-subtle">
                            <input class="form-check-input ms-0 me-3" type="radio" name="paymentMethod" id="payNet" value="NET_BANKING">
                            <label class="form-check-label" for="payNet">
                                <div class="fw-bold text-dark"><i class="bi bi-bank text-primary me-2"></i>Net Banking</div>
                                <div class="small text-muted">HDFC, SBI, ICICI, Axis and 50+ banks</div>
                            </label>
                        </div>

                        <div class="form-check p-3 rounded-3 border bg-light-subtle">
                            <input class="form-check-input ms-0 me-3" type="radio" name="paymentMethod" id="payCOD" value="COD">
                            <label class="form-check-label" for="payCOD">
                                <div class="fw-bold text-dark"><i class="bi bi-cash-stack text-primary me-2"></i>Cash on Delivery (COD)</div>
                                <div class="small text-muted">Pay at doorstep upon package verification</div>
                            </label>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Right Column: Order Review & Placement -->
            <div class="col-lg-4">
                <div class="card border-0 shadow-sm rounded-4 p-4 bg-white sticky-top" style="top: 90px;">
                    <h5 class="fw-bold mb-3 pb-2 border-bottom">Items in Order (${cartItems.size()})</h5>

                    <div class="overflow-auto mb-3" style="max-height: 220px;">
                        <c:forEach var="item" items="${cartItems}">
                            <div class="d-flex align-items-center gap-2 mb-2 pb-2 border-bottom border-light">
                                <img src="${item.product.imageUrl}" class="rounded-2 object-fit-cover" style="width: 40px; height: 40px;" alt="">
                                <div class="flex-grow-1 text-truncate">
                                    <div class="small fw-semibold text-truncate">${item.product.name}</div>
                                    <div class="text-muted" style="font-size: 0.75rem;">Qty: ${item.quantity} × ₹<fmt:formatNumber value="${item.product.discountedPrice}" minFractionDigits="2" maxFractionDigits="2"/></div>
                                </div>
                                <span class="small fw-bold">₹<fmt:formatNumber value="${item.subtotal}" minFractionDigits="2" maxFractionDigits="2"/></span>
                            </div>
                        </c:forEach>
                    </div>

                    <div class="d-flex justify-content-between mb-2 small text-secondary">
                        <span>Items Subtotal</span>
                        <span class="fw-semibold text-dark">₹<fmt:formatNumber value="${summary.subtotal}" minFractionDigits="2" maxFractionDigits="2"/></span>
                    </div>

                    <c:if test="${summary.discount > 0}">
                        <div class="d-flex justify-content-between mb-2 small text-success">
                            <span>Promo Discount (${sessionScope.appliedCoupon})</span>
                            <span class="fw-semibold">-₹<fmt:formatNumber value="${summary.discount}" minFractionDigits="2" maxFractionDigits="2"/></span>
                        </div>
                    </c:if>

                    <div class="d-flex justify-content-between mb-3 small text-secondary">
                        <span>Delivery Fee</span>
                        <span class="fw-semibold text-dark">
                            ${summary.shippingFee == 0.0 ? '<span class="badge bg-success-subtle text-success">FREE</span>' : '₹'.concat(summary.shippingFee)}
                        </span>
                    </div>

                    <div class="pt-3 border-top mb-4 d-flex justify-content-between align-items-center">
                        <span class="fw-bold fs-5">Final Payable</span>
                        <span class="fw-bold fs-4 text-primary">₹<fmt:formatNumber value="${summary.grandTotal}" minFractionDigits="2" maxFractionDigits="2"/></span>
                    </div>

                    <button type="submit" id="placeOrderBtn" class="btn btn-primary w-100 py-3 rounded-pill fw-semibold shadow-sm d-flex align-items-center justify-content-center gap-2">
                        <i class="bi bi-lock-fill"></i> Confirm &amp; Place Order
                    </button>

                    <div class="mt-3 text-center small text-muted">
                        <i class="bi bi-shield-check text-success me-1"></i> ACID Transaction &amp; Stock Auto-deducted
                    </div>
                </div>
            </div>
        </div>
    </form>
</div>

<script>
function toggleNewAddress(show) {
    const el = document.getElementById('newAddressSection');
    if (show) {
        el.classList.remove('d-none');
    } else {
        el.classList.add('d-none');
    }
}
</script>

<jsp:include page="fragments/footer.jsp" />
