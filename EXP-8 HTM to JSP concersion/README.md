# JSP Project — Conversion of HTML into JSP

**Experiment:** Advanced Java Lab (JSP) — Convert an existing HTML page into a JSP page, pass data
from a Servlet to a JSP and display it with Expression Language (EL).

---

## 1. What is this project about?

This project is a **Jakarta EE web application (WAR)** that shows how an ordinary **static HTML page
is converted into a dynamic JSP page** and how a **Servlet and a JSP work together** in a real web
application.

It contains two complete flows:

| Flow | What it demonstrates |
| --- | --- |
| **Student registration** (`student.jsp` → `HelloServlet` → `result.jsp`) | HTML converted to JSP, form submission, `getParameter()`, `setAttribute()`, `RequestDispatcher.forward()`, EL output, MVC separation |
| **Student login** (`index.jsp` → `LoginServlet` → `HomeServlet` → `LogoutServlet`) | The previous Servlet experiment kept alive, with the login page now written as a JSP, plus session handling, an auth filter and lifecycle listeners |

The central idea of the experiment: **the Servlet processes the request, the JSP presents the
result.** The HTML markup stays in the JSP page, and the Java code stays in the Servlet class, so
both files are readable instead of one Java class printing HTML line by line.

---

## 2. Aim

To understand JavaServer Pages (JSP) and convert the HTML page created in the previous Servlet
experiment into a JSP page, while studying JSP architecture, lifecycle, JSP elements, directives,
Expression Language (EL) and Servlet–JSP interaction.

## 3. Learning objectives

* Understand JSP and its purpose.
* Understand JSP architecture and lifecycle.
* Differentiate Servlet and JSP.
* Convert an existing HTML page into JSP.
* Understand JSP directives and Expression Language.
* Pass data from a Servlet to a JSP and display it using EL.
* Understand JSP as the presentation layer in MVC.

---

## 4. Prerequisites (software)

| Software | Version used here | Why |
| --- | --- | --- |
| JDK | Java SE 26.0.2 | Compiles the Servlet classes |
| Apache Maven | 3.9.16 | Builds the `.war` file |
| Apache Tomcat | 11.0.25 | Servlet 6.1 / JSP 4.1 container that runs the app |
| Browser | Any modern browser | Sends the requests, shows the pages |

A copy of Tomcat 11 is already present in this workspace at
`../Softwares/apache-tomcat-11.0.25` (used for lab web experiments).

Verify the tools:

```bash
java -version      # java version "26.0.2"
mvn -v             # Apache Maven 3.9.16
```

---

## 5. Full install and run process

### Step 1 — Open the project folder

```bash
cd JSPproject/servlet
```

### Step 2 — Build the WAR file

```bash
mvn clean package
```

Maven compiles the Servlets, packages the JSP/HTML/CSS files from `src/main/webapp` and produces:

```
JSPproject/servlet/target/servlet.war
```

> The first build downloads the Jakarta Servlet API and the JSTL 3.0.0 jars into
> `~/.m2/repository`. After that, offline builds work with `mvn -o clean package`.

### Step 3 — Deploy the WAR to Tomcat

**Windows (PowerShell / CMD)**

```bash
copy target\servlet.war "%CATALINA_HOME%\webapps\servlet.war"
```

**Linux / macOS**

```bash
cp target/servlet.war "$CATALINA_HOME/webapps/servlet.war"
```

> If Tomcat already has an **exploded** copy of an older build
> (`%CATALINA_HOME%\webapps\servlet\`), delete that folder first, otherwise Tomcat keeps serving the
> old files instead of the new WAR.

Using the Tomcat copy that ships with this workspace:

```bash
copy target\servlet.war "..\..\Experiment 6\apache-tomcat-11.0.25\webapps\servlet.war"
```

### Step 4 — Start Tomcat

```bash
# Windows
%CATALINA_HOME%\bin\startup.bat

# Linux / macOS
$CATALINA_HOME/bin/startup.sh
```

Tomcat deploys the WAR automatically and creates the folder `webapps/servlet`, which becomes the
**web application context path** `/servlet`.

To stop it again: `%CATALINA_HOME%\bin\shutdown.bat` (or `shutdown.sh`).

### Step 5 — Open the application

| URL | Page |
| --- | --- |
| <http://localhost:8080/servlet/> | Login page — `index.jsp` (the welcome file) |
| <http://localhost:8080/servlet/student.jsp> | **Student registration form** (start here for the experiment) |
| <http://localhost:8080/servlet/hello> | Servlet demo page printed with `PrintWriter` (the "before" style) |

Login credentials: **admin / 1234**

### Step 6 — Run the experiment flow

1. Open <http://localhost:8080/servlet/student.jsp> — the form is the converted HTML page.
2. Fill in **Name, Email, Course, Age** and press **Register**.
3. The browser posts to `/servlet/hello`; the Servlet stores the data as request attributes and
   forwards to `result.jsp`.
4. `result.jsp` shows **Registration Successful** followed by the entered student details.
5. Click **View using JSTL** to see the same data rendered with JSTL tags instead of plain EL.

---

## 6. Project structure

```
JSPproject/
├── README.md                          <-- this file
└── servlet/                           <-- the Maven web application module
    ├── pom.xml
    └── src/
        └── main/
            ├── java/
            │   └── com/
            │       └── servlet/
            │           ├── AppListener.java     @WebListener: context + session lifecycle
            │           ├── AuthFilter.java       @WebFilter("/home"): session check
            │           ├── HelloServlet.java     @WebServlet("/hello"): registers student, forwards to JSP
            │           ├── HomeServlet.java      @WebServlet("/home"): protected page
            │           ├── LoginServlet.java     @WebServlet("/login"): login handling
            │           └── LogoutServlet.java    @WebServlet("/logout"): invalidate session
            └── webapp/
                ├── index.jsp          login page (converted from index.html) — welcome file
                ├── student.jsp        registration form (converted from HTML) — main experiment page
                ├── result.jsp         Servlet → JSP view using EL
                ├── result-jstl.jsp    same view using JSTL (<c:if>, <c:out>)
                ├── footer.jsp         shared fragment, included with the include directive
                ├── style.css          shared stylesheet
                └── WEB-INF/
                    └── web.xml        deployment descriptor (welcome file, session timeout)
```

---

## 7. Files and what each one does

### 7.1 `student.jsp` — the HTML page converted to JSP

The form is the plain HTML page from the previous experiment; the only additions are the JSP
directives and a few JSP elements:

```jsp
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page pageEncoding="UTF-8" %>
<%!
    int visits = 0;
%>
<%-- JSP comment: this text is removed at translation time and never reaches the browser --%>
<% visits++; %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Student Information</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
    <div class="card">
        <h1>Student Information</h1>
        <form action="hello" method="post">
            <label for="name">Name</label>
            <input type="text" id="name" name="name" placeholder="Enter full name" value="${param.name}" required>

            <label for="email">Email</label>
            <input type="email" id="email" name="email" placeholder="Enter email" value="${param.email}" required>

            <label for="course">Course</label>
            <input type="text" id="course" name="course" placeholder="Enter course" value="${param.course}" required>

            <label for="age">Age</label>
            <input type="number" id="age" name="age" placeholder="Enter age" value="${param.age}" min="1" max="120" required>

            <button type="submit">Register</button>
        </form>
        <p class="hint">Page requests handled by this JSP instance: <%= visits %></p>
        <p class="links"><a href="index.jsp">Back to Login</a></p>
    </div>
<%@ include file="footer.jsp" %>
```

* `value="${param.name}"` re-fills the form from the request parameter — a static HTML page cannot
  do this, a JSP can.
* `visits` is a **declaration**: it becomes a field of the generated Servlet class, so it survives
  between requests, and the counter proves that one Servlet instance serves many requests.

### 7.2 `HelloServlet.java` — the controller

```java
package com.servlet;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import jakarta.servlet.ServletException;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/hello")
public class HelloServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        out.println("<h1>Hello Students!</h1>");
        out.println("<h2>Welcome to Servlet Programming</h2>");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String course = request.getParameter("course");
        String age = request.getParameter("age");

        request.setAttribute("name", name);
        request.setAttribute("email", email);
        request.setAttribute("course", course);
        request.setAttribute("age", age);

        request.getRequestDispatcher("result.jsp").forward(request, response);
    }
}
```

* `getParameter("name")` reads the form value whose `name` attribute is `"name"`.
* `setAttribute(...)` stores the data in **request scope**.
* `forward(...)` hands the same request (with its attributes) to `result.jsp`. The browser URL does
  not change, because this is a server-side forward, not a redirect.
* `doGet` is kept on purpose: it is the **old style** of writing HTML from Java with `PrintWriter`,
  the "before" side of the comparison.

### 7.3 `result.jsp` — the view (EL)

```jsp
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Registration Result</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
    <div class="card wide">
        <h1 class="status">Registration Successful</h1>
        <hr>
        <h3>Student Details</h3>
        <table class="details">
            <tr><th>Name</th><td>${name}</td></tr>
            <tr><th>Email</th><td>${email}</td></tr>
            <tr><th>Course</th><td>${course}</td></tr>
            <tr><th>Age</th><td>${age}</td></tr>
            <tr><th>Name (request parameter)</th><td>${param.name}</td></tr>
        </table>
        <p class="links">
            <a href="student.jsp">Register Another Student</a> &nbsp;|&nbsp;
            <a href="result-jstl.jsp">View using JSTL</a> &nbsp;|&nbsp;
            <a href="index.jsp">Login</a>
        </p>
    </div>
<%@ include file="footer.jsp" %>
```

`${name}` retrieves the request attribute that the Servlet stored — no Java code at all in the view.

### 7.4 `result-jstl.jsp` — the same view with JSTL

```jsp
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
...
<c:if test="${not empty name}">
    <h1 class="status">Registration Successful</h1>
    <table class="details">
        <tr><th>Name</th><td><c:out value="${name}"/></td></tr>
        ...
    </table>
</c:if>
<c:if test="${empty name}">
    <h1 class="status">No Student Data</h1>
    <p class="hint">Submit the registration form first, or open
        <a href="student.jsp">student.jsp</a>.</p>
</c:if>
```

`<c:out>` escapes the value, so the page is safe even if a value contains HTML characters.

### 7.5 `index.jsp` — the login page converted to JSP

`index.html` of the previous experiment renamed to `index.jsp`: same markup, plus the page directive
and `${param.username}` so a rejected login attempt keeps the typed username. It is registered as the
welcome file in `web.xml`, and `LoginServlet`, `LogoutServlet` and `AuthFilter` now redirect to
`index.jsp`.

### 7.6 `pom.xml` — JSTL dependency

```xml
<dependency>
    <groupId>jakarta.servlet</groupId>
    <artifactId>jakarta.servlet-api</artifactId>
    <version>6.1.0</version>
    <scope>provided</scope>
</dependency>
<dependency>
    <groupId>jakarta.servlet.jsp.jstl</groupId>
    <artifactId>jakarta.servlet.jsp.jstl-api</artifactId>
    <version>3.0.0</version>
</dependency>
<dependency>
    <groupId>org.glassfish.web</groupId>
    <artifactId>jakarta.servlet.jsp.jstl</artifactId>
    <version>3.0.0</version>
</dependency>
```

Tomcat 11 provides the Servlet API but **not** JSTL, so both the JSTL API and its implementation are
packaged into `WEB-INF/lib` of the WAR. The JSTL API must **not** be marked `provided`; otherwise
`result-jstl.jsp` fails with `NoClassDefFoundError: jakarta.servlet.jsp.jstl.core.ConditionalTagSupport`.

---

## 8. How it works

### 8.1 Why JSP exists

Writing a page with a Servlet means printing markup with `PrintWriter`:

```java
out.println("<h1>Registration Successful</h1>");
out.println("<p>Name: " + name + "</p>");
```

The same page in a JSP is written as markup with expressions:

```jsp
<h1>Registration Successful</h1>
<p>Name: ${name}</p>
```

The Servlet handles **processing / controller** work, the JSP handles the **presentation / view**.

### 8.2 Servlet vs JSP

| Feature | Servlet | JSP |
| --- | --- | --- |
| Form | Java class | JSP page |
| Focus | Request processing | Presentation / HTML |
| Typical role | Controller | View |
| HTML | Dynamic data | Written directly |
| Output produced with | `PrintWriter` | EL / JSTL |
| Prepared in | Java | HTML (a designer can edit it) |

### 8.3 JSP architecture — how a JSP page becomes a response

```
Browser
   |  HTTP Request
   v
Tomcat
   |
   |  JSP page (.jsp file)  <-- written directly as HTML
   |  Translation            <-- JSP is converted into Java Servlet source
   |  Compilation            <-- the source is compiled into a .class file
   |  Class loading
   |  Instantiation
   |  jspInit()              <-- once, when the JSP is put into service
   |  _jspService()          <-- per request, generates the response
   |  jspDestroy()           <-- cleanup, when the JSP leaves service
   |
   |  HTML Response
   v
Browser
```

**Translation** is the key step: a JSP file is *not* executed by Tomcat as HTML. It is first
translated into the source code of a Servlet class (in Tomcat: `org/apache/jsp/student_jsp.java`),
that source is compiled into a `.class` file, and the resulting Servlet produces the HTML. The
translation happens once; afterwards the compiled Servlet serves every request, which is why JSP is
fast.

### 8.4 JSP lifecycle

```
JSP Page
   -> Translation -> Compilation -> Class loading -> Instantiation
   -> jspInit()  ->  _jspService()  ->  jspDestroy()
```

* **`jspInit()`** — initialisation, called once when the JSP page is loaded. Variables declared with
  `<%! ... %>` are created here (that is why the `visits` counter survives between requests).
* **`_jspService()`** — processes every request and writes the response. The container calls it; you
  normally never write it yourself.
* **`jspDestroy()`** — cleanup, called before the JSP page is removed from service.

A JSP is therefore *also* a Servlet: the browser never sees the translation, only the HTML that
`_jspService()` writes.

### 8.5 Servlet -> JSP: the registration flow, step by step

```
1. Browser  : GET /servlet/student.jsp
2. Tomcat    : translates + compiles student.jsp (first time only), calls _jspService()
3. student.jsp: writes the HTML form, action="hello", method="post"

4. Browser  : POST /servlet/hello   (name, email, course, age)
5. HelloServlet.doPost():
                 request.getParameter("name")      -> reads the form field
                 request.setAttribute("name", ...) -> stores it in request scope
                 getRequestDispatcher("result.jsp").forward(request, response)
6. Tomcat    : result.jsp is translated + compiled, then _jspService() runs
7. result.jsp: ${name} -> EL looks up the attribute "name" in the request scope
                 -> writes "Aniket" into the HTML
8. Browser  : displays "Registration Successful" + the student details
```

Points to remember:

* `request.getParameter("name")` reads the **incoming form value**.
* `request.setAttribute()` stores data in **request scope** (valid until the response is sent).
* `forward()` forwards the request to `result.jsp`; the URL in the address bar stays
  `/servlet/hello`.
* `${name}` retrieves the request attribute through **EL**.

### 8.6 How EL finds a value

When the JSP evaluates `${name}`, the EL resolver searches the scopes in this order and uses the
first match:

1. Page scope (`pageContext`)
2. Request scope (`request`) — where `setAttribute()` put it
3. Session scope (`session`)
4. Application scope (`application`)
5. Any other scope (`jspxPage`, `jspPage`, `jspContext`, `facesContext`)

If nothing is found, the expression evaluates to an empty string — that is why `result.jsp` still
renders (with blank values) when it is opened directly, and why `result-jstl.jsp` checks
`${empty name}` first.

Common implicit objects available in EL:

| Expression | Meaning |
| --- | --- |
| `${name}` | Attribute `name` from the first scope that has it |
| `${student.name}` | `getName()` of the object stored in attribute `student` |
| `${param.name}` | Request parameter `name` (from the query string or the form) |
| `${sessionScope.username}` | Attribute `username` of the session |
| `${applicationScope.counter}` | Attribute `counter` of the application |
| `${header['User-Agent']}` | Request header |

### 8.7 MVC in this project

```
Browser
   |
   v
Servlet (Controller)         HelloServlet / LoginServlet
   |                          reads parameters, processes, decides the view
   v
JSP (View)                   result.jsp / index.jsp
   |                          renders the data with EL / JSTL
   v
Browser
```

JSP does not replace the Servlet. The Servlet is commonly the **controller** and the JSP is the
**view**; the data itself would come from a model layer (JavaBean, database, service class) in a
fuller MVC application.

### 8.8 JSP elements

| Element | Syntax | Purpose |
| --- | --- | --- |
| Declaration | `<%! int count = 0; %>` | Adds a class member (field/method) to the generated Servlet |
| Scriptlet | `<% String name = "Servlet"; %>` | Java code inside `_jspService()` |
| Expression | `<%= name %>` | Prints an expression into the page |
| JSP comment | `<%-- not sent to the browser --%>` | Removed at translation time, invisible in the HTML source |
| HTML comment | `<!-- ... -->` | Sent to the browser, therefore visible in "View Source" |
| Expression Language | `${name}`, `${student.name}`, `${param.name}` | Preferred modern way to read data |

Scriptlets are shown here for syllabus understanding; real applications prefer EL, JSTL and
Java-side components for presentation logic, because scriptlets mix HTML with Java and are hard to
maintain.

### 8.9 JSP directives

```jsp
<%@ page contentType="text/html;charset=UTF-8" %>     <-- page: content type and character set
<%@ include file="footer.jsp" %>                      <-- include: merge another file at translation time
<%@ taglib prefix="c" uri="jakarta.tags.core" %>      <-- taglib: use a tag library (JSTL)
```

| Directive | Used in this project for |
| --- | --- |
| `page` | `contentType` / `pageEncoding` on every JSP page |
| `include` | `footer.jsp`, included at the end of every page |
| `taglib` | `jakarta.tags.core` for JSTL in `result-jstl.jsp` |

`<%@ include %>` is a **static** include: the content of `footer.jsp` is pasted into the page before
translation, which is why the fragment must be valid in every page that includes it. (The alternative,
`<jsp:include>`, is a runtime include.)

### 8.10 Before and after the conversion

**Before (static HTML + Servlet with PrintWriter)**

```
index.html  ->  Servlet  ->  PrintWriter  ->  HTML Response  ->  Browser
```

**After (JSP + Servlet forward)**

```
student.jsp ->  Servlet  ->  result.jsp   ->  HTML Response  ->  Browser
```

The main change is the **separation of responsibilities**: the Servlet handles request processing,
the JSP handles presentation.

---

## 9. URLs to test after deployment

| Request | Result |
| --- | --- |
| `GET /servlet/` | `index.jsp` login form (welcome file) |
| `POST /servlet/login` (`admin` / `1234`) | "Login Successful" + link to home |
| `GET /servlet/home` | "Welcome admin" (session + `AuthFilter` protected) |
| `GET /servlet/student.jsp` | Registration form |
| `POST /servlet/hello` | `result.jsp` with the student details |
| `GET /servlet/hello` | "Hello Students!" (old `PrintWriter` style) |
| `GET /servlet/logout` | Session invalidated, back to `index.jsp` |

## 10. Expected output

**First page — the form (`student.jsp`):**

```
Student Information
Name:    [____________]
Email:   [____________]
Course:  [____________]
Age:     [____________]
              [ Register ]
```

**After submission — the result page (`result.jsp`):**

```
Registration Successful
----------------------------
Student Details
Name:   Aniket
Email:  aniket@example.com
Course: BCA
Age:    21
```

## 11. Build and deploy summary

```bash
cd JSPproject/servlet
mvn package                                  # -> target/servlet.war
copy target\servlet.war "%CATALINA_HOME%\webapps\servlet.war"
%CATALINA_HOME%\bin\startup.bat
# open http://localhost:8080/servlet/student.jsp
```

---

## 12. Troubleshooting

| Problem | Cause and fix |
| --- | --- |
| `404` on `/servlet/student.jsp` | WAR not copied to `webapps`, or an old exploded `webapps\servlet` folder is being served. Delete the folder, re-copy the WAR, restart Tomcat. |
| `500 ... NoClassDefFoundError: jakarta.servlet.jsp.jstl.core.ConditionalTagSupport` | JSTL API declared as `provided`. Remove `<scope>provided</scope>` from `jakarta.servlet.jsp.jstl-api` and rebuild. |
| `404` on `/servlet/` | `web.xml` welcome file must be `index.jsp`. |
| Blank values on `result.jsp` | The page was opened directly (GET). Request attributes only exist after the Servlet forwards the POST. |
| `Port 8080 already in use` | Another Tomcat is running. Stop it, or change the port in `conf/server.xml`. |
| JSP changes are not visible | Tomcat caches translated JSPs. Reload the application from `http://localhost:8080/manager/html` or restart Tomcat. |

---

## 13. License

MIT
