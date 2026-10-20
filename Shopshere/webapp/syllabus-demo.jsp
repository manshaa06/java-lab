<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="x" uri="jakarta.tags.xml" %>
<%@ taglib prefix="shopsphere" uri="http://shopsphere.com/tags" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>

<%-- ========================================================
     RTU ADVANCED JAVA SYLLABUS TOPIC: JSP SCRIPTING ELEMENTS
     Demonstrating Declaration, Scriptlet, Expression & Comments
     ======================================================== --%>

<%! 
    // 1. JSP Declaration Element (<%! %>): Class-level fields & methods
    private int demoHitCount = 108;
    public String getSyllabusCode() {
        return "RTU-CS-ADV-JAVA-2026";
    }
%>

<%
    // 2. JSP Scriptlet Element (<% %>): Request-level execution block
    demoHitCount++;
    String labStudent = (session.getAttribute("user") != null) ? 
        ((com.shopsphere.model.User) session.getAttribute("user")).getName() : "Scholar / Viva Examiner";
    String serverTime = new java.text.SimpleDateFormat("dd-MM-yyyy HH:mm:ss").format(new java.util.Date());
%>

<c:set var="pageTitle" value="RTU Syllabus Demonstration Lab | ShopSphere" scope="request" />
<jsp:include page="fragments/header.jsp" />
<jsp:include page="fragments/navbar.jsp" />

<div class="container my-4">
    <!-- Lab Hero -->
    <div class="p-4 p-md-5 rounded-4 bg-dark text-white mb-4 shadow-sm border border-secondary border-opacity-25">
        <div class="row align-items-center">
            <div class="col-lg-8">
                <span class="badge bg-warning text-dark px-3 py-1 rounded-pill fw-bold mb-2">
                    <i class="bi bi-mortarboard-fill me-1"></i> RTU Syllabus Viva Lab
                </span>
                <h2 class="display-6 fw-bold mb-2">Advanced Java Enterprise Showcase</h2>
                <p class="text-white-50 lead mb-0">
                    Live interactive demonstrations of every required syllabus topic: Applets, JSP elements, JSTL (Core, XML, Functions), JNDI, java.net Networking, RMI, and Serialization.
                </p>
            </div>
            <div class="col-lg-4 text-lg-end mt-3 mt-lg-0">
                <div class="bg-black bg-opacity-40 p-3 rounded-3 border border-secondary border-opacity-25 text-start font-monospace small">
                    <div><strong>Course:</strong> Advanced Java Lab</div>
                    <div><strong>Code:</strong> <%= getSyllabusCode() %></div>
                    <div><strong>Lab Hits:</strong> <%= demoHitCount %></div>
                    <div><strong>Container:</strong> Tomcat 11</div>
                </div>
            </div>
        </div>
    </div>

    <!-- Navigation Pills for Topics -->
    <ul class="nav nav-pills mb-4 gap-2 flex-wrap" id="demoTabs" role="tablist">
        <li class="nav-item">
            <button class="nav-link active rounded-pill" data-bs-toggle="pill" data-bs-target="#tab-jsp">
                <i class="bi bi-code-slash me-1"></i> JSP Elements &amp; JSTL
            </button>
        </li>
        <li class="nav-item">
            <button class="nav-link rounded-pill" data-bs-toggle="pill" data-bs-target="#tab-applet">
                <i class="bi bi-window-sidebar me-1"></i> Applets (Simulation)
            </button>
        </li>
        <li class="nav-item">
            <button class="nav-link rounded-pill" data-bs-toggle="pill" data-bs-target="#tab-xml">
                <i class="bi bi-filetype-xml me-1"></i> JSTL XML
            </button>
        </li>
        <li class="nav-item">
            <button class="nav-link rounded-pill" data-bs-toggle="pill" data-bs-target="#tab-jndi">
                <i class="bi bi-folder-symlink me-1"></i> Naming / JNDI
            </button>
        </li>
        <li class="nav-item">
            <button class="nav-link rounded-pill" data-bs-toggle="pill" data-bs-target="#tab-network">
                <i class="bi bi-hdd-network me-1"></i> java.net &amp; RMI
            </button>
        </li>
    </ul>

    <div class="tab-content" id="demoTabsContent">
        <!-- TAB 1: JSP Elements & JSTL -->
        <div class="tab-pane fade show active" id="tab-jsp">
            <div class="row g-4">
                <div class="col-lg-6">
                    <div class="card border-0 shadow-sm rounded-4 p-4 bg-white h-100">
                        <h5 class="fw-bold mb-3"><i class="bi bi-braces text-primary me-2"></i>1. Traditional JSP Elements</h5>
                        <p class="small text-muted mb-3">Demonstrating traditional declaration, scriptlet, expression and comments syntax.</p>

                        <div class="code-block-demo mb-3">
                            <span class="text-secondary">// JSP Declaration</span><br>
                            &lt;%! int demoHitCount = 108; %&gt;<br><br>
                            <span class="text-secondary">// JSP Scriptlet</span><br>
                            &lt;% String student = "<%= labStudent %>"; %&gt;<br><br>
                            <span class="text-secondary">// JSP Expression</span><br>
                            Hello &lt;%= student %&gt; at &lt;%= serverTime %&gt;
                        </div>

                        <div class="p-3 bg-light rounded-3 border">
                            <div class="small fw-bold text-muted text-uppercase mb-1">Live Server Output:</div>
                            <div class="fw-semibold text-primary">Student Greeting: <%= labStudent %></div>
                            <div class="small text-muted">Evaluated at: <%= serverTime %></div>
                            <div class="small text-success mt-1"><i class="bi bi-check-circle me-1"></i>JSP lifecycle compilation to Servlet verified.</div>
                        </div>
                    </div>
                </div>

                <div class="col-lg-6">
                    <div class="card border-0 shadow-sm rounded-4 p-4 bg-white h-100">
                        <h5 class="fw-bold mb-3"><i class="bi bi-tags text-primary me-2"></i>2. JSTL Core &amp; Functions</h5>
                        <p class="small text-muted mb-3">Using <code>c:forEach</code>, <code>c:choose</code>, <code>fn:length</code>, and Custom Tag Extensions.</p>

                        <div class="p-3 bg-light rounded-3 border mb-3">
                            <div class="small fw-bold text-muted mb-2">JSTL Core Iteration &amp; Rating Tag Extension:</div>
                            <c:forEach var="p" items="${demoProducts}">
                                <div class="d-flex justify-content-between align-items-center py-1 border-bottom border-light">
                                    <span class="small fw-semibold">${p.name}</span>
                                    <shopsphere:rating rating="4.5" />
                                </div>
                            </c:forEach>
                        </div>

                        <div class="small text-secondary">
                            <div><strong>fn:length(demoProducts):</strong> ${fn:length(demoProducts)} items</div>
                            <div><strong>fn:toUpperCase(appTagline):</strong> ${fn:toUpperCase('Next-Gen Java Enterprise Platform')}</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- TAB 2: Applets Simulation -->
        <div class="tab-pane fade" id="tab-applet">
            <div class="card border-0 shadow-sm rounded-4 p-4 bg-white">
                <div class="d-flex justify-content-between align-items-center mb-3 pb-2 border-bottom">
                    <div>
                        <h5 class="fw-bold mb-0">3. Java Applet Architecture &amp; Historical Demonstration</h5>
                        <span class="text-muted small">RTU Syllabus Requirement: Applet Lifecycle &amp; Canvas Emulation</span>
                    </div>
                    <span class="badge bg-secondary-subtle text-secondary">AWT / Swing Applet</span>
                </div>

                <p class="text-secondary small leading-relaxed mb-3">
                    In traditional Java, an <code>Applet</code> (and Swing <code>JApplet</code>) was embedded inside HTML via the <code>&lt;applet&gt;</code> tag and executed inside the JVM plugin in the browser. 
                    Its lifecycle consisted of 4 fundamental methods: <code>init()</code>, <code>start()</code>, <code>stop()</code>, and <code>destroy()</code>, drawing with <code>paint(Graphics g)</code>.
                    Modern web browsers deprecated NPAPI plugins for security; below is an authentic pixel-faithful canvas simulation demonstrating how the Applet banner runs!
                </p>

                <div class="text-center p-3 bg-dark rounded-4 mb-3">
                    <canvas id="appletCanvas" width="700" height="120" style="max-width: 100%; border: 2px solid #4f46e5; border-radius: 8px; background: #0f172a;"></canvas>
                </div>

                <div class="row g-3 small">
                    <div class="col-md-3">
                        <div class="p-2 border rounded-3 bg-light">
                            <strong>1. init():</strong> Initialize UI components &amp; parameters
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="p-2 border rounded-3 bg-light">
                            <strong>2. start():</strong> Spawn animation thread
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="p-2 border rounded-3 bg-light">
                            <strong>3. stop():</strong> Suspend animation on tab blur
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="p-2 border rounded-3 bg-light">
                            <strong>4. destroy():</strong> Release graphic handles
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- TAB 3: JSTL XML -->
        <div class="tab-pane fade" id="tab-xml">
            <div class="card border-0 shadow-sm rounded-4 p-4 bg-white">
                <div class="d-flex justify-content-between align-items-center mb-3 pb-2 border-bottom">
                    <div>
                        <h5 class="fw-bold mb-0">4. JSTL XML Demonstration</h5>
                        <span class="text-muted small">RTU Syllabus Requirement: Parsing &amp; Transforming XML Data (x:parse, x:forEach, x:out)</span>
                    </div>
                    <span class="badge bg-primary-subtle text-primary">products-feed.xml</span>
                </div>

                <c:if test="${not empty xmlCatalog}">
                    <x:parse xml="${xmlCatalog}" var="parsedXml" />
                    
                    <div class="table-responsive mb-4">
                        <table class="table table-bordered align-middle">
                            <thead class="table-light small text-uppercase">
                                <tr>
                                    <th>Product ID</th>
                                    <th>Product Name</th>
                                    <th>Category</th>
                                    <th>Brand</th>
                                    <th>Price</th>
                                </tr>
                            </thead>
                            <tbody>
                                <x:forEach select="$parsedXml/catalog/product" var="item">
                                    <tr>
                                        <td class="font-monospace"><x:out select="$item/@id" /></td>
                                        <td class="fw-bold text-dark"><x:out select="$item/name" /></td>
                                        <td><span class="badge bg-secondary-subtle text-secondary"><x:out select="$item/category" /></span></td>
                                        <td><x:out select="$item/brand" /></td>
                                        <td class="fw-bold text-primary">₹<x:out select="$item/price" /></td>
                                    </tr>
                                </x:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:if>

                <div class="code-block-demo">
                    <span class="text-secondary">&lt;!-- JSTL XML Snippet --&gt;</span><br>
                    &lt;x:parse xml="\${xmlCatalog}" var="parsedXml" /&gt;<br>
                    &lt;x:forEach select="\$parsedXml/catalog/product" var="item"&gt;<br>
                    &nbsp;&nbsp;&lt;x:out select="\$item/name" /&gt; - ₹&lt;x:out select="\$item/price" /&gt;<br>
                    &lt;/x:forEach&gt;
                </div>
            </div>
        </div>

        <!-- TAB 4: JNDI & URLConnection -->
        <div class="tab-pane fade" id="tab-jndi">
            <div class="row g-4">
                <!-- JNDI Column -->
                <div class="col-lg-6">
                    <div class="card border-0 shadow-sm rounded-4 p-4 bg-white h-100">
                        <h5 class="fw-bold mb-3"><i class="bi bi-diagram-3 text-primary me-2"></i>5. Naming / JNDI Demonstration</h5>
                        <p class="small text-muted mb-3">Demonstrates JNDI InitialContext resource lookup as required by syllabus.</p>
                        
                        <div class="code-block-demo mb-3" style="font-size: 0.82rem;">
Context initCtx = new InitialContext();<br>
Context envCtx = (Context) initCtx.lookup("java:comp/env");<br>
DataSource ds = (DataSource) envCtx.lookup("jdbc/ShopSphereDS");
                        </div>

                        <div class="p-3 bg-light rounded-3 border">
                            <div class="small fw-bold text-muted mb-1">Execution Output:</div>
                            <pre class="mb-0 font-monospace small" style="white-space: pre-wrap;">${jndiOutput}</pre>
                        </div>
                    </div>
                </div>

                <!-- URLConnection Column -->
                <div class="col-lg-6">
                    <div class="card border-0 shadow-sm rounded-4 p-4 bg-white h-100">
                        <h5 class="fw-bold mb-3"><i class="bi bi-link-45deg text-primary me-2"></i>6. java.net URLConnection</h5>
                        <p class="small text-muted mb-3">Inspect URL protocol, headers, and stream content handlers.</p>

                        <form action="${pageContext.request.contextPath}/syllabus-demo" method="get" class="mb-3">
                            <div class="input-group input-group-sm">
                                <input type="url" name="inspectUrl" class="form-control" value="${inspectedUrl}" required>
                                <button type="submit" class="btn btn-primary">Inspect URL</button>
                            </div>
                        </form>

                        <div class="p-3 bg-light rounded-3 border small font-monospace">
                            <div><strong>Protocol:</strong> ${urlInfo.protocol}</div>
                            <div><strong>Host:</strong> ${urlInfo.host}</div>
                            <div><strong>Port:</strong> ${urlInfo.port}</div>
                            <div><strong>Content-Type:</strong> ${urlInfo.contentType}</div>
                            <div><strong>Content-Length:</strong> ${urlInfo.contentLength} bytes</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- TAB 5: java.net Sockets & RMI Architecture -->
        <div class="tab-pane fade" id="tab-network">
            <div class="row g-4">
                <div class="col-lg-6">
                    <div class="card border-0 shadow-sm rounded-4 p-4 bg-white h-100">
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <h5 class="fw-bold mb-0"><i class="bi bi-hdd-network text-primary me-2"></i>7. java.net Socket Server</h5>
                            <span class="badge bg-warning text-dark font-monospace">Port: 8888</span>
                        </div>
                        <p class="small text-muted mb-3">
                            ShopSphere includes a standalone multithreaded <code>ServerSocket</code> system that accepts client connections and transfers serialized <code>Product</code> / <code>Order</code> objects using <code>ObjectOutputStream</code> / <code>ObjectInputStream</code>.
                        </p>
                        <div class="code-block-demo mb-3 small">
// To start Server:<br>
cd ShopSphere\network<br>
mvn compile exec:java -Dexec.mainClass="com.shopsphere.network.server.InventorySocketServer"<br><br>
// To run Client test:<br>
mvn compile exec:java -Dexec.mainClass="com.shopsphere.network.client.InventorySocketClient"
                        </div>
                        <div class="p-3 bg-light rounded-3 border small">
                            <span class="fw-bold text-dark">Supported Network Commands:</span>
                            <ul class="mb-0 mt-1 ps-3 font-monospace">
                                <li>GET_PRODUCT (productId)</li>
                                <li>GET_STOCK (productId)</li>
                                <li>UPDATE_STOCK (productId, quantity)</li>
                                <li>LIST_ALL</li>
                            </ul>
                        </div>
                    </div>
                </div>

                <div class="col-lg-6">
                    <div class="card border-0 shadow-sm rounded-4 p-4 bg-white h-100">
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <h5 class="fw-bold mb-0"><i class="bi bi-distribute-vertical text-primary me-2"></i>8. Java RMI Registry</h5>
                            <span class="badge bg-info text-dark font-monospace">Port: 1099</span>
                        </div>
                        <p class="small text-muted mb-3">
                            The RMI subsystem exports the remote interface <code>InventoryService extends Remote</code> and registers it in the <code>rmiregistry</code>.
                        </p>
                        <div class="code-block-demo mb-3 small">
// Remote Interface:<br>
public interface InventoryService extends Remote {<br>
&nbsp;&nbsp;Product getProduct(int id) throws RemoteException;<br>
&nbsp;&nbsp;int getStock(int productId) throws RemoteException;<br>
&nbsp;&nbsp;boolean updateStock(int productId, int quantity) throws RemoteException;<br>
}
                        </div>
                        <div class="p-3 bg-light rounded-3 border small">
                            <span class="fw-bold text-dark">Run RMI Demonstration:</span>
                            <div class="font-monospace text-muted mt-1">
                                Start Server: <code>run-rmi-server.bat</code><br>
                                Run Client: <code>run-rmi-client.bat</code>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Interactive Applet Canvas Script -->
<script>
document.addEventListener('DOMContentLoaded', function () {
    const canvas = document.getElementById('appletCanvas');
    if (!canvas) return;
    const ctx = canvas.getContext('2d');
    let x = 0;
    const speed = 2;

    function renderApplet() {
        ctx.fillStyle = '#0f172a';
        ctx.fillRect(0, 0, canvas.width, canvas.height);

        // Grid lines to simulate vintage JVM AWT component
        ctx.strokeStyle = '#1e293b';
        ctx.lineWidth = 1;
        for (let i = 0; i < canvas.width; i += 20) {
            ctx.beginPath();
            ctx.moveTo(i, 0);
            ctx.lineTo(i, canvas.height);
            ctx.stroke();
        }

        // Animated banner text
        ctx.font = 'bold 22px "Consolas", monospace';
        ctx.fillStyle = '#38bdf8';
        ctx.fillText(">> SHOPSPHERE: RTU Java Applet Simulation [paint(Graphics g)] <<", x, 55);

        ctx.font = '14px "Consolas", monospace';
        ctx.fillStyle = '#f59e0b';
        ctx.fillText("Lifecycle State: ACTIVE | Thread running | Double Buffered", x, 85);

        x -= speed;
        if (x < -800) {
            x = canvas.width;
        }
        requestAnimationFrame(renderApplet);
    }
    renderApplet();
});
</script>

<jsp:include page="fragments/footer.jsp" />
