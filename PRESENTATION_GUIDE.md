# 🏆 SMEC Connect Multi-Tenant SaaS: Presentation & Live Demo Guide

Welcome to the live presentation guide for **SMEC Connect**, an enterprise-grade Multi-Tenant Educational SaaS platform built with **Django REST Framework** and **Flutter Mobile**.

---

## 🔑 Demo Account Credentials

| Role | Email Address | Password | Key Capabilities & Highlights |
| :--- | :--- | :--- | :--- |
| **Global Super Admin** | `superadmin@smecconnect.com` | `superadmin123` | Multi-Tenant SaaS Console, AI Token Metrics, Institute Credit Allocations |
| **Institute Admin** | `admin@smec.edu` | `admin123` | Admissions Lead CRM, User Onboarding, Fee Invoices, Audit Activity Logs |
| **Faculty Trainer** | `trainer@smec.edu` | `trainer123` | HMAC Dynamic QR Generator, Manual Roll Call, Homework Submission Grading |
| **Student** | `student@smec.edu` | `student123` | Attendance Dashboard, QR Scanner, 24/7 AI Tutor, Leave Application, ID Card |
| **Parent** | `parent@smec.edu` | `parent123` | Child Performance Tracking, Fee Payment Receipts, Faculty Helpdesk |

---

## 🚀 1-Click Presentation Launch
Double-click **`run_project.bat`** in the project root folder. It automatically:
1. Starts the Django REST backend server at `http://127.0.0.1:8000/api/v1/`.
2. Serves OpenAPI Swagger documentation at `http://127.0.0.1:8000/api/docs/`.
3. Launches the Flutter application in Chrome web preview.

---

## 🎬 5-Step Live Presentation Script

### **Step 1: Introduction & Multi-Tenant SaaS Architecture**
- Highlight strict multi-tenant isolation (`TenantScopedQuerySetMixin` + DRF Permission Guards).
- Show how Institute Admins are strictly scoped to their own institute data, while Global Super Admins manage cross-tenant SaaS subscriptions.

### **Step 2: Dynamic QR & Geofenced Attendance Engine**
- Log in as **Trainer** (`trainer@smec.edu`), launch **Dynamic Session QR Generator** (HMAC-SHA256 signature auto-refreshing every 10s with 150m Haversine GPS geofence).
- Log in as **Student** (`student@smec.edu`), scan QR code or verify GPS location.

### **Step 3: Grounded AI Assistant Engine**
- Open **AI Study Tutor** (`/ai-chatbot`). Show real database-grounded Q&A for student attendance, fee status, and assignment tasks.

### **Step 4: Enterprise SaaS Modules (Admissions CRM & Support Tickets)**
- Show **Admissions Lead CRM** (`/admissions-crm`) with lead pipeline stages and lead capture form.
- Show **Helpdesk Support Desk** (`/support-tickets`) with SLA status tracking and staff reply threads.

### **Step 5: Fee Payments & Digital PDF Invoicing**
- Open **Fee & Payment Portal** (`/fees`). Simulate online UPI/Card payment, update status to `PAID`, and view the itemized digital invoice receipt (`/invoice-receipt`).

---

## 🧪 Technical Verification Proofs
- **Automated Backend Tests**: `15 / 15 Tests Passed (OK)`
- **Flutter Code Quality**: `flutter analyze` -> `No issues found!`
- **GitHub Repository**: [https://github.com/sreeragp01/institute.git](https://github.com/sreeragp01/institute.git)
