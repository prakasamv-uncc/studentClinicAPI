
/* =====================================================================
   Student Clinic EMR — RBAC + Departments + User Registration + 20 Users
   One-File Add-On (MySQL 8+)
   ---------------------------------------------------------------------
   Run AFTER loading the base Student Clinic EMR schema.
   What this script adds:
     1) Departments and staff/provider mappings
     2) Application-level RBAC tables + seed permissions
     3) Session helper functions for scoping
     4) Secure views for Support Staff, Pharmacy, and Patient portal
     5) Pharmacy dispense tracking
     6) Native MySQL roles and GRANTs
     7) Simple user registration tables
     8) 20 synthetic users (10 staff, 10 patients) + role & department mapping
   ===================================================================== */

USE student_clinic_emr;

-- =========================
-- 1) Departments & Mapping
-- =========================
CREATE TABLE IF NOT EXISTS department (
  department_id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(120) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS provider_department (
  provider_id INT NOT NULL,
  department_id INT NOT NULL,
  PRIMARY KEY (provider_id, department_id),
  CONSTRAINT fk_pd_provider FOREIGN KEY (provider_id)
    REFERENCES provider(provider_id)
    ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_pd_department FOREIGN KEY (department_id)
    REFERENCES department(department_id)
    ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS staff_department (
  user_id INT NOT NULL,
  department_id INT NOT NULL,
  PRIMARY KEY (user_id, department_id),
  CONSTRAINT fk_sd_user FOREIGN KEY (user_id)
    REFERENCES staff_user(user_id)
    ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_sd_department FOREIGN KEY (department_id)
    REFERENCES department(department_id)
    ON UPDATE CASCADE ON DELETE CASCADE
);

INSERT INTO department (name) VALUES
  ('Family Medicine'), ('Internal Medicine'), ('Pediatrics'),
  ('Front Desk'), ('Management'), ('IT'), ('Pharmacy')
ON DUPLICATE KEY UPDATE name = VALUES(name);

-- Optional provider → department mapping (based on provider.specialty)
INSERT IGNORE INTO provider_department (provider_id, department_id)
SELECT pr.provider_id,
       CASE pr.specialty
         WHEN 'Family Medicine'   THEN (SELECT department_id FROM department WHERE name='Family Medicine')
         WHEN 'Internal Medicine' THEN (SELECT department_id FROM department WHERE name='Internal Medicine')
         WHEN 'Pediatrics'        THEN (SELECT department_id FROM department WHERE name='Pediatrics')
         ELSE (SELECT department_id FROM department WHERE name='Management')
       END
FROM provider pr;

-- ================================
-- 2) Application-level RBAC (tables)
-- ================================
CREATE TABLE IF NOT EXISTS role (
  role_id INT AUTO_INCREMENT PRIMARY KEY,
  role_name VARCHAR(80) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS permission (
  permission_id INT AUTO_INCREMENT PRIMARY KEY,
  resource VARCHAR(80) NOT NULL,
  action   VARCHAR(40) NOT NULL,
  UNIQUE KEY uq_perm (resource, action)
);

CREATE TABLE IF NOT EXISTS role_permission (
  role_id INT NOT NULL,
  permission_id INT NOT NULL,
  PRIMARY KEY (role_id, permission_id),
  CONSTRAINT fk_rp_role FOREIGN KEY (role_id) REFERENCES role(role_id)
    ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_rp_perm FOREIGN KEY (permission_id) REFERENCES permission(permission_id)
    ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS user_role (
  user_id INT NOT NULL,
  role_id INT NOT NULL,
  PRIMARY KEY (user_id, role_id),
  CONSTRAINT fk_ur_user FOREIGN KEY (user_id) REFERENCES staff_user(user_id)
    ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_ur_role FOREIGN KEY (role_id) REFERENCES role(role_id)
    ON UPDATE CASCADE ON DELETE CASCADE
);

INSERT INTO role (role_name) VALUES
 ('Doctor'), ('Nurse'), ('Hospital Support'),
 ('Hospital Manager'), ('Hospital IT Admin'),
 ('Pharmacist'), ('Pharmacy Manager'), ('Patient')
ON DUPLICATE KEY UPDATE role_name = VALUES(role_name);

INSERT INTO permission (resource, action) VALUES
 ('patient','SELECT'), ('patient','UPDATE'),
 ('visit','SELECT'), ('visit','INSERT'), ('visit','UPDATE'),
 ('diagnosis','SELECT'), ('diagnosis','INSERT'), ('diagnosis','UPDATE'),
 ('observation','SELECT'), ('observation','INSERT'),
 ('prescription','SELECT'), ('prescription','INSERT'), ('prescription','UPDATE'),
 ('order','SELECT'), ('order','INSERT'), ('order','UPDATE'),
 ('result','SELECT'), ('billing','SELECT'),
 ('inventory','SELECT'), ('inventory','UPDATE'),
 ('admin','MANAGE_USERS'),
 ('pharmacy','DISPENSE')
ON DUPLICATE KEY UPDATE resource = VALUES(resource), action = VALUES(action);

-- Role → permission assignments
-- Doctor
INSERT IGNORE INTO role_permission
SELECT r.role_id, p.permission_id
FROM role r
JOIN permission p
  ON (r.role_name='Doctor' AND (p.resource,p.action) IN (('patient','SELECT'),
    ('visit','SELECT'),('visit','INSERT'),('visit','UPDATE'),
    ('diagnosis','SELECT'),('diagnosis','INSERT'),('diagnosis','UPDATE'),
    ('observation','SELECT'),('observation','INSERT'),
    ('prescription','SELECT'),('prescription','INSERT'),('prescription','UPDATE'),
    ('order','SELECT'),('order','INSERT'),('order','UPDATE'),
    ('result','SELECT'),('billing','SELECT')));

-- Nurse
INSERT IGNORE INTO role_permission
SELECT r.role_id, p.permission_id
FROM role r JOIN permission p
  ON (r.role_name='Nurse' AND (p.resource,p.action) IN (('patient','SELECT'),
    ('visit','SELECT'),('visit','INSERT'),('visit','UPDATE'),
    ('observation','SELECT'),('observation','INSERT'),
    ('order','SELECT'),('order','INSERT'),('order','UPDATE'),
    ('result','SELECT')));

-- Hospital Support (Front Desk)
INSERT IGNORE INTO role_permission
SELECT r.role_id, p.permission_id
FROM role r JOIN permission p
  ON (r.role_name='Hospital Support' AND (p.resource,p.action) IN (('patient','SELECT'),
    ('visit','SELECT')));

-- Hospital Manager
INSERT IGNORE INTO role_permission
SELECT r.role_id, p.permission_id
FROM role r JOIN permission p
  ON (r.role_name='Hospital Manager' AND (p.resource,p.action) IN (('patient','SELECT'),
    ('visit','SELECT'),('diagnosis','SELECT'),('observation','SELECT'),
    ('prescription','SELECT'),('order','SELECT'),('result','SELECT'),
    ('billing','SELECT')));

-- Hospital IT Admin
INSERT IGNORE INTO role_permission
SELECT r.role_id, p.permission_id
FROM role r JOIN permission p
  ON (r.role_name='Hospital IT Admin' AND (p.resource,p.action) IN (('admin','MANAGE_USERS')));

-- Pharmacist
INSERT IGNORE INTO role_permission
SELECT r.role_id, p.permission_id
FROM role r JOIN permission p
  ON (r.role_name='Pharmacist' AND (p.resource,p.action) IN (('prescription','SELECT'),
    ('pharmacy','DISPENSE'),('inventory','SELECT')));

-- Pharmacy Manager
INSERT IGNORE INTO role_permission
SELECT r.role_id, p.permission_id
FROM role r JOIN permission p
  ON (r.role_name='Pharmacy Manager' AND (p.resource,p.action) IN (('prescription','SELECT'),
    ('pharmacy','DISPENSE'),('inventory','SELECT'),('inventory','UPDATE')));

-- Patient
INSERT IGNORE INTO role_permission
SELECT r.role_id, p.permission_id
FROM role r JOIN permission p
  ON (r.role_name='Patient' AND (p.resource,p.action) IN (('patient','SELECT'),
    ('visit','SELECT'),('diagnosis','SELECT'),('observation','SELECT'),
    ('prescription','SELECT'),('order','SELECT'),('result','SELECT'),('billing','SELECT')));

-- ==================================
-- 3) Session Helper Functions (scopes)
-- ==================================
DROP FUNCTION IF EXISTS app_user_id;
DELIMITER $$
CREATE FUNCTION app_user_id() RETURNS INT
DETERMINISTIC
RETURN @app_user_id; $$
DELIMITER ;

DROP FUNCTION IF EXISTS portal_patient_id;
DELIMITER $$
CREATE FUNCTION portal_patient_id() RETURNS INT
DETERMINISTIC
RETURN @portal_patient_id; $$
DELIMITER ;

-- ==========================
-- 4) Secure Views (row/cols)
-- ==========================
DROP VIEW IF EXISTS v_support_patient_schedule;
CREATE SQL SECURITY DEFINER VIEW v_support_patient_schedule AS
SELECT DISTINCT
  v.visit_id,
  p.patient_id, p.mrn, p.first_name, p.last_name, p.dob, p.phone, p.email,
  v.check_in_time, v.check_out_time, v.status AS visit_status,
  a.scheduled_start, a.scheduled_end, a.status AS appt_status,
  pr.provider_id, pr.first_name AS provider_first, pr.last_name AS provider_last
FROM visit v
JOIN patient p ON p.patient_id = v.patient_id
LEFT JOIN appointment a ON a.appointment_id = v.appointment_id
JOIN provider pr ON pr.provider_id = v.provider_id
JOIN provider_department pd ON pd.provider_id = pr.provider_id
JOIN staff_department sd ON sd.department_id = pd.department_id
WHERE sd.user_id = app_user_id();

DROP VIEW IF EXISTS v_pharmacy_prescriptions;
CREATE SQL SECURITY DEFINER VIEW v_pharmacy_prescriptions AS
SELECT
  rx.prescription_id, rx.visit_id,
  p.patient_id, p.first_name, p.last_name, p.dob,
  rx.drug_code, d.drug_name, rx.dose, rx.dose_unit, rx.route, rx.frequency,
  rx.duration_days, rx.quantity, rx.refills, rx.start_date, rx.end_date, rx.status,
  pr.provider_id, pr.first_name AS provider_first, pr.last_name AS provider_last
FROM prescription rx
JOIN visit v  ON v.visit_id = rx.visit_id
JOIN patient p ON p.patient_id = v.patient_id
JOIN provider pr ON pr.provider_id = v.provider_id
JOIN rx_drug_ref d ON d.drug_code = rx.drug_code;

DROP VIEW IF EXISTS v_my_visits;
CREATE SQL SECURITY DEFINER VIEW v_my_visits AS
SELECT v.*
FROM visit v
WHERE v.patient_id = portal_patient_id();

DROP VIEW IF EXISTS v_my_diagnoses;
CREATE SQL SECURITY DEFINER VIEW v_my_diagnoses AS
SELECT d.*
FROM diagnosis d
JOIN visit v ON v.visit_id = d.visit_id
WHERE v.patient_id = portal_patient_id();

DROP VIEW IF EXISTS v_my_prescriptions;
CREATE SQL SECURITY DEFINER VIEW v_my_prescriptions AS
SELECT rx.*
FROM prescription rx
JOIN visit v ON v.visit_id = rx.visit_id
WHERE v.patient_id = portal_patient_id();

DROP VIEW IF EXISTS v_my_results;
CREATE SQL SECURITY DEFINER VIEW v_my_results AS
SELECT r.*
FROM result r
JOIN `order` o ON o.order_id = r.order_id
JOIN visit v ON v.visit_id = o.visit_id
WHERE v.patient_id = portal_patient_id();

DROP VIEW IF EXISTS v_my_billing;
CREATE SQL SECURITY DEFINER VIEW v_my_billing AS
SELECT b.*
FROM billing_line b
JOIN visit v ON v.visit_id = b.visit_id
WHERE v.patient_id = portal_patient_id();

-- =============================
-- 5) Pharmacy Dispense tracking
-- =============================
CREATE TABLE IF NOT EXISTS pharmacy_dispense (
  dispense_id INT AUTO_INCREMENT PRIMARY KEY,
  prescription_id INT NOT NULL,
  dispensed_by_user_id INT NOT NULL,
  dispensed_qty DECIMAL(10,2) NOT NULL,
  dispensed_at DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  notes VARCHAR(200),
  CONSTRAINT fk_disp_rx FOREIGN KEY (prescription_id)
    REFERENCES prescription(prescription_id)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_disp_user FOREIGN KEY (dispensed_by_user_id)
    REFERENCES staff_user(user_id)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  CHECK (dispensed_qty > 0)
);

-- ==============================
-- 6) Native MySQL ROLES + GRANTs
-- ==============================
CREATE ROLE IF NOT EXISTS `Doctor`, `Nurse`, `Hospital Support`,
                         `Hospital Manager`, `Hospital IT Admin`,
                         `Pharmacist`, `Pharmacy Manager`, `Patient`;

GRANT SELECT, INSERT, UPDATE ON student_clinic_emr.patient       TO `Doctor`, `Nurse`;
GRANT SELECT, INSERT, UPDATE ON student_clinic_emr.visit         TO `Doctor`, `Nurse`;
GRANT SELECT, INSERT, UPDATE ON student_clinic_emr.diagnosis     TO `Doctor`;
GRANT SELECT                  ON student_clinic_emr.diagnosis     TO `Nurse`;
GRANT SELECT, INSERT          ON student_clinic_emr.observation   TO `Doctor`, `Nurse`;
GRANT SELECT, INSERT, UPDATE ON student_clinic_emr.prescription  TO `Doctor`;
GRANT SELECT                  ON student_clinic_emr.prescription  TO `Nurse`;
GRANT SELECT, INSERT, UPDATE ON student_clinic_emr.`order`       TO `Doctor`, `Nurse`;
GRANT SELECT                  ON student_clinic_emr.result        TO `Doctor`, `Nurse`;
GRANT SELECT                  ON student_clinic_emr.billing_line  TO `Doctor`;
GRANT SELECT ON student_clinic_emr.icd10_ref TO `Doctor`, `Nurse`;
GRANT SELECT ON student_clinic_emr.rx_drug_ref TO `Doctor`, `Nurse`;
GRANT SELECT ON student_clinic_emr.loinc_ref TO `Doctor`, `Nurse`;
GRANT SELECT ON student_clinic_emr.cpt_ref TO `Doctor`, `Nurse`;

GRANT SELECT ON student_clinic_emr.v_support_patient_schedule TO `Hospital Support`;
GRANT SELECT ON student_clinic_emr.v_pharmacy_prescriptions   TO `Pharmacist`, `Pharmacy Manager`;
GRANT SELECT ON student_clinic_emr.supply TO `Pharmacist`, `Pharmacy Manager`;
GRANT SELECT ON student_clinic_emr.supply_movement TO `Pharmacist`, `Pharmacy Manager`;
GRANT INSERT ON student_clinic_emr.pharmacy_dispense          TO `Pharmacist`, `Pharmacy Manager`;
GRANT UPDATE ON student_clinic_emr.supply                     TO `Pharmacy Manager`;

GRANT SELECT ON student_clinic_emr.patient TO `Hospital Manager`;
GRANT SELECT ON student_clinic_emr.visit TO `Hospital Manager`;
GRANT SELECT ON student_clinic_emr.diagnosis TO `Hospital Manager`;
GRANT SELECT ON student_clinic_emr.observation TO `Hospital Manager`;
GRANT SELECT ON student_clinic_emr.prescription TO `Hospital Manager`;
GRANT SELECT ON student_clinic_emr.`order` TO `Hospital Manager`;
GRANT SELECT ON student_clinic_emr.result TO `Hospital Manager`;
GRANT SELECT ON student_clinic_emr.billing_line TO `Hospital Manager`;

GRANT CREATE USER, SYSTEM_VARIABLES_ADMIN, ROLE_ADMIN ON *.* TO `Hospital IT Admin`;

GRANT SELECT ON student_clinic_emr.v_my_visits        TO `Patient`;
GRANT SELECT ON student_clinic_emr.v_my_diagnoses     TO `Patient`;
GRANT SELECT ON student_clinic_emr.v_my_prescriptions TO `Patient`;
GRANT SELECT ON student_clinic_emr.v_my_results       TO `Patient`;
GRANT SELECT ON student_clinic_emr.v_my_billing       TO `Patient`;

-- =====================================
-- 7) Simple User Registration Structures
-- =====================================
CREATE TABLE IF NOT EXISTS user_auth (
  user_id INT PRIMARY KEY,
  email VARCHAR(150) NOT NULL UNIQUE,
  password_hash CHAR(64) NOT NULL,
  is_active BOOLEAN NOT NULL DEFAULT TRUE,
  created_at DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  updated_at DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  CONSTRAINT fk_userauth_user FOREIGN KEY (user_id)
    REFERENCES staff_user(user_id)
    ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS staff_user (
  user_id INT AUTO_INCREMENT PRIMARY KEY,
  username VARCHAR(100) NOT NULL UNIQUE,
  display_name VARCHAR(150) NULL,
  is_active BOOLEAN NOT NULL DEFAULT TRUE,
  created_at DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  updated_at DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3)
);

CREATE TABLE IF NOT EXISTS user_patient_link (
  user_id INT PRIMARY KEY,
  patient_id INT NOT NULL UNIQUE,
  CONSTRAINT fk_upl_user    FOREIGN KEY (user_id)    REFERENCES staff_user(user_id)
    ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_upl_patient FOREIGN KEY (patient_id) REFERENCES patient(patient_id)
    ON UPDATE CASCADE ON DELETE CASCADE
);

-- ==================================
-- 8) Seed 10 patients + 20 app users
-- ==================================
INSERT INTO patient (mrn, first_name, last_name, dob, sex, phone, email) VALUES
('S0005','Kim','Allen','2004-04-11','F','555-0201','kim.allen@example.edu'),
('S0006','Lee','Baker','2003-09-22','M','555-0202','lee.baker@example.edu'),
('S0007','Mia','Clark','2005-01-30','F','555-0203','mia.clark@example.edu'),
('S0008','Noah','Davis','2002-07-09','M','555-0204','noah.davis@example.edu'),
('S0009','Olivia','Evans','2003-03-17','F','555-0205','olivia.evans@example.edu'),
('S0010','Paul','Foster','2001-12-05','M','555-0206','paul.foster@example.edu'),
('S0011','Quinn','Garcia','2004-08-14','O','555-0207','quinn.garcia@example.edu'),
('S0012','Ria','Hughes','2003-10-28','F','555-0208','ria.hughes@example.edu'),
('S0013','Sam','Ibrahim','2002-06-19','M','555-0209','sam.ibrahim@example.edu'),
('S0014','Tom','Jones','2004-02-26','M','555-0210','tom.jones@example.edu')
ON DUPLICATE KEY UPDATE first_name=VALUES(first_name), last_name=VALUES(last_name);

INSERT INTO staff_user (username, display_name) VALUES
('doc_amy','Dr. Amy Carter'),
('doc_ben','Dr. Ben Ortiz'),
('nurse_cara','Nurse Cara Patel'),
('nurse_dan','Nurse Dan Moore'),
('support_ella','Support Ella Kim'),
('support_fred','Support Fred Zhou'),
('manager_gina','Manager Gina Ross'),
('itadmin_hank','IT Admin Hank Lee'),
('pharm_ivy','Pharmacist Ivy Rao'),
('pharm_mgr_jack','Pharmacy Manager Jack Wu'),
('patient_kim','Kim Allen (Portal)'),
('patient_lee','Lee Baker (Portal)'),
('patient_mia','Mia Clark (Portal)'),
('patient_noah','Noah Davis (Portal)'),
('patient_olivia','Olivia Evans (Portal)'),
('patient_paul','Paul Foster (Portal)'),
('patient_quinn','Quinn Garcia (Portal)'),
('patient_ria','Ria Hughes (Portal)'),
('patient_sam','Sam Ibrahim (Portal)'),
('patient_tom','Tom Jones (Portal)')
ON DUPLICATE KEY UPDATE display_name = VALUES(display_name);

INSERT IGNORE INTO user_auth (user_id, email, password_hash)
SELECT su.user_id, CONCAT(su.username,'@example.org') AS email, SHA2('Welcome!2025',256) AS password_hash
FROM staff_user su
WHERE su.username IN (
  'doc_amy','doc_ben','nurse_cara','nurse_dan',
  'support_ella','support_fred','manager_gina','itadmin_hank',
  'pharm_ivy','pharm_mgr_jack',
  'patient_kim','patient_lee','patient_mia','patient_noah','patient_olivia',
  'patient_paul','patient_quinn','patient_ria','patient_sam','patient_tom'
);

INSERT IGNORE INTO user_patient_link (user_id, patient_id)
SELECT su.user_id, p.patient_id
FROM staff_user su
JOIN patient p ON
  (su.username='patient_kim'   AND p.mrn='S0005') OR
  (su.username='patient_lee'   AND p.mrn='S0006') OR
  (su.username='patient_mia'   AND p.mrn='S0007') OR
  (su.username='patient_noah'  AND p.mrn='S0008') OR
  (su.username='patient_olivia'AND p.mrn='S0009') OR
  (su.username='patient_paul'  AND p.mrn='S0010') OR
  (su.username='patient_quinn' AND p.mrn='S0011') OR
  (su.username='patient_ria'   AND p.mrn='S0012') OR
  (su.username='patient_sam'   AND p.mrn='S0013') OR
  (su.username='patient_tom'   AND p.mrn='S0014');

-- Assign roles
INSERT IGNORE INTO user_role (user_id, role_id)
SELECT su.user_id, (SELECT role_id FROM role WHERE role_name='Doctor')
FROM staff_user su WHERE su.username IN ('doc_amy','doc_ben');

INSERT IGNORE INTO user_role (user_id, role_id)
SELECT su.user_id, (SELECT role_id FROM role WHERE role_name='Nurse')
FROM staff_user su WHERE su.username IN ('nurse_cara','nurse_dan');

INSERT IGNORE INTO user_role (user_id, role_id)
SELECT su.user_id, (SELECT role_id FROM role WHERE role_name='Hospital Support')
FROM staff_user su WHERE su.username IN ('support_ella','support_fred');

INSERT IGNORE INTO user_role (user_id, role_id)
SELECT su.user_id, (SELECT role_id FROM role WHERE role_name='Hospital Manager')
FROM staff_user su WHERE su.username='manager_gina';

INSERT IGNORE INTO user_role (user_id, role_id)
SELECT su.user_id, (SELECT role_id FROM role WHERE role_name='Hospital IT Admin')
FROM staff_user su WHERE su.username='itadmin_hank';

INSERT IGNORE INTO user_role (user_id, role_id)
SELECT su.user_id, (SELECT role_id FROM role WHERE role_name='Pharmacist')
FROM staff_user su WHERE su.username='pharm_ivy';

INSERT IGNORE INTO user_role (user_id, role_id)
SELECT su.user_id, (SELECT role_id FROM role WHERE role_name='Pharmacy Manager')
FROM staff_user su WHERE su.username='pharm_mgr_jack';

INSERT IGNORE INTO user_role (user_id, role_id)
SELECT su.user_id, (SELECT role_id FROM role WHERE role_name='Patient')
FROM staff_user su WHERE su.username IN (
  'patient_kim','patient_lee','patient_mia','patient_noah','patient_olivia',
  'patient_paul','patient_quinn','patient_ria','patient_sam','patient_tom'
);

-- Department assignments
INSERT IGNORE INTO staff_department (user_id, department_id)
SELECT su.user_id, d.department_id
FROM staff_user su
JOIN department d ON d.name='Front Desk'
WHERE su.username IN ('support_ella','support_fred');

INSERT IGNORE INTO staff_department (user_id, department_id)
SELECT su.user_id, d.department_id
FROM staff_user su
JOIN department d ON d.name='Management'
WHERE su.username='manager_gina';

INSERT IGNORE INTO staff_department (user_id, department_id)
SELECT su.user_id, d.department_id
FROM staff_user su
JOIN department d ON d.name='IT'
WHERE su.username='itadmin_hank';

INSERT IGNORE INTO staff_department (user_id, department_id)
SELECT su.user_id, d.department_id
FROM staff_user su
JOIN department d ON d.name='Pharmacy'
WHERE su.username IN ('pharm_ivy','pharm_mgr_jack');


USE student_clinic_emr;

-- Update patient table with additional address and emergency contact fields
-- Check and add columns only if they don't exist
SET @dbname = 'student_clinic_emr';
SET @tablename = 'patient';

-- Check for address_line1
SET @col_exists = (SELECT COUNT(*) FROM information_schema.COLUMNS 
    WHERE TABLE_SCHEMA = @dbname AND TABLE_NAME = @tablename AND COLUMN_NAME = 'address_line1');
SET @sql = IF(@col_exists = 0, 
    'ALTER TABLE patient ADD COLUMN address_line1 VARCHAR(100) NULL AFTER email;', 
    'SELECT "Column address_line1 already exists" AS Info;');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Check for address_line2
SET @col_exists = (SELECT COUNT(*) FROM information_schema.COLUMNS 
    WHERE TABLE_SCHEMA = @dbname AND TABLE_NAME = @tablename AND COLUMN_NAME = 'address_line2');
SET @sql = IF(@col_exists = 0, 
    'ALTER TABLE patient ADD COLUMN address_line2 VARCHAR(100) NULL AFTER address_line1;', 
    'SELECT "Column address_line2 already exists" AS Info;');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Check for city
SET @col_exists = (SELECT COUNT(*) FROM information_schema.COLUMNS 
    WHERE TABLE_SCHEMA = @dbname AND TABLE_NAME = @tablename AND COLUMN_NAME = 'city');
SET @sql = IF(@col_exists = 0, 
    'ALTER TABLE patient ADD COLUMN city VARCHAR(50) NULL AFTER address_line2;', 
    'SELECT "Column city already exists" AS Info;');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Check for state
SET @col_exists = (SELECT COUNT(*) FROM information_schema.COLUMNS 
    WHERE TABLE_SCHEMA = @dbname AND TABLE_NAME = @tablename AND COLUMN_NAME = 'state');
SET @sql = IF(@col_exists = 0, 
    'ALTER TABLE patient ADD COLUMN state VARCHAR(20) NULL AFTER city;', 
    'SELECT "Column state already exists" AS Info;');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Check for zip
SET @col_exists = (SELECT COUNT(*) FROM information_schema.COLUMNS 
    WHERE TABLE_SCHEMA = @dbname AND TABLE_NAME = @tablename AND COLUMN_NAME = 'zip');
SET @sql = IF(@col_exists = 0, 
    'ALTER TABLE patient ADD COLUMN zip VARCHAR(10) NULL AFTER state;', 
    'SELECT "Column zip already exists" AS Info;');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Check for emergency_contact_name
SET @col_exists = (SELECT COUNT(*) FROM information_schema.COLUMNS 
    WHERE TABLE_SCHEMA = @dbname AND TABLE_NAME = @tablename AND COLUMN_NAME = 'emergency_contact_name');
SET @sql = IF(@col_exists = 0, 
    'ALTER TABLE patient ADD COLUMN emergency_contact_name VARCHAR(100) NULL AFTER zip;', 
    'SELECT "Column emergency_contact_name already exists" AS Info;');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Check for emergency_contact_phone
SET @col_exists = (SELECT COUNT(*) FROM information_schema.COLUMNS 
    WHERE TABLE_SCHEMA = @dbname AND TABLE_NAME = @tablename AND COLUMN_NAME = 'emergency_contact_phone');
SET @sql = IF(@col_exists = 0, 
    'ALTER TABLE patient ADD COLUMN emergency_contact_phone VARCHAR(20) NULL AFTER emergency_contact_name;', 
    'SELECT "Column emergency_contact_phone already exists" AS Info;');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Add chief_complaint column to visit table (if it doesn't already exist)
SET @tablename = 'visit';
SET @col_exists = (SELECT COUNT(*) FROM information_schema.COLUMNS 
    WHERE TABLE_SCHEMA = @dbname AND TABLE_NAME = @tablename AND COLUMN_NAME = 'chief_complaint');
SET @sql = IF(@col_exists = 0, 
    'ALTER TABLE visit ADD COLUMN chief_complaint VARCHAR(500) NULL AFTER status;', 
    'SELECT "Column chief_complaint already exists" AS Info;');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

/* ========================= HOW TO USE (examples) =========================
-- STAFF session (Support/Nurse/Doctor):
--   SET @app_user_id = (SELECT user_id FROM staff_user WHERE username='support_ella');
--   SELECT * FROM v_support_patient_schedule;

-- PATIENT portal session:
--   SET @portal_patient_id = (SELECT patient_id FROM patient WHERE mrn='S0005');
--   SELECT * FROM v_my_visits;
--   SELECT * FROM v_my_prescriptions;
--   SELECT * FROM v_my_results;
--   SELECT * FROM v_my_billing;
======================================================================== */
