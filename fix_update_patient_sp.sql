-- Fix sp_update_patient stored procedure
-- Run this script in MySQL to update the stored procedure

USE student_clinic_emr;

DELIMITER $$

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

DELIMITER ;

-- Verify the procedure was created correctly
SHOW CREATE PROCEDURE sp_update_patient;
