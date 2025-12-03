-- MySQL dump 10.13  Distrib 8.0.43, for Win64 (x86_64)
--
-- Host: localhost    Database: student_clinic_emr
-- ------------------------------------------------------
-- Server version	8.0.36

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Temporary view structure for view `v_my_billing`
--

DROP TABLE IF EXISTS `v_my_billing`;
/*!50001 DROP VIEW IF EXISTS `v_my_billing`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_my_billing` AS SELECT 
 1 AS `billing_line_id`,
 1 AS `visit_id`,
 1 AS `cpt_code`,
 1 AS `units`,
 1 AS `unit_price`,
 1 AS `amount`,
 1 AS `payer_id`,
 1 AS `claim_status`,
 1 AS `billed_date`,
 1 AS `paid_amount`,
 1 AS `created_at`,
 1 AS `updated_at`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `patients_with_dx`
--

DROP TABLE IF EXISTS `patients_with_dx`;
/*!50001 DROP VIEW IF EXISTS `patients_with_dx`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `patients_with_dx` AS SELECT 
 1 AS `icd10_code`,
 1 AS `dx_description`,
 1 AS `patient_id`,
 1 AS `mrn`,
 1 AS `first_name`,
 1 AS `last_name`,
 1 AS `visit_id`,
 1 AS `diagnosed_at`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `billing_summary`
--

DROP TABLE IF EXISTS `billing_summary`;
/*!50001 DROP VIEW IF EXISTS `billing_summary`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `billing_summary` AS SELECT 
 1 AS `visit_id`,
 1 AS `total_charges`,
 1 AS `total_paid`,
 1 AS `balance_due`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_my_prescriptions`
--

DROP TABLE IF EXISTS `v_my_prescriptions`;
/*!50001 DROP VIEW IF EXISTS `v_my_prescriptions`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_my_prescriptions` AS SELECT 
 1 AS `prescription_id`,
 1 AS `visit_id`,
 1 AS `drug_code`,
 1 AS `drug_name`,
 1 AS `dose`,
 1 AS `dose_unit`,
 1 AS `route`,
 1 AS `frequency`,
 1 AS `duration_days`,
 1 AS `quantity`,
 1 AS `refills`,
 1 AS `start_date`,
 1 AS `end_date`,
 1 AS `status`,
 1 AS `created_at`,
 1 AS `updated_at`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `visit_primary_dx`
--

DROP TABLE IF EXISTS `visit_primary_dx`;
/*!50001 DROP VIEW IF EXISTS `visit_primary_dx`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `visit_primary_dx` AS SELECT 
 1 AS `visit_id`,
 1 AS `icd10_code`,
 1 AS `icd10_description`,
 1 AS `diagnosed_at`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_pharmacy_prescriptions`
--

DROP TABLE IF EXISTS `v_pharmacy_prescriptions`;
/*!50001 DROP VIEW IF EXISTS `v_pharmacy_prescriptions`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_pharmacy_prescriptions` AS SELECT 
 1 AS `prescription_id`,
 1 AS `visit_id`,
 1 AS `patient_id`,
 1 AS `first_name`,
 1 AS `last_name`,
 1 AS `dob`,
 1 AS `drug_code`,
 1 AS `drug_name`,
 1 AS `dose`,
 1 AS `dose_unit`,
 1 AS `route`,
 1 AS `frequency`,
 1 AS `duration_days`,
 1 AS `quantity`,
 1 AS `refills`,
 1 AS `start_date`,
 1 AS `end_date`,
 1 AS `status`,
 1 AS `provider_id`,
 1 AS `provider_first`,
 1 AS `provider_last`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_support_patient_schedule`
--

DROP TABLE IF EXISTS `v_support_patient_schedule`;
/*!50001 DROP VIEW IF EXISTS `v_support_patient_schedule`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_support_patient_schedule` AS SELECT 
 1 AS `visit_id`,
 1 AS `patient_id`,
 1 AS `mrn`,
 1 AS `first_name`,
 1 AS `last_name`,
 1 AS `dob`,
 1 AS `phone`,
 1 AS `email`,
 1 AS `check_in_time`,
 1 AS `check_out_time`,
 1 AS `visit_status`,
 1 AS `scheduled_start`,
 1 AS `scheduled_end`,
 1 AS `appt_status`,
 1 AS `provider_id`,
 1 AS `provider_first`,
 1 AS `provider_last`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `daily_visits_by_provider`
--

DROP TABLE IF EXISTS `daily_visits_by_provider`;
/*!50001 DROP VIEW IF EXISTS `daily_visits_by_provider`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `daily_visits_by_provider` AS SELECT 
 1 AS `visit_date`,
 1 AS `provider_id`,
 1 AS `visit_count`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_my_results`
--

DROP TABLE IF EXISTS `v_my_results`;
/*!50001 DROP VIEW IF EXISTS `v_my_results`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_my_results` AS SELECT 
 1 AS `result_id`,
 1 AS `order_id`,
 1 AS `result_code`,
 1 AS `result_text`,
 1 AS `value_num`,
 1 AS `value_text`,
 1 AS `units`,
 1 AS `abnormal_flag`,
 1 AS `result_date`,
 1 AS `created_at`,
 1 AS `updated_at`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_my_visits`
--

DROP TABLE IF EXISTS `v_my_visits`;
/*!50001 DROP VIEW IF EXISTS `v_my_visits`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_my_visits` AS SELECT 
 1 AS `visit_id`,
 1 AS `patient_id`,
 1 AS `provider_id`,
 1 AS `appointment_id`,
 1 AS `exam_room_id`,
 1 AS `check_in_time`,
 1 AS `check_out_time`,
 1 AS `status`,
 1 AS `chief_complaint`,
 1 AS `reason`,
 1 AS `discharge_disposition`,
 1 AS `discharge_notes`,
 1 AS `created_at`,
 1 AS `updated_at`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_my_diagnoses`
--

DROP TABLE IF EXISTS `v_my_diagnoses`;
/*!50001 DROP VIEW IF EXISTS `v_my_diagnoses`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_my_diagnoses` AS SELECT 
 1 AS `diagnosis_id`,
 1 AS `visit_id`,
 1 AS `icd10_code`,
 1 AS `dx_type`,
 1 AS `diagnosed_at`,
 1 AS `created_at`,
 1 AS `updated_at`*/;
SET character_set_client = @saved_cs_client;

--
-- Final view structure for view `v_my_billing`
--

/*!50001 DROP VIEW IF EXISTS `v_my_billing`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_my_billing` AS select `b`.`billing_line_id` AS `billing_line_id`,`b`.`visit_id` AS `visit_id`,`b`.`cpt_code` AS `cpt_code`,`b`.`units` AS `units`,`b`.`unit_price` AS `unit_price`,`b`.`amount` AS `amount`,`b`.`payer_id` AS `payer_id`,`b`.`claim_status` AS `claim_status`,`b`.`billed_date` AS `billed_date`,`b`.`paid_amount` AS `paid_amount`,`b`.`created_at` AS `created_at`,`b`.`updated_at` AS `updated_at` from (`billing_line` `b` join `visit` `v` on((`v`.`visit_id` = `b`.`visit_id`))) where (`v`.`patient_id` = `portal_patient_id`()) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `patients_with_dx`
--

/*!50001 DROP VIEW IF EXISTS `patients_with_dx`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `patients_with_dx` AS select `d`.`icd10_code` AS `icd10_code`,`r`.`description` AS `dx_description`,`p`.`patient_id` AS `patient_id`,`p`.`mrn` AS `mrn`,`p`.`first_name` AS `first_name`,`p`.`last_name` AS `last_name`,`v`.`visit_id` AS `visit_id`,`d`.`diagnosed_at` AS `diagnosed_at` from (((`diagnosis` `d` join `icd10_ref` `r` on((`r`.`icd10_code` = `d`.`icd10_code`))) join `visit` `v` on((`v`.`visit_id` = `d`.`visit_id`))) join `patient` `p` on((`p`.`patient_id` = `v`.`patient_id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `billing_summary`
--

/*!50001 DROP VIEW IF EXISTS `billing_summary`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `billing_summary` AS select `v`.`visit_id` AS `visit_id`,sum(`b`.`amount`) AS `total_charges`,sum(`b`.`paid_amount`) AS `total_paid`,(sum(`b`.`amount`) - sum(`b`.`paid_amount`)) AS `balance_due` from (`billing_line` `b` join `visit` `v` on((`v`.`visit_id` = `b`.`visit_id`))) group by `v`.`visit_id` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_my_prescriptions`
--

/*!50001 DROP VIEW IF EXISTS `v_my_prescriptions`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_my_prescriptions` AS select `rx`.`prescription_id` AS `prescription_id`,`rx`.`visit_id` AS `visit_id`,`rx`.`drug_code` AS `drug_code`,`rx`.`drug_name` AS `drug_name`,`rx`.`dose` AS `dose`,`rx`.`dose_unit` AS `dose_unit`,`rx`.`route` AS `route`,`rx`.`frequency` AS `frequency`,`rx`.`duration_days` AS `duration_days`,`rx`.`quantity` AS `quantity`,`rx`.`refills` AS `refills`,`rx`.`start_date` AS `start_date`,`rx`.`end_date` AS `end_date`,`rx`.`status` AS `status`,`rx`.`created_at` AS `created_at`,`rx`.`updated_at` AS `updated_at` from (`prescription` `rx` join `visit` `v` on((`v`.`visit_id` = `rx`.`visit_id`))) where (`v`.`patient_id` = `portal_patient_id`()) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `visit_primary_dx`
--

/*!50001 DROP VIEW IF EXISTS `visit_primary_dx`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `visit_primary_dx` AS select `v`.`visit_id` AS `visit_id`,`d`.`icd10_code` AS `icd10_code`,`r`.`description` AS `icd10_description`,`d`.`diagnosed_at` AS `diagnosed_at` from ((`visit` `v` left join `diagnosis` `d` on(((`d`.`visit_id` = `v`.`visit_id`) and (`d`.`dx_type` = 'primary')))) left join `icd10_ref` `r` on((`r`.`icd10_code` = `d`.`icd10_code`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_pharmacy_prescriptions`
--

/*!50001 DROP VIEW IF EXISTS `v_pharmacy_prescriptions`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_pharmacy_prescriptions` AS select `rx`.`prescription_id` AS `prescription_id`,`rx`.`visit_id` AS `visit_id`,`p`.`patient_id` AS `patient_id`,`p`.`first_name` AS `first_name`,`p`.`last_name` AS `last_name`,`p`.`dob` AS `dob`,`rx`.`drug_code` AS `drug_code`,`d`.`drug_name` AS `drug_name`,`rx`.`dose` AS `dose`,`rx`.`dose_unit` AS `dose_unit`,`rx`.`route` AS `route`,`rx`.`frequency` AS `frequency`,`rx`.`duration_days` AS `duration_days`,`rx`.`quantity` AS `quantity`,`rx`.`refills` AS `refills`,`rx`.`start_date` AS `start_date`,`rx`.`end_date` AS `end_date`,`rx`.`status` AS `status`,`pr`.`provider_id` AS `provider_id`,`pr`.`first_name` AS `provider_first`,`pr`.`last_name` AS `provider_last` from ((((`prescription` `rx` join `visit` `v` on((`v`.`visit_id` = `rx`.`visit_id`))) join `patient` `p` on((`p`.`patient_id` = `v`.`patient_id`))) join `provider` `pr` on((`pr`.`provider_id` = `v`.`provider_id`))) join `rx_drug_ref` `d` on((`d`.`drug_code` = `rx`.`drug_code`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_support_patient_schedule`
--

/*!50001 DROP VIEW IF EXISTS `v_support_patient_schedule`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_support_patient_schedule` AS select distinct `v`.`visit_id` AS `visit_id`,`p`.`patient_id` AS `patient_id`,`p`.`mrn` AS `mrn`,`p`.`first_name` AS `first_name`,`p`.`last_name` AS `last_name`,`p`.`dob` AS `dob`,`p`.`phone` AS `phone`,`p`.`email` AS `email`,`v`.`check_in_time` AS `check_in_time`,`v`.`check_out_time` AS `check_out_time`,`v`.`status` AS `visit_status`,`a`.`scheduled_start` AS `scheduled_start`,`a`.`scheduled_end` AS `scheduled_end`,`a`.`status` AS `appt_status`,`pr`.`provider_id` AS `provider_id`,`pr`.`first_name` AS `provider_first`,`pr`.`last_name` AS `provider_last` from (((((`visit` `v` join `patient` `p` on((`p`.`patient_id` = `v`.`patient_id`))) left join `appointment` `a` on((`a`.`appointment_id` = `v`.`appointment_id`))) join `provider` `pr` on((`pr`.`provider_id` = `v`.`provider_id`))) join `provider_department` `pd` on((`pd`.`provider_id` = `pr`.`provider_id`))) join `staff_department` `sd` on((`sd`.`department_id` = `pd`.`department_id`))) where (`sd`.`user_id` = `app_user_id`()) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `daily_visits_by_provider`
--

/*!50001 DROP VIEW IF EXISTS `daily_visits_by_provider`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `daily_visits_by_provider` AS select cast(`v`.`check_in_time` as date) AS `visit_date`,`v`.`provider_id` AS `provider_id`,count(0) AS `visit_count` from `visit` `v` group by cast(`v`.`check_in_time` as date),`v`.`provider_id` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_my_results`
--

/*!50001 DROP VIEW IF EXISTS `v_my_results`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_my_results` AS select `r`.`result_id` AS `result_id`,`r`.`order_id` AS `order_id`,`r`.`result_code` AS `result_code`,`r`.`result_text` AS `result_text`,`r`.`value_num` AS `value_num`,`r`.`value_text` AS `value_text`,`r`.`units` AS `units`,`r`.`abnormal_flag` AS `abnormal_flag`,`r`.`result_date` AS `result_date`,`r`.`created_at` AS `created_at`,`r`.`updated_at` AS `updated_at` from ((`result` `r` join `order` `o` on((`o`.`order_id` = `r`.`order_id`))) join `visit` `v` on((`v`.`visit_id` = `o`.`visit_id`))) where (`v`.`patient_id` = `portal_patient_id`()) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_my_visits`
--

/*!50001 DROP VIEW IF EXISTS `v_my_visits`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_my_visits` AS select `v`.`visit_id` AS `visit_id`,`v`.`patient_id` AS `patient_id`,`v`.`provider_id` AS `provider_id`,`v`.`appointment_id` AS `appointment_id`,`v`.`exam_room_id` AS `exam_room_id`,`v`.`check_in_time` AS `check_in_time`,`v`.`check_out_time` AS `check_out_time`,`v`.`status` AS `status`,`v`.`chief_complaint` AS `chief_complaint`,`v`.`reason` AS `reason`,`v`.`discharge_disposition` AS `discharge_disposition`,`v`.`discharge_notes` AS `discharge_notes`,`v`.`created_at` AS `created_at`,`v`.`updated_at` AS `updated_at` from `visit` `v` where (`v`.`patient_id` = `portal_patient_id`()) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_my_diagnoses`
--

/*!50001 DROP VIEW IF EXISTS `v_my_diagnoses`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_my_diagnoses` AS select `d`.`diagnosis_id` AS `diagnosis_id`,`d`.`visit_id` AS `visit_id`,`d`.`icd10_code` AS `icd10_code`,`d`.`dx_type` AS `dx_type`,`d`.`diagnosed_at` AS `diagnosed_at`,`d`.`created_at` AS `created_at`,`d`.`updated_at` AS `updated_at` from (`diagnosis` `d` join `visit` `v` on((`v`.`visit_id` = `d`.`visit_id`))) where (`v`.`patient_id` = `portal_patient_id`()) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Dumping events for database 'student_clinic_emr'
--

--
-- Dumping routines for database 'student_clinic_emr'
--
/*!50003 DROP FUNCTION IF EXISTS `app_user_id` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `app_user_id`() RETURNS int
    DETERMINISTIC
RETURN @app_user_id ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `portal_patient_id` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `portal_patient_id`() RETURNS int
    DETERMINISTIC
RETURN @portal_patient_id ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_create_patient` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_create_patient`(
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_create_prescription` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_create_prescription`(
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_create_visit` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_create_visit`(
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_delete_patient` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_delete_patient`(IN p_patient_id INT)
BEGIN
    DELETE FROM patient WHERE patient_id = p_patient_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_delete_prescription` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_delete_prescription`(IN p_prescription_id INT, IN p_requesting_user_id INT)
BEGIN
  DECLARE v_old JSON;

  SELECT JSON_OBJECT('prescription_id', prescription_id, 'visit_id', visit_id, 'drug_code', drug_code, 'status', status)
    INTO v_old
  FROM prescription WHERE prescription_id = p_prescription_id;

  -- Insert audit log before delete
  INSERT INTO audit_log (table_name, record_id, action, user_id, username, old_values, new_values, ip_address, user_agent, created_at)
  VALUES ('prescription', p_prescription_id, 'DELETE', p_requesting_user_id, (SELECT username FROM staff_user WHERE user_id = p_requesting_user_id), CAST(v_old AS CHAR), NULL, NULL, 'stored_proc', NOW());

  DELETE FROM prescription WHERE prescription_id = p_prescription_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_delete_visit` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_delete_visit`(IN p_visit_id INT)
BEGIN
    DELETE FROM visit WHERE visit_id = p_visit_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_dispense_prescription` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_dispense_prescription`(
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
    
    
    UPDATE prescription
    SET status = 'Dispensed', updated_at = NOW()
    WHERE prescription_id = p_prescription_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_get_all_patients` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_get_all_patients`()
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_get_all_prescriptions` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_get_all_prescriptions`()
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_get_all_visits` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_get_all_visits`()
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_get_patient_by_id` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_get_patient_by_id`(IN p_patient_id INT)
BEGIN
  SELECT patient_id, mrn, first_name, last_name, dob, sex, phone, email,
         address_line1, address_line2, city, state, zip,
         emergency_contact_name, emergency_contact_phone, created_at, updated_at
  FROM patient
  WHERE patient_id = p_patient_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_get_patient_by_mrn` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_get_patient_by_mrn`(IN p_mrn VARCHAR(20))
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_get_prescriptions_by_patient` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_get_prescriptions_by_patient`(IN p_patient_id INT)
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_get_prescriptions_by_visit` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_get_prescriptions_by_visit`(IN p_visit_id INT)
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_get_prescription_by_id` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_get_prescription_by_id`(IN p_prescription_id INT)
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_get_visits_by_patient` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_get_visits_by_patient`(IN p_patient_id INT)
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_get_visit_by_id` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_get_visit_by_id`(IN p_visit_id INT)
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_search_patients` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_search_patients`(IN p_search_term VARCHAR(100))
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_update_patient` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_update_patient`(
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_update_prescription` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_update_prescription`(
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_update_visit` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_update_visit`(
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-12-03  9:04:58
