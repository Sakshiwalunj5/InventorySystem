# Inventory Management System (Java + JSP + Servlets + MySQL)

## 📌 Overview

This is a web-based Inventory Management System built using Java (Servlets & JSP) and MySQL.
It helps manage products, customers, and sales while maintaining accurate stock levels using database triggers.

The system ensures data consistency by enforcing constraints and automating critical operations like stock deduction and audit logging.

---

## 💡 Problem Statement

Managing inventory manually can lead to errors such as incorrect stock levels, invalid transactions, and lack of traceability.

This system solves these problems by:

* Automating stock updates
* Preventing invalid sales using validation triggers
* Maintaining audit logs for tracking changes

---

## ⚙️ Tech Stack

* Java (JDK 21)
* JSP & Servlets
* Apache Tomcat 10
* MySQL 8
* JDBC (MySQL Connector)

---

## ✨ Features

### 👩‍💻 Core Functionalities

* User authentication (Admin / Staff)
* Product & category management
* Customer management
* Sales and billing system
* Dashboard with summary metrics

### 🧠 Database-Driven Logic

* Automatic stock deduction after each sale
* Validation before sale (prevents selling more than available stock)
* Audit logging of sales transactions
* Low stock tracking (visible in "Low Stock" section)

---

## 🧠 System Logic

* When a sale is created:

  * System checks stock availability using a **BEFORE INSERT trigger**
  * If stock is insufficient → transaction is blocked

* After a sale is recorded:

  * Stock is automatically reduced using an **AFTER INSERT trigger**

* Audit tracking:

  * Each sale action is logged in `sales_audit` table

* Stock monitoring:

  * Products below minimum level are shown in **Low Stock page**
  * (No popup alerts — handled via UI view)

---

## 🔗 System Flow

JSP (Frontend)
↓
Servlets (Controller Layer)
↓
JDBC (Database Connection)
↓
MySQL Database (Triggers + Constraints)

---

## 📊 Database Highlights

* Normalized relational schema
* Foreign key constraints for data integrity
* CHECK constraints for validation
* Triggers used for:

  * Stock validation
  * Stock deduction
  * Audit logging
  * Low stock tracking

---

## 📁 Project Structure

```
InventorySystem/
│
├── src/main/java/        # Servlets & backend logic
├── src/main/webapp/      # JSP files
├── database.sql          # Database dump (with triggers)
└── README.md
```

---

## 🛠️ Setup Instructions

### 1. Clone Repository

```
git clone https://github.com/Sakshiwalunj5/InventorySystem.git
```

---

### 2. Import into Eclipse

* Open Eclipse
* File → Import → Existing Projects into Workspace
* Select project folder

---

### 3. Configure Server

* Add Apache Tomcat 10
* Deploy project

---

### 4. Database Setup

1. Open MySQL Workbench
2. Go to: Server → Data Import
3. Select `database.sql`
4. Click **Start Import**

---

## ⚠️ Important Notes

### 🔴 1. MySQL Case Sensitivity Issue

On Linux systems:

* STOCK → stock
* SALES → sales
* SALES_AUDIT → sales_audit
* STOCK_ALERT_LOG → stock_alert_log

---

### 🔴 2. Trigger DEFINER Issue

Replace:

```
DEFINER=`root`@`localhost`
```

With:

```
DEFINER=CURRENT_USER
```

or remove it.

---

### 🔴 3. Database Credentials

Update in:

```
DBConnection.java
```

---

## ▶️ Run the Project

* Start Tomcat
* Open:

```
http://localhost:8080/InventorySystem
```

---

## 🔐 Sample Login

* Admin
  Username: admin1
  Password: admin@123

* Staff
  Username: staff1
  Password: staff@123

---

## ⚠️ Limitations

* No real-time notifications (low stock shown in UI only)
* Not deployed (runs locally on Tomcat)

---

## 🚀 Future Improvements

* Add Supplier Management UI
* Add real-time alerts for low stock
* Convert to Maven project
* Improve UI/UX
* Deploy on cloud

---

## 📌 Notes

* MySQL 8+ recommended
* Designed for academic and learning purposes

---
