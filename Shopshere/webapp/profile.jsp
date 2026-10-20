<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="pageTitle" value="My Profile | ShopSphere" scope="request" />
<jsp:include page="fragments/header.jsp" />
<jsp:include page="fragments/navbar.jsp" />

<div class="container my-4">
    <!-- Breadcrumb -->
    <nav aria-label="breadcrumb" class="mb-4">
        <ol class="breadcrumb small">
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/" class="text-decoration-none">Home</a></li>
            <li class="breadcrumb-item active" aria-current="page">Account Profile</li>
        </ol>
    </nav>

    <div class="row g-4">
        <!-- Profile Sidebar Column -->
        <div class="col-lg-4">
            <div class="card border-0 shadow-sm rounded-4 p-4 text-center bg-white mb-4">
                <div class="rounded-circle bg-primary-subtle text-primary d-inline-flex align-items-center justify-content-center mx-auto mb-3" style="width: 80px; height: 80px;">
                    <i class="bi bi-person-fill fs-1"></i>
                </div>
                <h5 class="fw-bold mb-1">${user.name}</h5>
                <p class="text-muted small mb-2">${user.email}</p>
                <div class="d-flex justify-content-center gap-2 mb-3">
                    <span class="badge bg-primary px-3 py-1 rounded-pill">${user.role}</span>
                    <span class="badge bg-success-subtle text-success px-3 py-1 rounded-pill">${user.status}</span>
                </div>
                <div class="text-muted small border-top pt-3">
                    <i class="bi bi-calendar-event me-1"></i> Member since ${user.createdAt}
                </div>
            </div>

            <!-- Language Preferences (Section 23 I18N Demonstration) -->
            <div class="card border-0 shadow-sm rounded-4 p-4 bg-white">
                <h6 class="fw-bold mb-3"><i class="bi bi-translate text-primary me-2"></i>Language Preferences</h6>
                <div class="d-grid gap-2">
                    <a href="${pageContext.request.contextPath}/profile?action=setLang&lang=en" class="btn btn-sm ${sessionScope.lang != 'hi' ? 'btn-primary' : 'btn-outline-secondary'} rounded-pill">
                        English (Default)
                    </a>
                    <a href="${pageContext.request.contextPath}/profile?action=setLang&lang=hi" class="btn btn-sm ${sessionScope.lang == 'hi' ? 'btn-primary' : 'btn-outline-secondary'} rounded-pill">
                        हिन्दी (Hindi)
                    </a>
                </div>
            </div>
        </div>

        <!-- Details & Addresses Column -->
        <div class="col-lg-8">
            <!-- Edit Profile Card -->
            <div class="card border-0 shadow-sm rounded-4 p-4 bg-white mb-4">
                <h5 class="fw-bold mb-3 pb-2 border-bottom">Personal Details</h5>
                <form action="${pageContext.request.contextPath}/profile" method="post">
                    <input type="hidden" name="action" value="updateProfile">

                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label small fw-semibold text-muted">Full Name</label>
                            <input type="text" class="form-control" name="name" value="${user.name}" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label small fw-semibold text-muted">Email (Cannot be modified)</label>
                            <input type="email" class="form-control bg-light" value="${user.email}" readonly>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label small fw-semibold text-muted">Mobile Number</label>
                            <input type="tel" class="form-control" name="mobile" value="${user.mobile}" required>
                        </div>
                        <div class="col-12 mt-4">
                            <button type="submit" class="btn btn-primary rounded-pill px-4">
                                Save Profile Changes
                            </button>
                        </div>
                    </div>
                </form>
            </div>

            <!-- Saved Addresses Card -->
            <div class="card border-0 shadow-sm rounded-4 p-4 bg-white">
                <div class="d-flex justify-content-between align-items-center mb-3 pb-2 border-bottom">
                    <h5 class="fw-bold mb-0">Saved Delivery Addresses</h5>
                    <button class="btn btn-outline-primary btn-sm rounded-pill" type="button" data-bs-toggle="collapse" data-bs-target="#addAddressCollapse">
                        + Add New Address
                    </button>
                </div>

                <!-- Add Address Collapse -->
                <div class="collapse mb-4" id="addAddressCollapse">
                    <div class="p-3 bg-light rounded-3 border">
                        <h6 class="fw-bold mb-3">Add New Address</h6>
                        <form action="${pageContext.request.contextPath}/profile" method="post">
                            <input type="hidden" name="action" value="addAddress">
                            <div class="row g-3">
                                <div class="col-12">
                                    <input type="text" class="form-control form-control-sm" name="addressLine" placeholder="Address Line / Street" required>
                                </div>
                                <div class="col-md-5">
                                    <input type="text" class="form-control form-control-sm" name="city" placeholder="City" required>
                                </div>
                                <div class="col-md-4">
                                    <input type="text" class="form-control form-control-sm" name="state" placeholder="State" required>
                                </div>
                                <div class="col-md-3">
                                    <input type="text" class="form-control form-control-sm" name="pincode" placeholder="Pincode" required>
                                </div>
                                <div class="col-md-6">
                                    <select name="addressType" class="form-select form-select-sm">
                                        <option value="HOME">Home</option>
                                        <option value="WORK">Work / Office</option>
                                    </select>
                                </div>
                                <div class="col-12">
                                    <button type="submit" class="btn btn-success btn-sm rounded-pill px-3">Save Address</button>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>

                <div class="d-flex flex-column gap-3">
                    <c:forEach var="addr" items="${addresses}">
                        <div class="p-3 bg-light-subtle rounded-3 border d-flex justify-content-between align-items-center">
                            <div>
                                <span class="badge bg-secondary-subtle text-secondary mb-1">${addr.addressType}</span>
                                <div class="small text-dark fw-semibold">${addr.formattedAddress}</div>
                            </div>
                            <form action="${pageContext.request.contextPath}/profile" method="post" class="m-0">
                                <input type="hidden" name="action" value="deleteAddress">
                                <input type="hidden" name="addressId" value="${addr.addressId}">
                                <button type="submit" class="btn btn-link text-danger p-0" title="Delete address">
                                    <i class="bi bi-trash"></i>
                                </button>
                            </form>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="fragments/footer.jsp" />
