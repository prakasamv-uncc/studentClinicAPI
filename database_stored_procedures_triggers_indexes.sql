/* =====================================================================
   Student Clinic EMR - Stored Procedures, Triggers, Views, and Indexes
   MySQL 8+
   ---------------------------------------------------------------------
   Run AFTER loading the base schema and RBAC schema.
   This script adds:
     1) Stored procedures for CRUD operations
     2) Triggers for audit trail
     3) Additional indexes for performance
     4) Views for reporting
   ===================================================================== */

USE student_clinic_emr;

-- =============================================
-- 1) STORED PROCEDURES FOR PATIENT OPERATIONS
-- =============================================

DELIMITER $$

-- Get all patients
DROP PROCEDURE IF EXISTS sp_get_all_patients$$
CREATE PROCEDURE sp_get_all_patients()
BEGIN
    SELECT 
        patient_id AS PatientId,
        mrn AS Mrn,
        first_name AS FirstName,
        last_name AS LastName,
        dob AS Dob,
        sex AS Sex,
        phone AS Phone,
        email AS Email,
        address_line1 AS AddressLine1,
        address_line2 AS AddressLine2,
        city AS City,
        state AS State,
        zip AS Zip,
        emergency_contact_name AS EmergencyContactName,
        emergency_contact_phone AS EmergencyContactPhone
    FROM patient
    ORDER BY last_name, first_name;
END$$

-- Get patient by ID
DROP PROCEDURE IF EXISTS sp_get_patient_by_id$$
CREATE PROCEDURE sp_get_patient_by_id(IN p_patient_id INT)
BEGIN
    SELECT 
        patient_id AS PatientId,
        mrn AS Mrn,
        first_name AS FirstName,
        last_name AS LastName,
        dob AS Dob,
        sex AS Sex,
        phone AS Phone,
        email AS Email,
        address_line1 AS AddressLine1,
        address_line2 AS AddressLine2,
        city AS City,
        state AS State,
        zip AS Zip,
        emergency_contact_name AS EmergencyContactName,
        emergency_contact_phone AS EmergencyContactPhone
    FROM patient
    WHERE patient_id = p_patient_id;
END$$

-- Get patient by MRN
DROP PROCEDURE IF EXISTS sp_get_patient_by_mrn$$
CREATE PROCEDURE sp_get_patient_by_mrn(IN p_mrn VARCHAR(20))
BEGIN
    SELECT 
        patient_id AS PatientId,
        mrn AS Mrn,
        first_name AS FirstName,
        last_name AS LastName,
        dob AS Dob,
        sex AS Sex,
        phone AS Phone,
        email AS Email,
        address_line1 AS AddressLine1,
        address_line2 AS AddressLine2,
        city AS City,
        state AS State,
        zip AS Zip,
        emergency_contact_name AS EmergencyContactName,
        emergency_contact_phone AS EmergencyContactPhone
    FROM patient
    WHERE mrn = p_mrn;
END$$

-- Create patient
DROP PROCEDURE IF EXISTS sp_create_patient$$
CREATE PROCEDURE sp_create_patient(
    IN p_mrn VARCHAR(20),
    IN p_first_name VARCHAR(60),
    IN p_last_name VARCHAR(60),
    IN p_dob DATE,
    IN p_sex CHAR(1),
    IN p_phone VARCHAR(20),
    IN p_email VARCHAR(150),
    IN p_address_line1 VARCHAR(100),
    IN p_address_line2 VARCHAR(100),
    IN p_city VARCHAR(50),
    IN p_state VARCHAR(20),
    IN p_zip VARCHAR(10),
    IN p_emergency_contact_name VARCHAR(100),
    IN p_emergency_contact_phone VARCHAR(20)
)
BEGIN
    INSERT INTO patient (
        mrn, first_name, last_name, dob, sex, phone, email,
        address_line1, address_line2, city, state, zip,
        emergency_contact_name, emergency_contact_phone,
        created_at, updated_at
    ) VALUES (
        p_mrn, p_first_name, p_last_name, p_dob, p_sex, p_phone, p_email,
        p_address_line1, p_address_line2, p_city, p_state, p_zip,
        p_emergency_contact_name, p_emergency_contact_phone,
        NOW(), NOW()
    );
    
    SELECT LAST_INSERT_ID() AS PatientId;
END$$

-- Update patient
DROP PROCEDURE IF EXISTS sp_update_patient$$
CREATE PROCEDURE sp_update_patient(
    IN p_patient_id INT,
    IN p_first_name VARCHAR(60),
    IN p_last_name VARCHAR(60),
    IN p_dob DATE,
    IN p_sex CHAR(1),
    IN p_phone VARCHAR(20),
    IN p_email VARCHAR(150),
    IN p_address_line1 VARCHAR(100),
    IN p_address_line2 VARCHAR(100),
    IN p_city VARCHAR(50),
    IN p_state VARCHAR(20),
    IN p_zip VARCHAR(10),
    IN p_emergency_contact_name VARCHAR(100),
    IN p_emergency_contact_phone VARCHAR(20)
)
BEGIN
    UPDATE patient
    SET
        first_name = p_first_name,
        last_name = p_last_name,
        dob = p_dob,
        sex = p_sex,
        phone = p_phone,
        email = p_email,
        address_line1 = p_address_line1,
        address_line2 = p_address_line2,
        city = p_city,
        state = p_state,
        zip = p_zip,
        emergency_contact_name = p_emergency_contact_name,
        emergency_contact_phone = p_emergency_contact_phone,
        updated_at = NOW()
    WHERE patient_id = p_patient_id;
END$$

-- Delete patient
DROP PROCEDURE IF EXISTS sp_delete_patient$$
CREATE PROCEDURE sp_delete_patient(IN p_patient_id INT)
BEGIN
    DELETE FROM patient WHERE patient_id = p_patient_id;
END$$

-- Search patients
DROP PROCEDURE IF EXISTS sp_search_patients$$
CREATE PROCEDURE sp_search_patients(IN p_search_term VARCHAR(100))
BEGIN
    SELECT 
        patient_id AS PatientId,
        mrn AS Mrn,
        first_name AS FirstName,
        last_name AS LastName,
        dob AS Dob,
        sex AS Sex,
        phone AS Phone,
        email AS Email
    FROM patient
    WHERE 
        mrn LIKE p_search_term OR
        first_name LIKE p_search_term OR
        last_name LIKE p_search_term OR
        email LIKE p_search_term OR
        phone LIKE p_search_term
    ORDER BY last_name, first_name
    LIMIT 100;
END$$

-- =============================================
-- 2) STORED PROCEDURES FOR VISIT OPERATIONS
-- =============================================

-- Get all visits
DROP PROCEDURE IF EXISTS sp_get_all_visits$$
CREATE PROCEDURE sp_get_all_visits()
BEGIN
    SELECT 
        v.visit_id AS VisitId,
        v.patient_id AS PatientId,
        v.provider_id AS ProviderId,
        v.appointment_id AS AppointmentId,
        v.check_in_time AS CheckInTime,
        v.check_out_time AS CheckOutTime,
        v.status AS Status,
        v.chief_complaint AS ChiefComplaint,
        CONCAT(p.first_name, ' ', p.last_name) AS PatientName,
        CONCAT(pr.first_name, ' ', pr.last_name) AS ProviderName
    FROM visit v
    JOIN patient p ON v.patient_id = p.patient_id
    LEFT JOIN provider pr ON v.provider_id = pr.provider_id
    ORDER BY v.check_in_time DESC;
END$$

-- Get visit by ID
DROP PROCEDURE IF EXISTS sp_get_visit_by_id$$
CREATE PROCEDURE sp_get_visit_by_id(IN p_visit_id INT)
BEGIN
    SELECT 
        v.visit_id AS VisitId,
        v.patient_id AS PatientId,
        v.provider_id AS ProviderId,
        v.appointment_id AS AppointmentId,
        v.check_in_time AS CheckInTime,
        v.check_out_time AS CheckOutTime,
        v.status AS Status,
        v.chief_complaint AS ChiefComplaint,
        CONCAT(p.first_name, ' ', p.last_name) AS PatientName,
        CONCAT(pr.first_name, ' ', pr.last_name) AS ProviderName
    FROM visit v
    JOIN patient p ON v.patient_id = p.patient_id
    LEFT JOIN provider pr ON v.provider_id = pr.provider_id
    WHERE v.visit_id = p_visit_id;
END$$

-- Get visits by patient
DROP PROCEDURE IF EXISTS sp_get_visits_by_patient$$
CREATE PROCEDURE sp_get_visits_by_patient(IN p_patient_id INT)
BEGIN
    SELECT 
        v.visit_id AS VisitId,
        v.patient_id AS PatientId,
        v.provider_id AS ProviderId,
        v.appointment_id AS AppointmentId,
        v.check_in_time AS CheckInTime,
        v.check_out_time AS CheckOutTime,
        v.status AS Status,
        v.chief_complaint AS ChiefComplaint,
        CONCAT(pr.first_name, ' ', pr.last_name) AS ProviderName
    FROM visit v
    LEFT JOIN provider pr ON v.provider_id = pr.provider_id
    WHERE v.patient_id = p_patient_id
    ORDER BY v.check_in_time DESC;
END$$

-- Create visit
DROP PROCEDURE IF EXISTS sp_create_visit$$
CREATE PROCEDURE sp_create_visit(
    IN p_patient_id INT,
    IN p_provider_id INT,
    IN p_appointment_id INT,
    IN p_check_in_time DATETIME,
    IN p_check_out_time DATETIME,
    IN p_status VARCHAR(20),
    IN p_chief_complaint VARCHAR(500)
)
BEGIN
    INSERT INTO visit (
        patient_id, provider_id, appointment_id, check_in_time, 
        check_out_time, status, chief_complaint, created_at, updated_at
    ) VALUES (
        p_patient_id, p_provider_id, p_appointment_id, p_check_in_time,
        p_check_out_time, p_status, p_chief_complaint, NOW(), NOW()
    );
    
    SELECT LAST_INSERT_ID() AS VisitId;
END$$

-- Update visit
DROP PROCEDURE IF EXISTS sp_update_visit$$
CREATE PROCEDURE sp_update_visit(
    IN p_visit_id INT,
    IN p_check_in_time DATETIME,
    IN p_check_out_time DATETIME,
    IN p_status VARCHAR(20),
    IN p_chief_complaint VARCHAR(500)
)
BEGIN
    UPDATE visit
    SET
        check_in_time = p_check_in_time,
        check_out_time = p_check_out_time,
        status = p_status,
        chief_complaint = p_chief_complaint,
        updated_at = NOW()
    WHERE visit_id = p_visit_id;
END$$

-- Delete visit
DROP PROCEDURE IF EXISTS sp_delete_visit$$
CREATE PROCEDURE sp_delete_visit(IN p_visit_id INT)
BEGIN
    DELETE FROM visit WHERE visit_id = p_visit_id;
END$$

-- =============================================
-- 3) STORED PROCEDURES FOR PRESCRIPTION OPERATIONS
-- =============================================

-- Get all prescriptions
DROP PROCEDURE IF EXISTS sp_get_all_prescriptions$$
CREATE PROCEDURE sp_get_all_prescriptions()
BEGIN
    SELECT 
        rx.prescription_id AS PrescriptionId,
        rx.visit_id AS VisitId,
        rx.drug_code AS DrugCode,
        rx.drug_name AS DrugName,
        rx.dose AS Dose,
        rx.dose_unit AS DoseUnit,
        rx.route AS Route,
        rx.frequency AS Frequency,
        rx.duration_days AS DurationDays,
        rx.quantity AS Quantity,
        rx.refills AS Refills,
        rx.start_date AS StartDate,
        rx.end_date AS EndDate,
        rx.status AS Status,
        CONCAT(p.first_name, ' ', p.last_name) AS PatientName
    FROM prescription rx
    JOIN visit v ON rx.visit_id = v.visit_id
    JOIN patient p ON v.patient_id = p.patient_id
    ORDER BY rx.created_at DESC;
END$$

-- Get prescription by ID
DROP PROCEDURE IF EXISTS sp_get_prescription_by_id$$
CREATE PROCEDURE sp_get_prescription_by_id(IN p_prescription_id INT)
BEGIN
    SELECT 
        rx.prescription_id AS PrescriptionId,
        rx.visit_id AS VisitId,
        rx.drug_code AS DrugCode,
        rx.drug_name AS DrugName,
        rx.dose AS Dose,
        rx.dose_unit AS DoseUnit,
        rx.route AS Route,
        rx.frequency AS Frequency,
        rx.duration_days AS DurationDays,
        rx.quantity AS Quantity,
        rx.refills AS Refills,
        rx.start_date AS StartDate,
        rx.end_date AS EndDate,
        rx.status AS Status,
        CONCAT(p.first_name, ' ', p.last_name) AS PatientName
    FROM prescription rx
    JOIN visit v ON rx.visit_id = v.visit_id
    JOIN patient p ON v.patient_id = p.patient_id
    WHERE rx.prescription_id = p_prescription_id;
END$$

-- Get prescriptions by visit
DROP PROCEDURE IF EXISTS sp_get_prescriptions_by_visit$$
CREATE PROCEDURE sp_get_prescriptions_by_visit(IN p_visit_id INT)
BEGIN
    SELECT 
        rx.prescription_id AS PrescriptionId,
        rx.visit_id AS VisitId,
        rx.drug_code AS DrugCode,
        rx.drug_name AS DrugName,
        rx.dose AS Dose,
        rx.dose_unit AS DoseUnit,
        rx.route AS Route,
        rx.frequency AS Frequency,
        rx.duration_days AS DurationDays,
        rx.quantity AS Quantity,
        rx.refills AS Refills,
        rx.start_date AS StartDate,
        rx.end_date AS EndDate,
        rx.status AS Status
    FROM prescription rx
    WHERE rx.visit_id = p_visit_id
    ORDER BY rx.created_at DESC;
END$$

-- Get prescriptions by patient
DROP PROCEDURE IF EXISTS sp_get_prescriptions_by_patient$$
CREATE PROCEDURE sp_get_prescriptions_by_patient(IN p_patient_id INT)
BEGIN
    SELECT 
        rx.prescription_id AS PrescriptionId,
        rx.visit_id AS VisitId,
        rx.drug_code AS DrugCode,
        rx.drug_name AS DrugName,
        rx.dose AS Dose,
        rx.dose_unit AS DoseUnit,
        rx.route AS Route,
        rx.frequency AS Frequency,
        rx.duration_days AS DurationDays,
        rx.quantity AS Quantity,
        rx.refills AS Refills,
        rx.start_date AS StartDate,
        rx.end_date AS EndDate,
        rx.status AS Status
    FROM prescription rx
    JOIN visit v ON rx.visit_id = v.visit_id
    WHERE v.patient_id = p_patient_id
    ORDER BY rx.created_at DESC;
END$$

-- Create prescription
DROP PROCEDURE IF EXISTS sp_create_prescription$$
CREATE PROCEDURE sp_create_prescription(
    IN p_visit_id INT,
    IN p_drug_code VARCHAR(20),
    IN p_drug_name VARCHAR(200),
    IN p_dose VARCHAR(50),
    IN p_dose_unit VARCHAR(20),
    IN p_route VARCHAR(50),
    IN p_frequency VARCHAR(100),
    IN p_duration_days INT,
    IN p_quantity DECIMAL(10,2),
    IN p_refills INT,
    IN p_start_date DATE,
    IN p_end_date DATE,
    IN p_status VARCHAR(20)
)
BEGIN
    INSERT INTO prescription (
        visit_id, drug_code, drug_name, dose, dose_unit, route, frequency,
        duration_days, quantity, refills, start_date, end_date, status,
        created_at, updated_at
    ) VALUES (
        p_visit_id, p_drug_code, p_drug_name, p_dose, p_dose_unit, p_route, 
        p_frequency, p_duration_days, p_quantity, p_refills, p_start_date, 
        p_end_date, p_status, NOW(), NOW()
    );
    
    SELECT LAST_INSERT_ID() AS PrescriptionId;
END$$

-- Update prescription
DROP PROCEDURE IF EXISTS sp_update_prescription$$
CREATE PROCEDURE sp_update_prescription(
    IN p_prescription_id INT,
    IN p_dose VARCHAR(50),
    IN p_dose_unit VARCHAR(20),
    IN p_route VARCHAR(50),
    IN p_frequency VARCHAR(100),
    IN p_duration_days INT,
    IN p_quantity DECIMAL(10,2),
    IN p_refills INT,
    IN p_start_date DATE,
    IN p_end_date DATE,
    IN p_status VARCHAR(20)
)
BEGIN
    UPDATE prescription
    SET
        dose = p_dose,
        dose_unit = p_dose_unit,
        route = p_route,
        frequency = p_frequency,
        duration_days = p_duration_days,
        quantity = p_quantity,
        refills = p_refills,
        start_date = p_start_date,
        end_date = p_end_date,
        status = p_status,
        updated_at = NOW()
    WHERE prescription_id = p_prescription_id;
END$$

-- Delete prescription
DROP PROCEDURE IF EXISTS sp_delete_prescription$$
CREATE PROCEDURE sp_delete_prescription(IN p_prescription_id INT)
BEGIN
    DELETE FROM prescription WHERE prescription_id = p_prescription_id;
END$$

-- Dispense prescription
DROP PROCEDURE IF EXISTS sp_dispense_prescription$$
CREATE PROCEDURE sp_dispense_prescription(
    IN p_prescription_id INT,
    IN p_user_id INT,
    IN p_dispensed_qty DECIMAL(10,2),
    IN p_notes VARCHAR(200)
)
BEGIN
    INSERT INTO pharmacy_dispense (
        prescription_id, dispensed_by_user_id, dispensed_qty, notes, dispensed_at
    ) VALUES (
        p_prescription_id, p_user_id, p_dispensed_qty, p_notes, NOW()
    );
    
    -- Update prescription status
    UPDATE prescription
    SET status = 'Dispensed', updated_at = NOW()
    WHERE prescription_id = p_prescription_id;
END$$

DELIMITER ;

-- =============================================
-- 4) TRIGGERS FOR AUDIT TRAIL
-- =============================================

-- Create audit_log table if not exists
CREATE TABLE IF NOT EXISTS audit_log (
    audit_id INT AUTO_INCREMENT PRIMARY KEY,
    table_name VARCHAR(50) NOT NULL,
    record_id INT NOT NULL,
    action VARCHAR(20) NOT NULL,
    user_id INT,
    username VARCHAR(100),
    old_values TEXT,
    new_values TEXT,
    ip_address VARCHAR(45),
    user_agent VARCHAR(500),
    created_at DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    INDEX idx_table_name (table_name),
    INDEX idx_user_id (user_id),
    INDEX idx_created_at (created_at)
);

DELIMITER $$

-- Patient audit triggers
DROP TRIGGER IF EXISTS trg_patient_after_insert$$
CREATE TRIGGER trg_patient_after_insert
AFTER INSERT ON patient
FOR EACH ROW
BEGIN
    INSERT INTO audit_log (table_name, record_id, action, user_id, new_values, created_at)
    VALUES ('patient', NEW.patient_id, 'INSERT', @app_user_id, 
            JSON_OBJECT('mrn', NEW.mrn, 'first_name', NEW.first_name, 'last_name', NEW.last_name),
            NOW());
END$$

DROP TRIGGER IF EXISTS trg_patient_after_update$$
CREATE TRIGGER trg_patient_after_update
AFTER UPDATE ON patient
FOR EACH ROW
BEGIN
    INSERT INTO audit_log (table_name, record_id, action, user_id, old_values, new_values, created_at)
    VALUES ('patient', NEW.patient_id, 'UPDATE', @app_user_id,
            JSON_OBJECT('first_name', OLD.first_name, 'last_name', OLD.last_name, 'phone', OLD.phone),
            JSON_OBJECT('first_name', NEW.first_name, 'last_name', NEW.last_name, 'phone', NEW.phone),
            NOW());
END$$

DROP TRIGGER IF EXISTS trg_patient_after_delete$$
CREATE TRIGGER trg_patient_after_delete
AFTER DELETE ON patient
FOR EACH ROW
BEGIN
    INSERT INTO audit_log (table_name, record_id, action, user_id, old_values, created_at)
    VALUES ('patient', OLD.patient_id, 'DELETE', @app_user_id,
            JSON_OBJECT('mrn', OLD.mrn, 'first_name', OLD.first_name, 'last_name', OLD.last_name),
            NOW());
END$$

-- Visit audit triggers
DROP TRIGGER IF EXISTS trg_visit_after_insert$$
CREATE TRIGGER trg_visit_after_insert
AFTER INSERT ON visit
FOR EACH ROW
BEGIN
    INSERT INTO audit_log (table_name, record_id, action, user_id, new_values, created_at)
    VALUES ('visit', NEW.visit_id, 'INSERT', @app_user_id,
            JSON_OBJECT('patient_id', NEW.patient_id, 'provider_id', NEW.provider_id, 'status', NEW.status),
            NOW());
END$$

DROP TRIGGER IF EXISTS trg_visit_after_update$$
CREATE TRIGGER trg_visit_after_update
AFTER UPDATE ON visit
FOR EACH ROW
BEGIN
    INSERT INTO audit_log (table_name, record_id, action, user_id, old_values, new_values, created_at)
    VALUES ('visit', NEW.visit_id, 'UPDATE', @app_user_id,
            JSON_OBJECT('status', OLD.status, 'check_out_time', OLD.check_out_time),
            JSON_OBJECT('status', NEW.status, 'check_out_time', NEW.check_out_time),
            NOW());
END$$

-- Prescription audit triggers
DROP TRIGGER IF EXISTS trg_prescription_after_insert$$
CREATE TRIGGER trg_prescription_after_insert
AFTER INSERT ON prescription
FOR EACH ROW
BEGIN
    INSERT INTO audit_log (table_name, record_id, action, user_id, new_values, created_at)
    VALUES ('prescription', NEW.prescription_id, 'INSERT', @app_user_id,
            JSON_OBJECT('visit_id', NEW.visit_id, 'drug_code', NEW.drug_code, 'status', NEW.status),
            NOW());
END$$

DROP TRIGGER IF EXISTS trg_prescription_after_update$$
CREATE TRIGGER trg_prescription_after_update
AFTER UPDATE ON prescription
FOR EACH ROW
BEGIN
    INSERT INTO audit_log (table_name, record_id, action, user_id, old_values, new_values, created_at)
    VALUES ('prescription', NEW.prescription_id, 'UPDATE', @app_user_id,
            JSON_OBJECT('status', OLD.status, 'quantity', OLD.quantity),
            JSON_OBJECT('status', NEW.status, 'quantity', NEW.quantity),
            NOW());
END$$

DELIMITER ;

-- =============================================
-- 5) PERFORMANCE INDEXES
-- =============================================

-- Patient indexes
CREATE INDEX idx_patient_name ON patient(last_name, first_name);
CREATE INDEX idx_patient_dob ON patient(dob);
CREATE INDEX idx_patient_email ON patient(email);
CREATE INDEX idx_patient_created ON patient(created_at);

-- Visit indexes
CREATE INDEX idx_visit_status ON visit(status);
CREATE INDEX idx_visit_check_in ON visit(check_in_time);
CREATE INDEX idx_visit_provider ON visit(provider_id);

-- Prescription indexes
CREATE INDEX idx_prescription_drug ON prescription(drug_code);
CREATE INDEX idx_prescription_status_date ON prescription(status, start_date);
CREATE INDEX idx_prescription_created ON prescription(created_at);

-- Pharmacy dispense indexes
CREATE INDEX idx_dispense_date ON pharmacy_dispense(dispensed_at);
CREATE INDEX idx_dispense_user ON pharmacy_dispense(dispensed_by_user_id);

-- User role indexes
CREATE INDEX idx_user_role_user ON user_role(user_id);
CREATE INDEX idx_user_role_role ON user_role(role_id);

-- =============================================
-- 6) REPORTING VIEWS
-- =============================================

-- Patient visit summary
CREATE OR REPLACE VIEW v_patient_visit_summary AS
SELECT 
    p.patient_id,
    p.mrn,
    CONCAT(p.first_name, ' ', p.last_name) AS patient_name,
    COUNT(v.visit_id) AS total_visits,
    MAX(v.check_in_time) AS last_visit_date,
    MIN(v.check_in_time) AS first_visit_date
FROM patient p
LEFT JOIN visit v ON p.patient_id = v.patient_id
GROUP BY p.patient_id, p.mrn, p.first_name, p.last_name;

-- Active prescriptions view
CREATE OR REPLACE VIEW v_active_prescriptions AS
SELECT 
    rx.prescription_id,
    rx.drug_code,
    rx.drug_name,
    CONCAT(p.first_name, ' ', p.last_name) AS patient_name,
    p.mrn,
    rx.start_date,
    rx.end_date,
    rx.quantity,
    rx.refills,
    rx.status
FROM prescription rx
JOIN visit v ON rx.visit_id = v.visit_id
JOIN patient p ON v.patient_id = p.patient_id
WHERE rx.status = 'Active' 
  AND (rx.end_date IS NULL OR rx.end_date >= CURDATE());

-- Staff activity summary
CREATE OR REPLACE VIEW v_staff_activity_summary AS
SELECT 
    su.user_id,
    su.username,
    su.display_name,
    COUNT(DISTINCT al.audit_id) AS total_actions,
    MAX(al.created_at) AS last_activity_date,
    GROUP_CONCAT(DISTINCT r.role_name) AS roles
FROM staff_user su
LEFT JOIN audit_log al ON su.user_id = al.user_id
LEFT JOIN user_role ur ON su.user_id = ur.user_id
LEFT JOIN role r ON ur.role_id = r.role_id
GROUP BY su.user_id, su.username, su.display_name;

-- =============================================
-- SCRIPT COMPLETE
-- =============================================

SELECT 'Stored procedures, triggers, indexes, and views created successfully!' AS Status;
