# Student Clinic EMR API

A comprehensive .NET 8 Web API for Student Clinic Electronic Medical Records (EMR) system with advanced features including:

- **JWT Authentication** - Secure token-based authentication
- **Role-Based Access Control (RBAC)** - Fine-grained permission management
- **Stored Procedures** - Database operations via MySQL stored procedures
- **Audit Trail** - Complete tracking of all data modifications
- **Triggers** - Automatic audit logging via database triggers
- **Indexes** - Optimized database performance
- **Views** - Pre-built reporting queries

## 🏗️ Architecture

- **Framework**: ASP.NET Core 8.0
- **Database**: MySQL 8.0+
- **ORM**: Entity Framework Core + Dapper
- **Authentication**: JWT Bearer Tokens
- **API Documentation**: Swagger/OpenAPI

## 📋 Prerequisites

- .NET 8.0 SDK or later
- MySQL 8.0 or later
- Visual Studio 2022 / VS Code / Rider
- MySQL Workbench (optional, for database management)


## 5-Minute Setup

### Step 1: Database Setup (2 minutes)

Open MySQL command line or MySQL Workbench and run:

```bash
# Option A: Using MySQL command line
mysql -u root -p -h 127.0.0.1 -P 3306

# Then paste and execute:
CREATE DATABASE IF NOT EXISTS student_clinic_emr;
```

Then run the SQL scripts in order:

```bash
# From the project directory (studentClinicAPI folder)
mysql -u root -p -h 127.0.0.1 -P 3306 student_clinic_emr < student_clinic_emr_rbac_users.sql
mysql -u root -p -h 127.0.0.1 -P 3306 student_clinic_emr < database_stored_procedures_triggers_indexes.sql
```

**OR** manually in MySQL Workbench:
1. Open `student_clinic_emr_rbac_users.sql` and execute
2. Open `database_stored_procedures_triggers_indexes.sql` and execute

### Step 2: API Setup (2 minutes)

```powershell
# Navigate to the API project folder
cd c:\UNCC\ITIS-6120-DBA\Project_2\studentClinicAPI\StudentClinicAPI

# Restore packages
dotnet restore

# Build project
dotnet build

# Run the API
dotnet run
```

### Step 3: Test the API (1 minute)

1. Open browser: https://localhost:7001/swagger
2. Click **Authorize** button
3. Test login endpoint with:
   - Email: `doc_amy@example.org`
   - Password: `Welcome!2025`
4. Copy the token from response
5. Paste into Authorization field: `Bearer <your-token>`
6. Click Authorize
7. Try any endpoint!



### Step 4:  EMRApp - Web Application setup   (2 minutes)

This project was generated with [Angular CLI](https://github.com/angular/angular-cli) version 17.1.0.

## Development server

Run `ng serve` for a dev server. Navigate to `http://localhost:4200/`. The application will automatically reload if you change any of the source files.

## Code scaffolding

Run `ng generate component component-name` to generate a new component. You can also use `ng generate directive|pipe|service|class|guard|interface|enum|module`.

## Build

Run `ng build` to build the project. The build artifacts will be stored in the `dist/` directory.

## Running unit tests

Run `ng test` to execute the unit tests via [Karma](https://karma-runner.github.io).

## Running end-to-end tests

Run `ng e2e` to execute the end-to-end tests via a platform of your choice. To use this command, you need to first add a package that implements end-to-end testing capabilities.

## 🚀 Setup Instructions

### 1. Database Setup

First, ensure MySQL is running on `localhost:3306` with the following credentials:
- **Host**: 127.0.0.1
- **Port**: 3306
- **Username**: root
- **Password**: root

#### Create and Initialize Database

```sql
-- Step 1: Create the base database and tables
-- Run student_clinic_emr.sql for full DB or to create a minimal patient/provider/visit schema


CREATE DATABASE IF NOT EXISTS student_clinic_emr;
USE student_clinic_emr;

-- Minimal base tables (if not already created)
CREATE TABLE IF NOT EXISTS patient (
  patient_id INT AUTO_INCREMENT PRIMARY KEY,
  mrn VARCHAR(20) NOT NULL UNIQUE,
  first_name VARCHAR(60) NOT NULL,
  last_name VARCHAR(60) NOT NULL,
  dob DATE NOT NULL,
  sex CHAR(1) NOT NULL,
  phone VARCHAR(20),
  email VARCHAR(150),
  address_line1 VARCHAR(100),
  address_line2 VARCHAR(100),
  city VARCHAR(50),
  state VARCHAR(20),
  zip VARCHAR(10),
  emergency_contact_name VARCHAR(100),
  emergency_contact_phone VARCHAR(20),
  created_at DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  updated_at DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3)
);

CREATE TABLE IF NOT EXISTS provider (
  provider_id INT AUTO_INCREMENT PRIMARY KEY,
  first_name VARCHAR(60) NOT NULL,
  last_name VARCHAR(60) NOT NULL,
  specialty VARCHAR(100),
  npi VARCHAR(10),
  created_at DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  updated_at DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3)
);

CREATE TABLE IF NOT EXISTS visit (
  visit_id INT AUTO_INCREMENT PRIMARY KEY,
  patient_id INT NOT NULL,
  provider_id INT NOT NULL,
  appointment_id INT,
  check_in_time DATETIME(3),
  check_out_time DATETIME(3),
  status VARCHAR(20) DEFAULT 'Scheduled',
  chief_complaint VARCHAR(500),
  created_at DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  updated_at DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  CONSTRAINT fk_visit_patient FOREIGN KEY (patient_id) REFERENCES patient(patient_id),
  CONSTRAINT fk_visit_provider FOREIGN KEY (provider_id) REFERENCES provider(provider_id)
);

CREATE TABLE IF NOT EXISTS prescription (
  prescription_id INT AUTO_INCREMENT PRIMARY KEY,
  visit_id INT NOT NULL,
  drug_code VARCHAR(20) NOT NULL,
  drug_name VARCHAR(200),
  dose VARCHAR(50),
  dose_unit VARCHAR(20),
  route VARCHAR(50),
  frequency VARCHAR(100),
  duration_days INT,
  quantity DECIMAL(10,2),
  refills INT,
  start_date DATE,
  end_date DATE,
  status VARCHAR(20) DEFAULT 'Active',
  created_at DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  updated_at DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  CONSTRAINT fk_rx_visit FOREIGN KEY (visit_id) REFERENCES visit(visit_id)
);

CREATE TABLE IF NOT EXISTS staff_user (
  user_id INT AUTO_INCREMENT PRIMARY KEY,
  username VARCHAR(100) NOT NULL UNIQUE,
  display_name VARCHAR(150),
  is_active BOOLEAN DEFAULT TRUE,
  created_at DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  updated_at DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3)
);

-- Step 2: Run the RBAC schema
SOURCE student_clinic_emr_rbac_users.sql;

-- Step 3: Run stored procedures, triggers, and indexes
SOURCE database_stored_procedures_triggers_indexes.sql;
```

Or run each script individually:

```bash
# From the project directory
mysql -u root -p -h 127.0.0.1 -P 3306 < student_clinic_emr_rbac_users.sql
mysql -u root -p -h 127.0.0.1 -P 3306 < database_stored_procedures_triggers_indexes.sql
```

### 2. API Setup

#### Clone or Navigate to Project

```bash
cd c:\UNCC\ITIS-6120-DBA\Project_2\studentClinicAPI\StudentClinicAPI
```

#### Update Connection String (if needed)

Edit `appsettings.json`:

```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Server=127.0.0.1;Port=3306;Database=student_clinic_emr;User=root;Password=root;AllowUserVariables=True;UseAffectedRows=False;"
  }
}
```

#### Restore NuGet Packages

```bash
dotnet restore
```

#### Build the Project

```bash
dotnet build
```

#### Run the API

```bash
dotnet run
```

The API will start on:
- **HTTPS**: https://localhost:7001
- **HTTP**: http://localhost:5001
- **Swagger UI**: https://localhost:7001/swagger

## 🔐 Authentication

### Default Test Users

After running the RBAC SQL script, you'll have these test users:

| Email | Password | Role |
|-------|----------|------|
| doc_amy@example.org | Welcome!2025 | Doctor |
| doc_ben@example.org | Welcome!2025 | Doctor |
| nurse_cara@example.org | Welcome!2025 | Nurse |
| nurse_dan@example.org | Welcome!2025 | Nurse |
| support_ella@example.org | Welcome!2025 | Hospital Support |
| support_fred@example.org | Welcome!2025 | Hospital Support |
| manager_gina@example.org | Welcome!2025 | Hospital Manager |
| itadmin_hank@example.org | Welcome!2025 | Hospital IT Admin |
| pharm_ivy@example.org | Welcome!2025 | Pharmacist |
| pharm_mgr_jack@example.org | Welcome!2025 | Pharmacy Manager |

### Login Process

1. **POST** `/api/auth/login`

Request:
```json
{
  "email": "doc_amy@example.org",
  "password": "Welcome!2025"
}
```

Response:
```json
{
  "success": true,
  "data": {
    "userId": 1,
    "username": "doc_amy",
    "email": "doc_amy@example.org",
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "roles": ["Doctor"],
    "permissions": [
      { "resource": "patient", "action": "SELECT" },
      { "resource": "visit", "action": "INSERT" }
    ]
  }
}
```

2. **Use the token** in subsequent requests:
   - Header: `Authorization: Bearer <token>`

## 📚 API Endpoints

### Authentication

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| POST | `/api/auth/login` | Login and get JWT token | ❌ |
| POST | `/api/auth/register` | Register new user | ❌ |
| POST | `/api/auth/change-password` | Change user password | ✅ |
| GET | `/api/auth/me` | Get current user info | ✅ |

### Patients

| Method | Endpoint | Description | Permission |
|--------|----------|-------------|------------|
| GET | `/api/patients` | Get all patients | patient:SELECT |
| GET | `/api/patients/{id}` | Get patient by ID | patient:SELECT |
| GET | `/api/patients/mrn/{mrn}` | Get patient by MRN | patient:SELECT |
| GET | `/api/patients/search/{term}` | Search patients | patient:SELECT |
| POST | `/api/patients` | Create new patient | patient:INSERT |
| PUT | `/api/patients/{id}` | Update patient | patient:UPDATE |
| DELETE | `/api/patients/{id}` | Delete patient | patient:DELETE |

### Visits

| Method | Endpoint | Description | Permission |
|--------|----------|-------------|------------|
| GET | `/api/visits` | Get all visits | visit:SELECT |
| GET | `/api/visits/{id}` | Get visit by ID | visit:SELECT |
| GET | `/api/visits/patient/{patientId}` | Get visits by patient | visit:SELECT |
| POST | `/api/visits` | Create new visit | visit:INSERT |
| PUT | `/api/visits/{id}` | Update visit | visit:UPDATE |
| DELETE | `/api/visits/{id}` | Delete visit | visit:DELETE |

### Prescriptions

| Method | Endpoint | Description | Permission |
|--------|----------|-------------|------------|
| GET | `/api/prescriptions` | Get all prescriptions | prescription:SELECT |
| GET | `/api/prescriptions/{id}` | Get prescription by ID | prescription:SELECT |
| GET | `/api/prescriptions/visit/{visitId}` | Get by visit | prescription:SELECT |
| GET | `/api/prescriptions/patient/{patientId}` | Get by patient | prescription:SELECT |
| POST | `/api/prescriptions` | Create prescription | prescription:INSERT |
| PUT | `/api/prescriptions/{id}` | Update prescription | prescription:UPDATE |
| DELETE | `/api/prescriptions/{id}` | Delete prescription | prescription:DELETE |

### Pharmacy

| Method | Endpoint | Description | Permission |
|--------|----------|-------------|------------|
| GET | `/api/pharmacy/pending` | Get pending prescriptions | pharmacy:DISPENSE |
| POST | `/api/pharmacy/dispense` | Dispense prescription | pharmacy:DISPENSE |
| GET | `/api/pharmacy/dispense-history/{rxId}` | Get dispense history | pharmacy:DISPENSE |

### Users & Administration

| Method | Endpoint | Description | Permission |
|--------|----------|-------------|------------|
| GET | `/api/users` | Get all users | admin:MANAGE_USERS |
| GET | `/api/users/{id}` | Get user by ID | admin:MANAGE_USERS |
| POST | `/api/users/{userId}/roles/{roleId}` | Assign role | admin:MANAGE_USERS |
| DELETE | `/api/users/{userId}/roles/{roleId}` | Remove role | admin:MANAGE_USERS |
| POST | `/api/users/{userId}/departments/{deptId}` | Assign department | admin:MANAGE_USERS |
| DELETE | `/api/users/{userId}/departments/{deptId}` | Remove department | admin:MANAGE_USERS |

### Audit Logs

| Method | Endpoint | Description | Permission |
|--------|----------|-------------|------------|
| GET | `/api/auditlog` | Get audit logs (filterable) | admin:MANAGE_USERS |
| GET | `/api/auditlog/{id}` | Get audit log by ID | admin:MANAGE_USERS |

### Departments

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| GET | `/api/departments` | Get all departments | ✅ |
| GET | `/api/departments/{id}` | Get department by ID | ✅ |

## 🧪 Testing with Swagger

1. Navigate to: https://localhost:7001/swagger
2. Click **"Authorize"** button (top right)
3. Login to get a token:
   - Use `/api/auth/login` endpoint
   - Copy the token from the response
4. Enter: `Bearer <your-token-here>`
5. Click **Authorize**
6. Now you can test all endpoints!

## 🔒 Role-Based Access Control (RBAC)

### Roles

| Role | Permissions |
|------|-------------|
| **Doctor** | Full access to patients, visits, diagnoses, prescriptions, orders, results |
| **Nurse** | Read/write patients, visits, observations, orders; read-only prescriptions |
| **Hospital Support** | Read-only access to patients and visits |
| **Hospital Manager** | Read-only access to all clinical data |
| **Hospital IT Admin** | User management and system administration |
| **Pharmacist** | View prescriptions, dispense medications, view inventory |
| **Pharmacy Manager** | All pharmacist permissions + inventory management |
| **Patient** | View own medical records (portal access) |

### Permission Format

Permissions are in `resource:action` format:
- `patient:SELECT` - View patients
- `prescription:INSERT` - Create prescriptions
- `pharmacy:DISPENSE` - Dispense medications
- `admin:MANAGE_USERS` - User management

## 📊 Database Features

### Stored Procedures

All CRUD operations use stored procedures for:
- **Security**: Controlled data access
- **Performance**: Precompiled execution
- **Consistency**: Centralized business logic

Examples:
- `sp_create_patient` - Create new patient
- `sp_get_prescriptions_by_patient` - Get patient prescriptions
- `sp_dispense_prescription` - Record medication dispense

### Triggers

Automatic audit logging via triggers:
- `trg_patient_after_insert` - Log patient creation
- `trg_patient_after_update` - Log patient updates
- `trg_prescription_after_update` - Log prescription changes

### Indexes

Performance-optimized indexes on:
- Patient: name, MRN, email, DOB
- Visit: patient_id, check_in_time, status
- Prescription: drug_code, status, dates
- Audit Log: table_name, user_id, created_at

### Views

Pre-built reporting views:
- `v_patient_visit_summary` - Patient visit statistics
- `v_active_prescriptions` - Currently active prescriptions
- `v_staff_activity_summary` - Staff activity tracking
- `v_pharmacy_prescriptions` - Pharmacy queue view

## 🛡️ Security Features

1. **JWT Authentication**: Secure token-based auth with 8-hour expiration
2. **Password Hashing**: SHA-256 hashing (matching SQL user table)
3. **Role-Based Authorization**: Permission middleware checks all requests
4. **Audit Trail**: Complete tracking of all data modifications
5. **SQL Injection Protection**: Parameterized queries and stored procedures
6. **CORS**: Configurable cross-origin resource sharing

## 📝 Audit Trail

Every data modification is automatically logged with:
- **Table Name**: Which table was modified
- **Record ID**: Specific record affected
- **Action**: INSERT, UPDATE, or DELETE
- **User ID**: Who made the change
- **Old/New Values**: JSON snapshot of changes
- **IP Address**: Client IP
- **User Agent**: Client browser/app
- **Timestamp**: When it happened

Query audit logs:
```http
GET /api/auditlog?tableName=patient&userId=1&startDate=2025-11-01
```

## 🔧 Configuration

### appsettings.json

```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Server=127.0.0.1;Port=3306;Database=student_clinic_emr;User=root;Password=root;AllowUserVariables=True;UseAffectedRows=False;"
  },
  "JwtSettings": {
    "SecretKey": "YourSuperSecretKeyForJWT_MinimumLength32Characters_StudentClinicEMR2025!",
    "Issuer": "StudentClinicEMR",
    "Audience": "StudentClinicEMR",
    "ExpirationMinutes": 480
  }
}
```

**Important**: Change the JWT `SecretKey` in production!

## 🚨 Troubleshooting

### Cannot connect to database
- Verify MySQL is running: `mysql -u root -p`
- Check connection string in `appsettings.json`
- Ensure port 3306 is not blocked by firewall

### 401 Unauthorized errors
- Verify you're sending the JWT token in the `Authorization` header
- Token format: `Bearer <token>`
- Check token hasn't expired (8 hours default)

### 403 Forbidden errors
- User doesn't have required permission
- Check user roles: `GET /api/auth/me`
- Verify RBAC is configured correctly in database

### Stored procedure not found
- Run `database_stored_procedures_triggers_indexes.sql`
- Verify procedures exist: `SHOW PROCEDURE STATUS WHERE Db = 'student_clinic_emr';`

## 📦 Project Structure

```
StudentClinicAPI/
├── Controllers/          # API endpoint controllers
│   ├── AuthController.cs
│   ├── PatientsController.cs
│   ├── VisitsController.cs
│   ├── PrescriptionsController.cs
│   └── UsersController.cs
├── Models/              # Entity models
│   ├── Patient.cs
│   ├── Visit.cs
│   ├── Prescription.cs
│   ├── StaffUser.cs
│   └── AuditLog.cs
├── Services/            # Business logic services
│   ├── IServices.cs
│   ├── AuthService.cs
│   ├── PatientService.cs
│   └── PrescriptionService.cs
├── Data/               # Database context
│   └── StudentClinicDbContext.cs
├── DTOs/               # Data transfer objects
│   └── CommonDTOs.cs
├── Middleware/         # Custom middleware
│   ├── AuditLogMiddleware.cs
│   └── PermissionMiddleware.cs
├── Program.cs          # Application entry point
└── appsettings.json    # Configuration
```

## 🎯 Features Checklist

- ✅ JWT Authentication
- ✅ Role-Based Access Control (RBAC)
- ✅ Stored Procedures
- ✅ Database Triggers
- ✅ Performance Indexes
- ✅ Database Views
- ✅ Audit Trail API
- ✅ User Management
- ✅ Patient Management
- ✅ Visit Management
- ✅ Prescription Management
- ✅ Pharmacy Dispensing
- ✅ Department Management
- ✅ Swagger Documentation
- ✅ Exception Handling
- ✅ Logging

## 📖 Additional Resources

- [ASP.NET Core Documentation](https://learn.microsoft.com/en-us/aspnet/core/)
- [Entity Framework Core](https://learn.microsoft.com/en-us/ef/core/)
- [JWT Authentication](https://jwt.io/)
- [MySQL Documentation](https://dev.mysql.com/doc/)
- [Dapper ORM](https://github.com/DapperLib/Dapper)

## 👥 Support

For issues or questions:
1. Check this README
2. Review Swagger documentation
3. Check application logs
4. Verify database connections and permissions

## 📄 License

This is a student project for ITIS-6120 Database Administration course.

---

**Built with ❤️ for Student Clinic EMR System**
