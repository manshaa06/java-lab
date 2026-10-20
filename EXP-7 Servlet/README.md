# Experiment 7: Servlet Login Application (Jakarta EE & Maven)

## 📌 Overview
This experiment demonstrates an enterprise **Jakarta EE 10 / Servlet 6.1** web application managed with **Apache Maven**. It illustrates state management, authentication filtering, session tracking, and server lifecycle listeners under **Apache Tomcat 11**.

---

## 🏗️ Architecture & Security Lifecycle

```
    Web Browser                 Tomcat Container (Jakarta EE 10)
┌─────────────────┐        ┌────────────────────────────────────────────────────────┐
│  index.html     │───────►│  AppListener: @WebListener                             │
│  (Login Form)   │        │  (Logs contextInitialized / sessionCreated)            │
└─────────────────┘        ├────────────────────────────────────────────────────────┤
        │                  │  LoginServlet: @WebServlet("/login")                   │
        │ POST admin/1234  │  Validates credentials -> req.getSession()             │
        └─────────────────►│  session.setAttribute("username", "admin")             │
                           ├────────────────────────────────────────────────────────┤
                           │  AuthFilter: @WebFilter("/home")                       │
                           │  - Valid session?  ──► Pass to HomeServlet             │
                           │  - Invalid/Null?   ──► Redirect to index.html          │
                           ├────────────────────────────────────────────────────────┤
                           │  HomeServlet: @WebServlet("/home")                     │
                           │  Renders welcome page for authenticated session        │
                           ├────────────────────────────────────────────────────────┤
                           │  LogoutServlet: @WebServlet("/logout")                 │
                           │  session.invalidate() -> Redirect to index.html        │
                           └────────────────────────────────────────────────────────┘
```

### Component Details
1. **`LoginServlet.java` (`/login`)**:
   - Handles `POST` requests from `index.html`.
   - Credentials configured: Username `admin`, Password `1234`.
   - Creates `HttpSession` upon authentication and sets `"username"`.
2. **`HomeServlet.java` (`/home`)**:
   - Protected welcome dashboard retrieving session attribute.
   - Provides logout hyperlink.
3. **`AuthFilter.java` (`@WebFilter("/home")`)**:
   - Intercepts requests targeting `/home`.
   - Inspects `req.getSession(false)`. If null or unauthenticated, redirects immediately to `index.html`.
4. **`LogoutServlet.java` (`/logout`)**:
   - Destroys active session via `session.invalidate()` and redirects to login.
5. **`AppListener.java` (`@WebListener`)**:
   - Implements `ServletContextListener` and `HttpSessionListener`.
   - Outputs lifecycle milestones to server console (`Application Started`, `Session Created: <id>`).
6. **`HelloServlet.java` (`/hello`)**:
   - Simple `@WebServlet` demonstrating basic request handling.

---

## 🚀 How to Build and Deploy

### Prerequisites
- JDK 17 or higher.
- Apache Maven 3.8+ installed.
- Apache Tomcat 11 (available in `Softwares/apache-tomcat-11.0.25`).

### Step 1: Build WAR with Maven
```bash
cd Experiments/Exp-07-Servlet-Login-App/servlet

# Clean and package the web application archive:
mvn clean package
```
*Artifact generated:* `target/servlet.war`

### Step 2: Deploy to Apache Tomcat 11
```cmd
# Copy the generated WAR into Tomcat webapps directory:
copy target\servlet.war "..\..\Softwares\apache-tomcat-11.0.25\webapps\servlet.war"
```

### Step 3: Start Apache Tomcat
```cmd
cd "..\..\Softwares\apache-tomcat-11.0.25\bin"
startup.bat
```

### Step 4: Access and Test Application
1. **Login Page**: Open `http://localhost:8080/servlet/`
2. **Credentials**:
   - **Username**: `admin`
   - **Password**: `1234`
3. **Verify Auth Filter**:
   - Try accessing `http://localhost:8080/servlet/home` directly in an incognito window without logging in. You will be redirected to `index.html`.
4. **Verify Listeners**:
   - Check Tomcat console or `logs/catalina.out` for `Session Created` and `Session Destroyed` entries.

---

## 💡 Key Concepts Covered
- **Jakarta EE 10 Modern API**: Migration to `jakarta.servlet.*` package namespace.
- **Session Tracking**: `req.getSession()`, `setAttribute()`, `getAttribute()`, `invalidate()`.
- **Security Interception**: Servlet Filter chaining (`FilterChain.doFilter`).
- **Container Event Observers**: `ServletContextListener` and `HttpSessionListener`.
