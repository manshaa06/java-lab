# Experiment 6: Student Registration Form (Web Application & Tomcat)

## 📌 Overview
This experiment demonstrates deploying a **Web-based Student Registration Form** on the **Apache Tomcat** web application server. It integrates semantic **HTML5**, responsive **CSS3**, and client-side **JavaScript Form Validation**.

---

## 🏗️ Web Architecture & Deployment

```
   ┌─────────────────────────────────────────────────────────────┐
   │                       Web Browser                           │
   │               (http://localhost:8080/studentform/)          │
   └──────────────────────────────┬──────────────────────────────┘
                                  │ HTTP GET / POST
                                  ▼
   ┌─────────────────────────────────────────────────────────────┐
   │             Apache Tomcat 11 Web Application Server         │
   │            (Softwares/apache-tomcat-11.0.25/webapps)        │
   │                                                             │
   │                      studentform/                           │
   │                        └── index.html                       │
   └─────────────────────────────────────────────────────────────┘
```

### Form Fields & Client-side Validation
- **Full Name**: Required text input.
- **Roll Number**: Required text input.
- **Email**: Email format validation (`type="email"`).
- **Age**: Numeric constraint with `min="1"` and `max="120"`.
- **Branch**: Dropdown menu (`<select>`: CSE, IT, ECE, MECH, CIVIL).
- **Gender**: Radio button group (Male / Female / Other).
- **Hobbies**: Multi-select checkboxes (Reading, Sports, Music, Coding).
- **Address**: Multi-line `<textarea>`.
- **Validation**: Pure JavaScript `validateForm()` prevents submission if any required field is omitted, providing modal summary feedback upon valid submission.

---

## 🚀 How to Run

### Method 1: Deploy with Bundled Apache Tomcat (Recommended)
1. Ensure the `studentform` folder is present in Tomcat's `webapps` directory (pre-configured in `Softwares/apache-tomcat-11.0.25/webapps/studentform`).
2. Start Tomcat:
   ```cmd
   # Navigate to Tomcat bin directory:
   cd Softwares\apache-tomcat-11.0.25\bin

   # Start Tomcat (Windows):
   startup.bat
   ```
   *(On Linux/macOS: `./startup.sh`)*

3. Open your browser and navigate to:
   ```
   http://localhost:8080/studentform/
   ```

4. To stop Tomcat:
   ```cmd
   shutdown.bat
   ```

---

### Method 2: Direct Local Browser Preview
You can also preview and test the form validation directly in any web browser without starting Tomcat:
- Double click `index.html` or open it with your browser:
  ```cmd
  start index.html
  ```

---

## 💡 Key Concepts Covered
- **Web Server Deployment**: Deploying static web archives and directories inside Tomcat's `webapps/`.
- **HTTP Web Architecture**: Standard request/response lifecycle.
- **DOM Form Validation**: Intercepting form submission via `onsubmit="return validateForm()"`.
- **CSS Box Model & Styling**: Box-sizing, flex/block layout, hover states, and modern shadows.
