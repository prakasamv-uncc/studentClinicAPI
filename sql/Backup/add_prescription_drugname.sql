USE student_clinic_emr;
SET @exists = (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE table_schema='student_clinic_emr' AND table_name='prescription' AND column_name='drug_name');
SET @sql = IF(@exists=0,'ALTER TABLE prescription ADD COLUMN drug_name VARCHAR(200) NULL AFTER drug_code;','SELECT "prescription.drug_name exists";');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
