# ShopSphere - RTU Advanced Java Project

E-commerce system built from the *Java Advanced ShopSphere Project Guide*.
Core flow (Section 29 "minimum working version") is complete; Swing, Socket, RMI, JNDI, URL and i18n demos are included.

## Folder layout
```
ShopSphere/
|-- database/shopsphere.sql      schema + sample data
|-- web/                         Maven WAR  (Servlet + JSP + JSTL + JDBC)   -> Tomcat 11
`-- standalone/                  Maven JAR  (Swing admin, Socket, RMI, JNDI, URL, i18n demos)
```

## Requirements
JDK 17 or newer, Maven 3.9+, MySQL 8, Apache Tomcat 11 (uses `jakarta.servlet.*`).

## 1. Database
```
mysql -u root -p < database/shopsphere.sql
```
Edit the MySQL user/password in **both**
`web/src/main/resources/db.properties` and `standalone/src/main/resources/db.properties`
(also in `web/src/main/webapp/admin/jstl-sql-demo.jsp`, only used for the JSTL SQL demo).

Demo logins: `admin@shopsphere.com / admin123`  and  `user@shopsphere.com / user123`
Coupons: `WELCOME10` (10% off above 500), `SAVE100` (flat 100 off above 1000)

## 2. Web application
```
cd web
mvn clean package
```
Copy `target/shopsphere.war` into Tomcat's `webapps/` folder, start Tomcat, open
**http://localhost:8080/shopsphere/**

(IntelliJ: install the "Smart Tomcat" plugin, point it at `web/`, context path `/shopsphere`.
VS Code: "Community Server Connectors" or just copy the WAR.)

Extra pages: `/jsp-demo.jsp` (JSP elements, EL, JSTL core/functions/fmt), `/jstl-xml-demo.jsp`, `/admin/jstl-sql-demo.jsp`.

## 3. Standalone modules
```
cd standalone
mvn compile

# Socket client-server (two terminals)
mvn exec:java -Dexec.mainClass=com.shopsphere.net.InventoryServer
mvn exec:java -Dexec.mainClass=com.shopsphere.net.InventoryClient
#   then type:  GET_PRODUCT 1 | GET_STOCK 1 | SEARCH_PRODUCT java | QUIT

# RMI (server first, then client)
mvn exec:java -Dexec.mainClass=com.shopsphere.rmi.RmiServer
mvn exec:java -Dexec.mainClass=com.shopsphere.rmi.RmiClient
mvn exec:java -Dexec.mainClass=com.shopsphere.demo.JndiDemo      # needs RmiServer running

# Swing admin (login: admin@shopsphere.com / admin123)
mvn exec:java -Dexec.mainClass=com.shopsphere.swing.AdminApp

# Other demos
mvn exec:java -Dexec.mainClass=com.shopsphere.demo.UrlDemo
mvn exec:java -Dexec.mainClass=com.shopsphere.demo.I18nDemo
```

## Architecture
Browser -> JSP (EL/JSTL) -> Servlet controller -> Service -> DAO -> JDBC -> MySQL

Package `com.shopsphere`: `controller`, `service`, `dao`, `model`, `filter`, `listener`, `util`.

## RTU syllabus -> where to find it
| Topic | Location |
|---|---|
| Swing, components, MVC, look and feel | `standalone/.../swing/` (`LoginFrame`, `ProductFrame`, `ProductController`, `ProductTableModel`, `AdminApp`) |
| JDBC / DAO / PreparedStatement | `web/.../dao/*`, `standalone/.../dao/*` |
| Transactions | `CheckoutService.placeOrder` |
| java.net, client/server | `standalone/.../net/InventoryServer`, `InventoryClient` |
| Serialization | `model/Product implements Serializable`, used by Socket (ObjectStreams) and RMI |
| RMI + registry | `standalone/.../rmi/*` |
| JNDI / Naming | `demo/JndiDemo`, `Naming.rebind/lookup` in `rmi/*` |
| URL, content/protocol handlers | `demo/UrlDemo` (custom `shop://` URLStreamHandler) |
| Internationalization | `messages_en/hi.properties`, `fmt:message` in `header.jsp`, `demo/I18nDemo` |
| Servlet lifecycle, ServletConfig, ServletContext | `controller/HomeServlet` |
| Request/response, sessions, cookies | `LoginServlet` (session), `ProductServlet` ("recently viewed" cookie) |
| Event handling (listeners) | `listener/AppListener`, `listener/SessionCounterListener` |
| Filters | `filter/AuthenticationFilter`, `AdminFilter`, `EncodingFilter` |
| JSP elements (declaration, scriptlet, expression, comment) | `webapp/jsp-demo.jsp` |
| EL, JSTL core / functions / fmt | all pages, `jsp-demo.jsp` |
| JSTL XML / SQL | `jstl-xml-demo.jsp`, `admin/jstl-sql-demo.jsp` |
| JSP fragments | `webapp/fragments/` (`header`, `footer`, `sidebar`) |
| Tag files | `webapp/WEB-INF/tags/productCard.tag`, `rating.tag` |
| J2EE / N-tier / web container | Tomcat 11 + layered packages above |
| Applets | Concept only (removed from modern Java); explain in viva / report |

## Security notes
PBKDF2 password hashes, `PreparedStatement` everywhere, server-side order totals, session id regenerated at login,
`c:out` escaping of user text, role check in `AdminFilter`, customers can open only their own orders.

## Not included (kept out of the minimum version)
Wishlist and address-book screens (tables exist in the SQL), email/OTP, real payment gateway.
