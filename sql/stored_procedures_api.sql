-- Stored procedures for API access
USE student_clinic_emr;

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_get_patient_by_id$$
CREATE PROCEDURE sp_get_patient_by_id(IN p_patient_id INT)
BEGIN
  SELECT patient_id, mrn, first_name, last_name, dob, sex, phone, email,
         address_line1, address_line2, city, state, zip,
         emergency_contact_name, emergency_contact_phone, created_at, updated_at
  FROM patient
  WHERE patient_id = p_patient_id;
END$$

DROP PROCEDURE IF EXISTS sp_create_patient$$
CREATE PROCEDURE sp_create_patient(
  IN p_mrn VARCHAR(20), IN p_first_name VARCHAR(60), IN p_last_name VARCHAR(60),
  IN p_dob DATE, IN p_sex VARCHAR(1), IN p_phone VARCHAR(20), IN p_email VARCHAR(150),
  IN p_address_line1 VARCHAR(100), IN p_address_line2 VARCHAR(100), IN p_city VARCHAR(50),
  IN p_state VARCHAR(20), IN p_zip VARCHAR(10), IN p_emergency_contact_name VARCHAR(100),
  IN p_emergency_contact_phone VARCHAR(20), OUT p_new_id INT)
BEGIN
  INSERT INTO patient (mrn, first_name, last_name, dob, sex, phone, email,
    address_line1, address_line2, city, state, zip, emergency_contact_name, emergency_contact_phone, created_at, updated_at)
  VALUES (p_mrn, p_first_name, p_last_name, p_dob, p_sex, p_phone, p_email,
    p_address_line1, p_address_line2, p_city, p_state, p_zip, p_emergency_contact_name, p_emergency_contact_phone, NOW(), NOW());

  SET p_new_id = LAST_INSERT_ID();

  -- Insert audit log entry
  INSERT INTO audit_log (table_name, record_id, action, user_id, username, old_values, new_values, ip_address, user_agent, created_at)
  VALUES ('patient', p_new_id, 'INSERT', NULL, 'stored_proc', NULL, CONCAT('{"patient_id":', p_new_id, '}'), NULL, 'stored_proc', NOW());
END$$

DROP PROCEDURE IF EXISTS sp_update_patient$$
CREATE PROCEDURE sp_update_patient(
  IN p_patient_id INT, IN p_first_name VARCHAR(60), IN p_last_name VARCHAR(60),
  IN p_phone VARCHAR(20), IN p_email VARCHAR(150))
BEGIN
  DECLARE v_old JSON;
  DECLARE v_new JSON;

  SELECT JSON_OBJECT('patient_id', patient_id, 'first_name', first_name, 'last_name', last_name, 'phone', phone, 'email', email)
    INTO v_old
  FROM patient WHERE patient_id = p_patient_id;

  UPDATE patient SET first_name = p_first_name, last_name = p_last_name, phone = p_phone, email = p_email, updated_at = NOW()
    WHERE patient_id = p_patient_id;

  SELECT JSON_OBJECT('patient_id', patient_id, 'first_name', first_name, 'last_name', last_name, 'phone', phone, 'email', email)
    INTO v_new
  FROM patient WHERE patient_id = p_patient_id;

  INSERT INTO audit_log (table_name, record_id, action, user_id, username, old_values, new_values, ip_address, user_agent, created_at)
  VALUES ('patient', p_patient_id, 'UPDATE', NULL, 'stored_proc', CAST(v_old AS CHAR), CAST(v_new AS CHAR), NULL, 'stored_proc', NOW());
END$$

DROP PROCEDURE IF EXISTS sp_delete_prescription$$
CREATE PROCEDURE sp_delete_prescription(IN p_prescription_id INT, IN p_requesting_user_id INT)
BEGIN
  DECLARE v_old JSON;

  SELECT JSON_OBJECT('prescription_id', prescription_id, 'visit_id', visit_id, 'drug_code', drug_code, 'status', status)
    INTO v_old
  FROM prescription WHERE prescription_id = p_prescription_id;

  -- Insert audit log before delete
  INSERT INTO audit_log (table_name, record_id, action, user_id, username, old_values, new_values, ip_address, user_agent, created_at)
  VALUES ('prescription', p_prescription_id, 'DELETE', p_requesting_user_id, (SELECT username FROM staff_user WHERE user_id = p_requesting_user_id), CAST(v_old AS CHAR), NULL, NULL, 'stored_proc', NOW());

  DELETE FROM prescription WHERE prescription_id = p_prescription_id;
END$$

DELIMITER ;

-- End of stored procedures
