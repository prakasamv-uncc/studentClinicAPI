USE student_clinic_emr;

-- Add is_active to staff_user if missing
SET @exists = (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE table_schema='student_clinic_emr' AND table_name='staff_user' AND column_name='is_active');
SET @sql = IF(@exists=0,'ALTER TABLE staff_user ADD COLUMN is_active TINYINT(1) NOT NULL DEFAULT 1 AFTER display_name;','SELECT "staff_user.is_active exists";');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- Add patient address/contact columns if missing (one-by-one)
SET @exists = (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE table_schema='student_clinic_emr' AND table_name='patient' AND column_name='address_line1');
SET @sql = IF(@exists=0,'ALTER TABLE patient ADD COLUMN address_line1 VARCHAR(100) NULL AFTER email;','SELECT "patient.address_line1 exists";');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE table_schema='student_clinic_emr' AND table_name='patient' AND column_name='address_line2');
SET @sql = IF(@exists=0,'ALTER TABLE patient ADD COLUMN address_line2 VARCHAR(100) NULL AFTER address_line1;','SELECT "patient.address_line2 exists";');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE table_schema='student_clinic_emr' AND table_name='patient' AND column_name='city');
SET @sql = IF(@exists=0,'ALTER TABLE patient ADD COLUMN city VARCHAR(50) NULL AFTER address_line2;','SELECT "patient.city exists";');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE table_schema='student_clinic_emr' AND table_name='patient' AND column_name='state');
SET @sql = IF(@exists=0,'ALTER TABLE patient ADD COLUMN state VARCHAR(20) NULL AFTER city;','SELECT "patient.state exists";');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE table_schema='student_clinic_emr' AND table_name='patient' AND column_name='zip');
SET @sql = IF(@exists=0,'ALTER TABLE patient ADD COLUMN zip VARCHAR(10) NULL AFTER state;','SELECT "patient.zip exists";');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE table_schema='student_clinic_emr' AND table_name='patient' AND column_name='emergency_contact_name');
SET @sql = IF(@exists=0,'ALTER TABLE patient ADD COLUMN emergency_contact_name VARCHAR(100) NULL AFTER zip;','SELECT "patient.emergency_contact_name exists";');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE table_schema='student_clinic_emr' AND table_name='patient' AND column_name='emergency_contact_phone');
SET @sql = IF(@exists=0,'ALTER TABLE patient ADD COLUMN emergency_contact_phone VARCHAR(20) NULL AFTER emergency_contact_name;','SELECT "patient.emergency_contact_phone exists";');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
