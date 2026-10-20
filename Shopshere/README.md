# SHOPSPHERE - RTU Advanced Java / Java Enterprise E-Commerce Project

**ShopSphere** is an end-to-end, enterprise-grade Java E-Commerce Management System designed as a final capstone laboratory and examination project for **Rajasthan Technical University (RTU)**.

The project is structured to demonstrate every syllabus topic inside one coherent, production-ready distributed system:
- **Jakarta Servlets 6.1 & JSP 3.1** on **Apache Tomcat 11**
- **Desktop Administration** using **Java Swing & Swing MVC**
- **ACID Transactions** & Persistent Data using **JDBC & MySQL / MariaDB**
- **Multithreaded Network Services** using **java.net Socket & ServerSocket**
- **Distributed Remote Computing** using **Java RMI & RMI Registry**
- **Java Object Serialization** (`ObjectOutputStream` & `ObjectInputStream`)
- **Expression Language (EL)**, **JSTL (Core, XML, Functions)**, **JSP Fragments**, & **Custom Tag Files / Tag Extensions**
- **Internationalization (I18N)** with English and Hindi ResourceBundles
- **Security & Event Handlers**: `AuthenticationFilter`, `AdminFilter`, `ServletContextListener`, `HttpSessionListener`

---

## 🚀 Quick Start Guide

### 1. Database Setup
Ensure MySQL / MariaDB is active on port `3306`, then run:
```cmd
init-database.bat
```
*Or manually via MySQL CLI:*
```sql
mysql -u root < database/shopsphere.sql
```

### 2. Deploy Web Application (Tomcat 11)
```cmd
deploy-to-tomcat.bat
```
*Access URLs in your browser:*
- **Customer Storefront:** [http://localhost:8080/ShopSphere/](http://localhost:8080/ShopSphere/)
- **Syllabus Demonstration Lab:** [http://localhost:8080/ShopSphere/syllabus-demo](http://localhost:8080/ShopSphere/syllabus-demo)
- **Admin Portal:** [http://localhost:8080/ShopSphere/admin-login](http://localhost:8080/ShopSphere/admin-login)

### 3. Launch Desktop Swing Admin Application
```cmd
run-swing-admin.bat
```

### 4. Run java.net Socket Client-Server Module
In Terminal 1 (Start Server):
```cmd
run-socket-server.bat
```
In Terminal 2 (Run Automated Client Tests):
```cmd
run-socket-client.bat
```

### 5. Run Java RMI Distributed Remote Service
In Terminal 1 (Start RMI Server & Registry):
```cmd
run-rmi-server.bat
```
In Terminal 2 (Run RMI Client Invocations):
```cmd
run-rmi-client.bat
```

---

## 🔑 Default Credentials

| Role | Email | Password | Permissions |
| :--- | :--- | :--- | :--- |
| **Administrator** | `admin@shopsphere.com` | `admin123` | Full Admin Console, Inventory CRUD, Orders, Status |
| **Customer (Nikhil)** | `nikhil@shopsphere.com` | `password123` | Browsing, Cart, Checkout, Wishlist, Reviews |
| **Customer (Student)**| `student@shopsphere.com` | `student123` | Full shopping flow & Viva testing |

---

## 📂 Repository Structure

```
ShopSphere/
|-- pom.xml                               # Root Maven multi-module parent descriptor
|-- run-swing-admin.bat                   # Desktop Swing application launcher
|-- run-socket-server.bat                 # java.net Socket Server launcher
|-- run-socket-client.bat                 # java.net Socket Client test launcher
|-- run-rmi-server.bat                    # Java RMI registry & server launcher
|-- run-rmi-client.bat                    # Java RMI client remote test launcher
|-- init-database.bat                     # Database schema and seed importer
|-- deploy-to-tomcat.bat                  # Web WAR packaging and deployment script
|-- database/
|   `-- shopsphere.sql                    # MySQL 12-table relational schema & seed data
|-- shopsphere-common/                    # Models, DAOs, JDBC Connection, I18N, Utilities
|   `-- src/main/java/com/shopsphere/
|       |-- model/                        # Product, User, Category, Order, CartItem, etc.
|       |-- dao/                          # ProductDAO, OrderDAO, UserDAO, CartDAO, etc.
|       `-- util/                         # DBConnection, PasswordUtil, I18nUtil, JndiDemoUtil
|-- web/                                  # Jakarta EE 10 / Tomcat 11 Web Application
|   `-- src/main/
|       |-- java/com/shopsphere/
|       |   |-- controller/               # Login, Register, Product, Cart, Checkout Servlets
|       |   |-- filter/                   # AuthenticationFilter, AdminFilter
|       |   |-- listener/                 # AppListener (ServletContextListener, HttpSessionListener)
|       |   |-- service/                  # Business Logic layer (Checkout, Product, Order)
|       |   `-- tag/                      # Custom Tag Extension (RatingTag)
|       |-- resources/                    # messages_en, messages_hi, products-feed.xml
|       `-- webapp/                       # JSPs, fragments, WEB-INF tags, CSS, JS
|-- swing-admin/                          # Java Swing Desktop Management Application
|   `-- src/main/java/com/shopsphere/swing/
|       |-- view/                         # LoginFrame, AdminDashboard
|       `-- SwingAdminApp.java            # Entry point with Pluggable Look & Feel
|-- network/                              # java.net Socket/ServerSocket & Serialization
|   `-- src/main/java/com/shopsphere/network/
|       |-- server/                       # InventorySocketServer
|       `-- client/                       # InventorySocketClient
`-- rmi/                                  # Java RMI Remote Inventory Service
    `-- src/main/java/com/shopsphere/rmi/
        |-- remote/                       # InventoryService (Remote interface)
        |-- server/                       # InventoryServiceImpl & RmiServer
        `-- client/                       # RmiClient
```

---

## 🎓 RTU Syllabus to Implementation Mapping

| RTU Syllabus Topic | Implementation in ShopSphere |
| :--- | :--- |
| **Swing & Swing Components** | `LoginFrame.java`, `AdminDashboard.java` using JFrame, JPanel, JTable, JComboBox, etc. |
| **Pluggable Look and Feel** | `UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName())` |
| **MVC Architecture** | Clear separation: View (JSP/Swing) -> Controller (Servlet/Listener) -> Service -> DAO -> Database |
| **Applets** | Interactive Canvas/JS emulation & lifecycle study in `syllabus-demo.jsp` |
| **JDBC / java.sql** | `DBConnection.java` with PreparedStatement, ResultSet, transactions |
| **ACID Transactions** | `OrderDAO.java` commit & rollback on multi-table checkout |
| **java.net Networking** | `InventorySocketServer` & `InventorySocketClient` on port 8888 |
| **Object Serialization** | `NetworkMessage`, `Product`, `Order` transmitted over Object Streams |
| **Java RMI & Registry** | `InventoryService extends Remote`, `RmiServer` (:1099), `RmiClient` |
| **Naming / JNDI** | `JndiDemoUtil.java` InitialContext demonstration |
| **Internationalization (I18N)** | `messages_en.properties`, `messages_hi.properties`, language switcher |
| **Servlet Lifecycle & Config** | `init()`, `service()`, `doGet()`, `doPost()`, `destroy()`, `ServletConfig`, `ServletContext` |
| **Session & Cookies** | `HttpSession` for auth & cart, cookies for "Recently Viewed Products" |
| **Filters & Listeners** | `AuthenticationFilter`, `AdminFilter`, `AppListener` (`@WebListener`) |
| **JSP Scripting Elements** | Declarations (`<%! %>`), Scriptlets (`<% %>`), Expressions (`<%= %>`), Comments (`<%-- --%>`) |
| **JSP Expression Language (EL)** | `${product.name}`, `${sessionScope.user.name}` |
| **Tag Files & Tag Handlers** | `productCard.tag`, `rating.tag`, Custom Tag Handler `RatingTag.java` |
| **JSTL Core, XML, Functions** | `c:forEach`, `c:if`, `c:choose`, `x:parse`, `x:out`, `fn:length`, `fn:toUpperCase` |

---

## 🧪 Testing and Verification Checklist

- [x] Database seeded with 12 tables, products, categories, coupons, and orders.
- [x] Customer browsing, category filters, and search executed.
- [x] Add to cart, quantity update, and coupon validation (`WELCOME50`, `SHOP100`).
- [x] Multi-item checkout with atomic ACID transaction.
- [x] Customer order history and timeline delivery tracker.
- [x] Admin dashboard with real-time KPI metrics and low-stock alerts.
- [x] Swing Desktop Admin launched with system Look and Feel.
- [x] java.net Socket Server and Client running with Object Serialization.
- [x] Java RMI Server and Client running on registry port 1099.
- [x] All JUnit 5 unit tests passing with 0 failures.
