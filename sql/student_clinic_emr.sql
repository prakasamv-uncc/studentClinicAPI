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
-- Table structure for table `appointment`
--

DROP TABLE IF EXISTS `appointment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `appointment` (
  `appointment_id` int NOT NULL AUTO_INCREMENT,
  `patient_id` int NOT NULL,
  `provider_id` int NOT NULL,
  `exam_room_id` int DEFAULT NULL,
  `scheduled_start` datetime(3) NOT NULL,
  `scheduled_end` datetime(3) NOT NULL,
  `status` enum('scheduled','checked_in','no_show','canceled','completed') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'scheduled',
  `reason` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updated_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`appointment_id`),
  KEY `idx_appt_provider_time` (`provider_id`,`scheduled_start`),
  KEY `idx_appt_patient_time` (`patient_id`,`scheduled_start`),
  KEY `idx_appt_room_time` (`exam_room_id`,`scheduled_start`,`scheduled_end`),
  CONSTRAINT `fk_appt_exam_room` FOREIGN KEY (`exam_room_id`) REFERENCES `exam_room` (`exam_room_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_appt_patient` FOREIGN KEY (`patient_id`) REFERENCES `patient` (`patient_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_appt_provider` FOREIGN KEY (`provider_id`) REFERENCES `provider` (`provider_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `ck_appt_time` CHECK ((`scheduled_end` > `scheduled_start`))
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `appointment`
--

LOCK TABLES `appointment` WRITE;
/*!40000 ALTER TABLE `appointment` DISABLE KEYS */;
INSERT INTO `appointment` VALUES (1,1,1,1,'2025-10-06 14:00:00.000','2025-10-06 14:20:00.000','completed','Sore throat','2025-10-11 23:48:20.978','2025-10-11 23:48:20.978'),(2,2,2,2,'2025-10-08 09:00:00.000','2025-10-08 09:20:00.000','completed','Annual physical','2025-10-11 23:48:20.978','2025-10-11 23:48:20.978'),(3,1,1,1,'2025-10-10 10:00:00.000','2025-10-10 10:20:00.000','completed','Follow-up','2025-10-11 23:48:20.978','2025-10-11 23:48:20.978'),(4,3,3,1,'2025-10-10 11:00:00.000','2025-10-10 11:20:00.000','scheduled','Flu shot','2025-10-11 23:48:20.978','2025-10-11 23:48:20.978'),(5,5,4,1,'2025-10-11 09:00:00.000','2025-10-11 09:20:00.000','completed','Skin rash','2025-10-16 18:06:02.034','2025-10-16 18:06:02.034'),(6,6,5,2,'2025-10-12 10:00:00.000','2025-10-12 10:20:00.000','completed','Annual gynecological exam','2025-10-16 18:06:02.034','2025-10-16 18:06:02.034'),(7,7,4,1,'2025-10-13 11:00:00.000','2025-10-13 11:20:00.000','scheduled','Follow-up visit','2025-10-16 18:06:02.034','2025-10-16 18:06:02.034'),(8,8,5,2,'2025-10-14 13:00:00.000','2025-10-14 13:20:00.000','scheduled','Birth control consultation','2025-10-16 18:06:02.034','2025-10-16 18:06:02.034'),(9,5,4,1,'2025-10-15 14:00:00.000','2025-10-15 14:20:00.000','scheduled','Rash follow-up','2025-10-16 18:06:02.034','2025-10-16 18:06:02.034');
/*!40000 ALTER TABLE `appointment` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_appt_no_overlap_bi` BEFORE INSERT ON `appointment` FOR EACH ROW BEGIN
  IF NEW.exam_room_id IS NOT NULL THEN
    IF EXISTS (
      SELECT 1 FROM appointment a
      WHERE a.exam_room_id = NEW.exam_room_id
        AND a.status IN ('scheduled','checked_in','completed')
        AND NOT (NEW.scheduled_end <= a.scheduled_start OR NEW.scheduled_start >= a.scheduled_end)
    ) THEN
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Appointment overlaps existing booking in this exam room';
    END IF;
  END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_appt_no_overlap_bu` BEFORE UPDATE ON `appointment` FOR EACH ROW BEGIN
  IF NEW.exam_room_id IS NOT NULL THEN
    IF EXISTS (
      SELECT 1 FROM appointment a
      WHERE a.appointment_id <> OLD.appointment_id
        AND a.exam_room_id = NEW.exam_room_id
        AND a.status IN ('scheduled','checked_in','completed')
        AND NOT (NEW.scheduled_end <= a.scheduled_start OR NEW.scheduled_start >= a.scheduled_end)
    ) THEN
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Appointment overlaps existing booking in this exam room';
    END IF;
  END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `audit_log`
--

DROP TABLE IF EXISTS `audit_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `audit_log` (
  `audit_id` int NOT NULL AUTO_INCREMENT,
  `table_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `record_id` int NOT NULL,
  `action` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` int DEFAULT NULL,
  `username` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `old_values` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `new_values` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `ip_address` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_agent` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`audit_id`),
  KEY `idx_table_name` (`table_name`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_created_at` (`created_at`)
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `audit_log`
--

LOCK TABLES `audit_log` WRITE;
/*!40000 ALTER TABLE `audit_log` DISABLE KEYS */;
INSERT INTO `audit_log` VALUES (1,'patient',5,'UPDATE',NULL,NULL,'{\"phone\": \"555-0105\", \"last_name\": \"Allen\", \"first_name\": \"Kim\"}','{\"phone\": \"555-0105\", \"last_name\": \"Allen\", \"first_name\": \"Kim\"}',NULL,NULL,'2025-12-01 22:18:54.000'),(2,'patient',6,'UPDATE',NULL,NULL,'{\"phone\": \"555-0106\", \"last_name\": \"Baker\", \"first_name\": \"Lee\"}','{\"phone\": \"555-0106\", \"last_name\": \"Baker\", \"first_name\": \"Lee\"}',NULL,NULL,'2025-12-01 22:18:54.000'),(3,'patient',7,'UPDATE',NULL,NULL,'{\"phone\": \"555-0107\", \"last_name\": \"Clark\", \"first_name\": \"Mia\"}','{\"phone\": \"555-0107\", \"last_name\": \"Clark\", \"first_name\": \"Mia\"}',NULL,NULL,'2025-12-01 22:18:54.000'),(4,'patient',8,'UPDATE',NULL,NULL,'{\"phone\": \"555-0108\", \"last_name\": \"Davis\", \"first_name\": \"Noah\"}','{\"phone\": \"555-0108\", \"last_name\": \"Davis\", \"first_name\": \"Noah\"}',NULL,NULL,'2025-12-01 22:18:54.000'),(5,'patient',9,'UPDATE',NULL,NULL,'{\"phone\": \"555-0205\", \"last_name\": \"Evans\", \"first_name\": \"Olivia\"}','{\"phone\": \"555-0205\", \"last_name\": \"Evans\", \"first_name\": \"Olivia\"}',NULL,NULL,'2025-12-01 22:18:54.000'),(6,'patient',10,'UPDATE',NULL,NULL,'{\"phone\": \"555-0206\", \"last_name\": \"Foster\", \"first_name\": \"Paul\"}','{\"phone\": \"555-0206\", \"last_name\": \"Foster\", \"first_name\": \"Paul\"}',NULL,NULL,'2025-12-01 22:18:54.000'),(7,'patient',11,'UPDATE',NULL,NULL,'{\"phone\": \"555-0207\", \"last_name\": \"Garcia\", \"first_name\": \"Quinn\"}','{\"phone\": \"555-0207\", \"last_name\": \"Garcia\", \"first_name\": \"Quinn\"}',NULL,NULL,'2025-12-01 22:18:54.000'),(8,'patient',12,'UPDATE',NULL,NULL,'{\"phone\": \"555-0208\", \"last_name\": \"Hughes\", \"first_name\": \"Ria\"}','{\"phone\": \"555-0208\", \"last_name\": \"Hughes\", \"first_name\": \"Ria\"}',NULL,NULL,'2025-12-01 22:18:54.000'),(9,'patient',13,'UPDATE',NULL,NULL,'{\"phone\": \"555-0209\", \"last_name\": \"Ibrahim\", \"first_name\": \"Sam\"}','{\"phone\": \"555-0209\", \"last_name\": \"Ibrahim\", \"first_name\": \"Sam\"}',NULL,NULL,'2025-12-01 22:18:54.000'),(10,'patient',14,'UPDATE',NULL,NULL,'{\"phone\": \"555-0210\", \"last_name\": \"Jones\", \"first_name\": \"Tom\"}','{\"phone\": \"555-0210\", \"last_name\": \"Jones\", \"first_name\": \"Tom\"}',NULL,NULL,'2025-12-01 22:18:54.000'),(11,'patient',5,'UPDATE',NULL,NULL,'{\"phone\": \"555-0105\", \"last_name\": \"Allen\", \"first_name\": \"Kim\"}','{\"phone\": \"555-0105\", \"last_name\": \"Allen\", \"first_name\": \"Kim\"}',NULL,NULL,'2025-12-03 08:39:11.000'),(12,'patient',6,'UPDATE',NULL,NULL,'{\"phone\": \"555-0106\", \"last_name\": \"Baker\", \"first_name\": \"Lee\"}','{\"phone\": \"555-0106\", \"last_name\": \"Baker\", \"first_name\": \"Lee\"}',NULL,NULL,'2025-12-03 08:39:11.000'),(13,'patient',7,'UPDATE',NULL,NULL,'{\"phone\": \"555-0107\", \"last_name\": \"Clark\", \"first_name\": \"Mia\"}','{\"phone\": \"555-0107\", \"last_name\": \"Clark\", \"first_name\": \"Mia\"}',NULL,NULL,'2025-12-03 08:39:11.000'),(14,'patient',8,'UPDATE',NULL,NULL,'{\"phone\": \"555-0108\", \"last_name\": \"Davis\", \"first_name\": \"Noah\"}','{\"phone\": \"555-0108\", \"last_name\": \"Davis\", \"first_name\": \"Noah\"}',NULL,NULL,'2025-12-03 08:39:11.000'),(15,'patient',9,'UPDATE',NULL,NULL,'{\"phone\": \"555-0205\", \"last_name\": \"Evans\", \"first_name\": \"Olivia\"}','{\"phone\": \"555-0205\", \"last_name\": \"Evans\", \"first_name\": \"Olivia\"}',NULL,NULL,'2025-12-03 08:39:11.000'),(16,'patient',10,'UPDATE',NULL,NULL,'{\"phone\": \"555-0206\", \"last_name\": \"Foster\", \"first_name\": \"Paul\"}','{\"phone\": \"555-0206\", \"last_name\": \"Foster\", \"first_name\": \"Paul\"}',NULL,NULL,'2025-12-03 08:39:11.000'),(17,'patient',11,'UPDATE',NULL,NULL,'{\"phone\": \"555-0207\", \"last_name\": \"Garcia\", \"first_name\": \"Quinn\"}','{\"phone\": \"555-0207\", \"last_name\": \"Garcia\", \"first_name\": \"Quinn\"}',NULL,NULL,'2025-12-03 08:39:11.000'),(18,'patient',12,'UPDATE',NULL,NULL,'{\"phone\": \"555-0208\", \"last_name\": \"Hughes\", \"first_name\": \"Ria\"}','{\"phone\": \"555-0208\", \"last_name\": \"Hughes\", \"first_name\": \"Ria\"}',NULL,NULL,'2025-12-03 08:39:11.000'),(19,'patient',13,'UPDATE',NULL,NULL,'{\"phone\": \"555-0209\", \"last_name\": \"Ibrahim\", \"first_name\": \"Sam\"}','{\"phone\": \"555-0209\", \"last_name\": \"Ibrahim\", \"first_name\": \"Sam\"}',NULL,NULL,'2025-12-03 08:39:11.000'),(20,'patient',14,'UPDATE',NULL,NULL,'{\"phone\": \"555-0210\", \"last_name\": \"Jones\", \"first_name\": \"Tom\"}','{\"phone\": \"555-0210\", \"last_name\": \"Jones\", \"first_name\": \"Tom\"}',NULL,NULL,'2025-12-03 08:39:11.000'),(21,'patient',5,'UPDATE',NULL,NULL,'{\"phone\": \"555-0105\", \"last_name\": \"Allen\", \"first_name\": \"Kim\"}','{\"phone\": \"555-0105\", \"last_name\": \"Allen\", \"first_name\": \"Kim\"}',NULL,NULL,'2025-12-03 08:40:38.000'),(22,'patient',6,'UPDATE',NULL,NULL,'{\"phone\": \"555-0106\", \"last_name\": \"Baker\", \"first_name\": \"Lee\"}','{\"phone\": \"555-0106\", \"last_name\": \"Baker\", \"first_name\": \"Lee\"}',NULL,NULL,'2025-12-03 08:40:38.000'),(23,'patient',7,'UPDATE',NULL,NULL,'{\"phone\": \"555-0107\", \"last_name\": \"Clark\", \"first_name\": \"Mia\"}','{\"phone\": \"555-0107\", \"last_name\": \"Clark\", \"first_name\": \"Mia\"}',NULL,NULL,'2025-12-03 08:40:38.000'),(24,'patient',8,'UPDATE',NULL,NULL,'{\"phone\": \"555-0108\", \"last_name\": \"Davis\", \"first_name\": \"Noah\"}','{\"phone\": \"555-0108\", \"last_name\": \"Davis\", \"first_name\": \"Noah\"}',NULL,NULL,'2025-12-03 08:40:38.000'),(25,'patient',9,'UPDATE',NULL,NULL,'{\"phone\": \"555-0205\", \"last_name\": \"Evans\", \"first_name\": \"Olivia\"}','{\"phone\": \"555-0205\", \"last_name\": \"Evans\", \"first_name\": \"Olivia\"}',NULL,NULL,'2025-12-03 08:40:38.000'),(26,'patient',10,'UPDATE',NULL,NULL,'{\"phone\": \"555-0206\", \"last_name\": \"Foster\", \"first_name\": \"Paul\"}','{\"phone\": \"555-0206\", \"last_name\": \"Foster\", \"first_name\": \"Paul\"}',NULL,NULL,'2025-12-03 08:40:38.000'),(27,'patient',11,'UPDATE',NULL,NULL,'{\"phone\": \"555-0207\", \"last_name\": \"Garcia\", \"first_name\": \"Quinn\"}','{\"phone\": \"555-0207\", \"last_name\": \"Garcia\", \"first_name\": \"Quinn\"}',NULL,NULL,'2025-12-03 08:40:38.000'),(28,'patient',12,'UPDATE',NULL,NULL,'{\"phone\": \"555-0208\", \"last_name\": \"Hughes\", \"first_name\": \"Ria\"}','{\"phone\": \"555-0208\", \"last_name\": \"Hughes\", \"first_name\": \"Ria\"}',NULL,NULL,'2025-12-03 08:40:38.000'),(29,'patient',13,'UPDATE',NULL,NULL,'{\"phone\": \"555-0209\", \"last_name\": \"Ibrahim\", \"first_name\": \"Sam\"}','{\"phone\": \"555-0209\", \"last_name\": \"Ibrahim\", \"first_name\": \"Sam\"}',NULL,NULL,'2025-12-03 08:40:38.000'),(30,'patient',14,'UPDATE',NULL,NULL,'{\"phone\": \"555-0210\", \"last_name\": \"Jones\", \"first_name\": \"Tom\"}','{\"phone\": \"555-0210\", \"last_name\": \"Jones\", \"first_name\": \"Tom\"}',NULL,NULL,'2025-12-03 08:40:38.000');
/*!40000 ALTER TABLE `audit_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `billing_line`
--

DROP TABLE IF EXISTS `billing_line`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `billing_line` (
  `billing_line_id` int NOT NULL AUTO_INCREMENT,
  `visit_id` int NOT NULL,
  `cpt_code` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `units` int NOT NULL DEFAULT '1',
  `unit_price` decimal(10,2) NOT NULL DEFAULT '0.00',
  `amount` decimal(12,2) GENERATED ALWAYS AS ((`units` * `unit_price`)) STORED,
  `payer_id` int DEFAULT NULL,
  `claim_status` enum('pending','submitted','paid','denied','adjusted') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  `billed_date` date DEFAULT NULL,
  `paid_amount` decimal(10,2) NOT NULL DEFAULT '0.00',
  `created_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updated_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`billing_line_id`),
  KEY `fk_bill_payer` (`payer_id`),
  KEY `fk_bill_cpt` (`cpt_code`),
  KEY `idx_bill_visit` (`visit_id`),
  KEY `idx_bill_status` (`claim_status`),
  CONSTRAINT `fk_bill_cpt` FOREIGN KEY (`cpt_code`) REFERENCES `cpt_ref` (`cpt_code`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_bill_payer` FOREIGN KEY (`payer_id`) REFERENCES `payer` (`payer_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_bill_visit` FOREIGN KEY (`visit_id`) REFERENCES `visit` (`visit_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `ck_paid` CHECK ((`paid_amount` >= 0)),
  CONSTRAINT `ck_price` CHECK ((`unit_price` >= 0)),
  CONSTRAINT `ck_units` CHECK ((`units` > 0))
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `billing_line`
--

LOCK TABLES `billing_line` WRITE;
/*!40000 ALTER TABLE `billing_line` DISABLE KEYS */;
INSERT INTO `billing_line` (`billing_line_id`, `visit_id`, `cpt_code`, `units`, `unit_price`, `payer_id`, `claim_status`, `billed_date`, `paid_amount`, `created_at`, `updated_at`) VALUES (1,1,'87880',1,25.00,1,'submitted','2025-10-06',0.00,'2025-10-11 23:48:21.063','2025-10-11 23:48:21.063'),(2,1,'99213',1,95.00,1,'submitted','2025-10-06',0.00,'2025-10-11 23:48:21.063','2025-10-11 23:48:21.063'),(3,2,'99395',1,140.00,1,'paid','2025-10-08',140.00,'2025-10-11 23:48:21.063','2025-10-11 23:48:21.063'),(4,3,'99212',1,70.00,1,'pending','2025-10-10',0.00,'2025-10-11 23:48:21.063','2025-10-11 23:48:21.063'),(5,4,'99212',1,75.00,1,'submitted','2025-10-11',0.00,'2025-10-16 18:06:02.186','2025-10-16 18:06:02.186'),(6,5,'99395',1,140.00,2,'pending','2025-10-12',0.00,'2025-10-16 18:06:02.186','2025-10-16 18:06:02.186');
/*!40000 ALTER TABLE `billing_line` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Table structure for table `cpt_ref`
--

DROP TABLE IF EXISTS `cpt_ref`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cpt_ref` (
  `cpt_code` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`cpt_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cpt_ref`
--

LOCK TABLES `cpt_ref` WRITE;
/*!40000 ALTER TABLE `cpt_ref` DISABLE KEYS */;
INSERT INTO `cpt_ref` VALUES ('87880','Rapid strep test'),('90471','Immunization administration'),('99212','Office/outpatient visit, est'),('99213','Office/outpatient visit, est, moderate'),('99395','Periodic comprehensive preventive medicine');
/*!40000 ALTER TABLE `cpt_ref` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Table structure for table `department`
--

DROP TABLE IF EXISTS `department`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `department` (
  `department_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`department_id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `department`
--

LOCK TABLES `department` WRITE;
/*!40000 ALTER TABLE `department` DISABLE KEYS */;
INSERT INTO `department` VALUES (1,'Family Medicine'),(4,'Front Desk'),(2,'Internal Medicine'),(6,'IT'),(5,'Management'),(3,'Pediatrics'),(7,'Pharmacy');
/*!40000 ALTER TABLE `department` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `diagnosis`
--

DROP TABLE IF EXISTS `diagnosis`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `diagnosis` (
  `diagnosis_id` int NOT NULL AUTO_INCREMENT,
  `visit_id` int NOT NULL,
  `icd10_code` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `dx_type` enum('primary','secondary') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'primary',
  `diagnosed_at` datetime(3) NOT NULL,
  `created_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updated_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`diagnosis_id`),
  KEY `idx_dx_code_time` (`icd10_code`,`diagnosed_at`),
  KEY `idx_dx_visit` (`visit_id`),
  KEY `idx_dx_patient` (`visit_id`,`icd10_code`),
  CONSTRAINT `fk_dx_icd` FOREIGN KEY (`icd10_code`) REFERENCES `icd10_ref` (`icd10_code`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_dx_visit` FOREIGN KEY (`visit_id`) REFERENCES `visit` (`visit_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `diagnosis`
--

LOCK TABLES `diagnosis` WRITE;
/*!40000 ALTER TABLE `diagnosis` DISABLE KEYS */;
INSERT INTO `diagnosis` VALUES (1,1,'J02.9','primary','2025-10-06 14:10:00.000','2025-10-11 23:48:21.010','2025-10-11 23:48:21.010'),(2,2,'Z00.00','primary','2025-10-08 09:10:00.000','2025-10-11 23:48:21.010','2025-10-11 23:48:21.010'),(3,3,'J02.9','primary','2025-10-10 10:10:00.000','2025-10-11 23:48:21.010','2025-10-11 23:48:21.010'),(4,4,'J02.9','primary','2025-10-11 09:12:00.000','2025-10-16 18:06:02.085','2025-10-16 18:06:02.085'),(5,5,'Z00.00','primary','2025-10-12 10:12:00.000','2025-10-16 18:06:02.085','2025-10-16 18:06:02.085');
/*!40000 ALTER TABLE `diagnosis` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `emergency_contact`
--

DROP TABLE IF EXISTS `emergency_contact`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `emergency_contact` (
  `emergency_contact_id` int NOT NULL AUTO_INCREMENT,
  `patient_id` int NOT NULL,
  `name` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `relationship` varchar(60) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `phone` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email` varchar(150) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `is_primary` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updated_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`emergency_contact_id`),
  KEY `fk_emc_patient` (`patient_id`),
  CONSTRAINT `fk_emc_patient` FOREIGN KEY (`patient_id`) REFERENCES `patient` (`patient_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `emergency_contact`
--

LOCK TABLES `emergency_contact` WRITE;
/*!40000 ALTER TABLE `emergency_contact` DISABLE KEYS */;
INSERT INTO `emergency_contact` VALUES (1,1,'Sara Student','Mother','555-1111',NULL,1,'2025-10-11 23:48:20.957','2025-10-11 23:48:20.957'),(2,2,'Carlos Rivera','Father','555-2222',NULL,1,'2025-10-11 23:48:20.957','2025-10-11 23:48:20.957'),(3,5,'Maria Flores','Mother','555-3333',NULL,1,'2025-10-16 18:06:01.883','2025-10-16 18:06:01.883'),(4,6,'Peter Brown','Father','555-4444',NULL,1,'2025-10-16 18:06:01.883','2025-10-16 18:06:01.883'),(5,7,'Anil Kumar','Father','555-5555',NULL,1,'2025-10-16 18:06:01.883','2025-10-16 18:06:01.883'),(6,8,'Grace Wang','Mother','555-6666',NULL,1,'2025-10-16 18:06:01.883','2025-10-16 18:06:01.883');
/*!40000 ALTER TABLE `emergency_contact` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `exam_room`
--

DROP TABLE IF EXISTS `exam_room`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `exam_room` (
  `exam_room_id` int NOT NULL AUTO_INCREMENT,
  `facility_id` int NOT NULL,
  `room_name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updated_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`exam_room_id`),
  UNIQUE KEY `uq_exam_room` (`facility_id`,`room_name`),
  CONSTRAINT `fk_exam_room_facility` FOREIGN KEY (`facility_id`) REFERENCES `facility` (`facility_id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `exam_room`
--

LOCK TABLES `exam_room` WRITE;
/*!40000 ALTER TABLE `exam_room` DISABLE KEYS */;
INSERT INTO `exam_room` VALUES (1,1,'Room A','2025-10-11 23:48:20.928','2025-10-11 23:48:20.928'),(2,1,'Room B','2025-10-11 23:48:20.928','2025-10-11 23:48:20.928');
/*!40000 ALTER TABLE `exam_room` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `facility`
--

DROP TABLE IF EXISTS `facility`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `facility` (
  `facility_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updated_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`facility_id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `facility`
--

LOCK TABLES `facility` WRITE;
/*!40000 ALTER TABLE `facility` DISABLE KEYS */;
INSERT INTO `facility` VALUES (1,'Campus Health Center','2025-10-11 23:48:20.918','2025-10-11 23:48:20.918');
/*!40000 ALTER TABLE `facility` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `icd10_ref`
--

DROP TABLE IF EXISTS `icd10_ref`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `icd10_ref` (
  `icd10_code` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`icd10_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `icd10_ref`
--

LOCK TABLES `icd10_ref` WRITE;
/*!40000 ALTER TABLE `icd10_ref` DISABLE KEYS */;
INSERT INTO `icd10_ref` VALUES ('J02.9','Acute pharyngitis, unspecified'),('Z00.00','Encounter for general adult exam');
/*!40000 ALTER TABLE `icd10_ref` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `insurance_policy`
--

DROP TABLE IF EXISTS `insurance_policy`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `insurance_policy` (
  `insurance_policy_id` int NOT NULL AUTO_INCREMENT,
  `payer_name` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `plan_name` varchar(150) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `policy_number` varchar(80) COLLATE utf8mb4_unicode_ci NOT NULL,
  `member_id` varchar(80) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `created_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updated_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`insurance_policy_id`),
  UNIQUE KEY `uq_policy` (`payer_name`,`policy_number`),
  CONSTRAINT `ck_policy_dates` CHECK (((`end_date` is null) or (`end_date` >= `start_date`)))
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `insurance_policy`
--

LOCK TABLES `insurance_policy` WRITE;
/*!40000 ALTER TABLE `insurance_policy` DISABLE KEYS */;
INSERT INTO `insurance_policy` VALUES (1,'Campus Health Plan','Student Basic','CB-1001','M-1001','2025-08-01',NULL,'2025-10-11 23:48:20.965','2025-10-11 23:48:20.965'),(2,'BluePlus','Silver PPO','BP-2222','BP-M-2222','2025-01-01',NULL,'2025-10-11 23:48:20.965','2025-10-11 23:48:20.965'),(3,'Campus Health Plan','Student Premium','CB-1002','M-1002','2025-08-01',NULL,'2025-10-16 18:06:01.934','2025-10-16 18:06:01.934'),(4,'BluePlus','Gold PPO','BP-3333','BP-M-3333','2025-01-01',NULL,'2025-10-16 18:06:01.934','2025-10-16 18:06:01.934');
/*!40000 ALTER TABLE `insurance_policy` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `loinc_ref`
--

DROP TABLE IF EXISTS `loinc_ref`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `loinc_ref` (
  `test_code` varchar(40) COLLATE utf8mb4_unicode_ci NOT NULL,
  `test_name` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`test_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `loinc_ref`
--

LOCK TABLES `loinc_ref` WRITE;
/*!40000 ALTER TABLE `loinc_ref` DISABLE KEYS */;
INSERT INTO `loinc_ref` VALUES ('LIPID','Lipid Panel'),('STREP','Rapid Strep A');
/*!40000 ALTER TABLE `loinc_ref` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `observation`
--

DROP TABLE IF EXISTS `observation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `observation` (
  `observation_id` int NOT NULL AUTO_INCREMENT,
  `visit_id` int NOT NULL,
  `type_code` varchar(40) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `value_num` decimal(12,4) DEFAULT NULL,
  `value_text` varchar(400) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `units` varchar(40) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ref_low` decimal(12,4) DEFAULT NULL,
  `ref_high` decimal(12,4) DEFAULT NULL,
  `abnormal_flag` enum('N','A','H','L','U') COLLATE utf8mb4_unicode_ci DEFAULT 'U',
  `observed_at` datetime(3) NOT NULL,
  `created_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updated_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`observation_id`),
  KEY `fk_obx_type` (`type_code`),
  KEY `idx_obx_visit_time` (`visit_id`,`observed_at`),
  CONSTRAINT `fk_obx_type` FOREIGN KEY (`type_code`) REFERENCES `obx_type_ref` (`type_code`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_obx_visit` FOREIGN KEY (`visit_id`) REFERENCES `visit` (`visit_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `observation`
--

LOCK TABLES `observation` WRITE;
/*!40000 ALTER TABLE `observation` DISABLE KEYS */;
INSERT INTO `observation` VALUES (1,1,'HR',102.0000,NULL,'bpm',60.0000,100.0000,'H','2025-10-06 14:05:00.000','2025-10-11 23:48:21.000','2025-10-11 23:48:21.000'),(2,1,'TEMP',38.2000,NULL,'C',36.5000,37.5000,'H','2025-10-06 14:06:00.000','2025-10-11 23:48:21.000','2025-10-11 23:48:21.000'),(3,2,'BP',120.0000,NULL,'mmHg',NULL,NULL,'N','2025-10-08 09:05:00.000','2025-10-11 23:48:21.000','2025-10-11 23:48:21.000'),(4,3,'HR',84.0000,NULL,'bpm',60.0000,100.0000,'N','2025-10-10 10:05:00.000','2025-10-11 23:48:21.000','2025-10-11 23:48:21.000');
/*!40000 ALTER TABLE `observation` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `obx_type_ref`
--

DROP TABLE IF EXISTS `obx_type_ref`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `obx_type_ref` (
  `type_code` varchar(40) COLLATE utf8mb4_unicode_ci NOT NULL,
  `type_text` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL,
  `default_units` varchar(40) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`type_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `obx_type_ref`
--

LOCK TABLES `obx_type_ref` WRITE;
/*!40000 ALTER TABLE `obx_type_ref` DISABLE KEYS */;
INSERT INTO `obx_type_ref` VALUES ('BP','Blood Pressure','mmHg'),('HR','Heart Rate','bpm'),('TEMP','Temperature','C');
/*!40000 ALTER TABLE `obx_type_ref` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order`
--

DROP TABLE IF EXISTS `order`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order` (
  `order_id` int NOT NULL AUTO_INCREMENT,
  `visit_id` int NOT NULL,
  `order_type` enum('lab','imaging','procedure') COLLATE utf8mb4_unicode_ci NOT NULL,
  `test_code` varchar(40) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `priority` enum('routine','stat') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'routine',
  `status` enum('ordered','collected','resulted','verified','canceled') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'ordered',
  `ordered_at` datetime(3) NOT NULL,
  `collected_at` datetime(3) DEFAULT NULL,
  `resulted_at` datetime(3) DEFAULT NULL,
  `created_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updated_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`order_id`),
  KEY `fk_ord_loinc` (`test_code`),
  KEY `idx_order_status` (`status`),
  KEY `idx_order_visit` (`visit_id`,`ordered_at`),
  CONSTRAINT `fk_ord_loinc` FOREIGN KEY (`test_code`) REFERENCES `loinc_ref` (`test_code`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_ord_visit` FOREIGN KEY (`visit_id`) REFERENCES `visit` (`visit_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order`
--

LOCK TABLES `order` WRITE;
/*!40000 ALTER TABLE `order` DISABLE KEYS */;
INSERT INTO `order` VALUES (1,1,'lab','STREP','routine','ordered','2025-10-06 14:07:00.000',NULL,NULL,'2025-10-11 23:48:21.027','2025-10-11 23:48:21.027'),(2,2,'lab','LIPID','routine','resulted','2025-10-08 09:06:00.000',NULL,NULL,'2025-10-11 23:48:21.027','2025-10-11 23:48:21.027'),(3,5,'lab','LIPID','routine','ordered','2025-10-12 10:10:00.000',NULL,NULL,'2025-10-16 18:06:02.139','2025-10-16 18:06:02.139');
/*!40000 ALTER TABLE `order` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `patient`
--

DROP TABLE IF EXISTS `patient`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `patient` (
  `patient_id` int NOT NULL AUTO_INCREMENT,
  `mrn` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  `first_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `dob` date NOT NULL,
  `sex` enum('F','M','O','U') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'U',
  `phone` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email` varchar(150) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `address_line1` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `address_line2` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `city` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `state` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `zip` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `emergency_contact_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `emergency_contact_phone` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updated_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`patient_id`),
  UNIQUE KEY `mrn` (`mrn`),
  KEY `idx_patient_name` (`last_name`,`first_name`),
  KEY `idx_patient_dob` (`dob`),
  FULLTEXT KEY `idx_patient_fullname` (`first_name`,`last_name`)
) ENGINE=InnoDB AUTO_INCREMENT=36 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `patient`
--

LOCK TABLES `patient` WRITE;
/*!40000 ALTER TABLE `patient` DISABLE KEYS */;
INSERT INTO `patient` VALUES (1,'S0001','Jane','Student','2003-05-12','F','555-0101','jane@example.edu',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2025-10-11 23:48:20.945','2025-10-11 23:48:20.945'),(2,'S0002','Mark','Rivera','2002-11-03','M','555-0102','mark@example.edu',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2025-10-11 23:48:20.945','2025-10-11 23:48:20.945'),(3,'S0003','Priya','Patel','2004-02-20','F','555-0103','priya@example.edu',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2025-10-11 23:48:20.945','2025-10-11 23:48:20.945'),(4,'S0004','Leo','Chen','2001-08-15','M','555-0104','leo@example.edu',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2025-10-11 23:48:20.945','2025-10-11 23:48:20.945'),(5,'S0005','Kim','Allen','2003-03-15','M','555-0105','omar@example.edu',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2025-10-16 18:06:01.803','2025-11-10 21:28:27.731'),(6,'S0006','Lee','Baker','2004-12-22','F','555-0106','natalie@example.edu',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2025-10-16 18:06:01.803','2025-11-10 21:28:27.731'),(7,'S0007','Mia','Clark','2002-06-30','M','555-0107','ravi@example.edu',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2025-10-16 18:06:01.803','2025-11-10 21:28:27.731'),(8,'S0008','Noah','Davis','2003-09-09','F','555-0108','lily@example.edu',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2025-10-16 18:06:01.803','2025-11-10 21:28:27.731'),(9,'S0009','Olivia','Evans','2003-03-17','F','555-0205','olivia.evans@example.edu',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2025-11-10 21:28:27.731','2025-11-10 21:28:27.731'),(10,'S0010','Paul','Foster','2001-12-05','M','555-0206','paul.foster@example.edu',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2025-11-10 21:28:27.731','2025-11-10 21:28:27.731'),(11,'S0011','Quinn','Garcia','2004-08-14','O','555-0207','quinn.garcia@example.edu',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2025-11-10 21:28:27.731','2025-11-10 21:28:27.731'),(12,'S0012','Ria','Hughes','2003-10-28','F','555-0208','ria.hughes@example.edu',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2025-11-10 21:28:27.731','2025-11-10 21:28:27.731'),(13,'S0013','Sam','Ibrahim','2002-06-19','M','555-0209','sam.ibrahim@example.edu',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2025-11-10 21:28:27.731','2025-11-10 21:28:27.731'),(14,'S0014','Tom','Jones','2004-02-26','M','555-0210','tom.jones@example.edu',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2025-11-10 21:28:27.731','2025-11-10 21:28:27.731');
/*!40000 ALTER TABLE `patient` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_patient_after_insert` AFTER INSERT ON `patient` FOR EACH ROW BEGIN
    INSERT INTO audit_log (table_name, record_id, action, user_id, new_values, created_at)
    VALUES ('patient', NEW.patient_id, 'INSERT', @app_user_id, 
            JSON_OBJECT('mrn', NEW.mrn, 'first_name', NEW.first_name, 'last_name', NEW.last_name),
            NOW());
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_patient_after_update` AFTER UPDATE ON `patient` FOR EACH ROW BEGIN
    INSERT INTO audit_log (table_name, record_id, action, user_id, old_values, new_values, created_at)
    VALUES ('patient', NEW.patient_id, 'UPDATE', @app_user_id,
            JSON_OBJECT('first_name', OLD.first_name, 'last_name', OLD.last_name, 'phone', OLD.phone),
            JSON_OBJECT('first_name', NEW.first_name, 'last_name', NEW.last_name, 'phone', NEW.phone),
            NOW());
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_patient_after_delete` AFTER DELETE ON `patient` FOR EACH ROW BEGIN
    INSERT INTO audit_log (table_name, record_id, action, user_id, old_values, created_at)
    VALUES ('patient', OLD.patient_id, 'DELETE', @app_user_id,
            JSON_OBJECT('mrn', OLD.mrn, 'first_name', OLD.first_name, 'last_name', OLD.last_name),
            NOW());
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `patient_address`
--

DROP TABLE IF EXISTS `patient_address`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `patient_address` (
  `patient_address_id` int NOT NULL AUTO_INCREMENT,
  `patient_id` int NOT NULL,
  `line1` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `line2` varchar(150) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `city` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `state` char(2) COLLATE utf8mb4_unicode_ci NOT NULL,
  `zip` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `effective_start` date NOT NULL,
  `effective_end` date DEFAULT NULL,
  `created_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updated_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`patient_address_id`),
  KEY `fk_patient_address_patient` (`patient_id`),
  CONSTRAINT `fk_patient_address_patient` FOREIGN KEY (`patient_id`) REFERENCES `patient` (`patient_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `ck_addr_dates` CHECK (((`effective_end` is null) or (`effective_end` >= `effective_start`)))
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `patient_address`
--

LOCK TABLES `patient_address` WRITE;
/*!40000 ALTER TABLE `patient_address` DISABLE KEYS */;
INSERT INTO `patient_address` VALUES (1,1,'100 Dorm Way',NULL,'Durham','NC','27701','2025-08-20',NULL,'2025-10-11 23:48:20.950','2025-10-11 23:48:20.950'),(2,2,'200 Campus Ave',NULL,'Durham','NC','27701','2025-08-20',NULL,'2025-10-11 23:48:20.950','2025-10-11 23:48:20.950'),(3,3,'300 Quad Rd',NULL,'Durham','NC','27701','2025-08-20',NULL,'2025-10-11 23:48:20.950','2025-10-11 23:48:20.950'),(4,4,'400 Library Ln',NULL,'Durham','NC','27701','2025-08-20',NULL,'2025-10-11 23:48:20.950','2025-10-11 23:48:20.950'),(5,5,'500 Campus Ct',NULL,'Durham','NC','27701','2025-08-20',NULL,'2025-10-16 18:06:01.871','2025-10-16 18:06:01.871'),(6,6,'600 Dorm Dr',NULL,'Durham','NC','27701','2025-08-20',NULL,'2025-10-16 18:06:01.871','2025-10-16 18:06:01.871'),(7,7,'700 University Rd',NULL,'Durham','NC','27701','2025-08-20',NULL,'2025-10-16 18:06:01.871','2025-10-16 18:06:01.871'),(8,8,'800 Research Ln',NULL,'Durham','NC','27701','2025-08-20',NULL,'2025-10-16 18:06:01.871','2025-10-16 18:06:01.871');
/*!40000 ALTER TABLE `patient_address` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `patient_allergy`
--

DROP TABLE IF EXISTS `patient_allergy`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `patient_allergy` (
  `allergy_id` int NOT NULL AUTO_INCREMENT,
  `patient_id` int NOT NULL,
  `substance` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `reaction` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `severity` enum('mild','moderate','severe','unknown') COLLATE utf8mb4_unicode_ci DEFAULT 'unknown',
  `status` enum('active','inactive') COLLATE utf8mb4_unicode_ci DEFAULT 'active',
  `noted_at` datetime(3) NOT NULL,
  `created_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updated_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`allergy_id`),
  KEY `idx_allergy_patient_time` (`patient_id`,`noted_at`),
  CONSTRAINT `fk_allergy_patient` FOREIGN KEY (`patient_id`) REFERENCES `patient` (`patient_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `patient_allergy`
--

LOCK TABLES `patient_allergy` WRITE;
/*!40000 ALTER TABLE `patient_allergy` DISABLE KEYS */;
/*!40000 ALTER TABLE `patient_allergy` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `patient_insurance`
--

DROP TABLE IF EXISTS `patient_insurance`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `patient_insurance` (
  `patient_insurance_id` int NOT NULL AUTO_INCREMENT,
  `patient_id` int NOT NULL,
  `insurance_policy_id` int NOT NULL,
  `is_primary` tinyint(1) NOT NULL DEFAULT '1',
  `effective_start` date NOT NULL,
  `effective_end` date DEFAULT NULL,
  `created_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updated_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`patient_insurance_id`),
  KEY `fk_pi_policy` (`insurance_policy_id`),
  KEY `idx_pi_patient_window` (`patient_id`,`effective_start`,`effective_end`),
  KEY `idx_pi_primary` (`patient_id`,`is_primary`,`effective_start`),
  CONSTRAINT `fk_pi_patient` FOREIGN KEY (`patient_id`) REFERENCES `patient` (`patient_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_pi_policy` FOREIGN KEY (`insurance_policy_id`) REFERENCES `insurance_policy` (`insurance_policy_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `ck_pi_dates` CHECK (((`effective_end` is null) or (`effective_end` >= `effective_start`)))
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `patient_insurance`
--

LOCK TABLES `patient_insurance` WRITE;
/*!40000 ALTER TABLE `patient_insurance` DISABLE KEYS */;
INSERT INTO `patient_insurance` VALUES (1,1,1,1,'2025-08-20',NULL,'2025-10-11 23:48:20.971','2025-10-11 23:48:20.971'),(2,2,1,1,'2025-08-20',NULL,'2025-10-11 23:48:20.971','2025-10-11 23:48:20.971'),(3,3,2,1,'2025-08-20',NULL,'2025-10-11 23:48:20.971','2025-10-11 23:48:20.971'),(4,4,1,1,'2025-08-20',NULL,'2025-10-11 23:48:20.971','2025-10-11 23:48:20.971'),(5,5,3,1,'2025-08-20',NULL,'2025-10-16 18:06:01.982','2025-10-16 18:06:01.982'),(6,6,3,1,'2025-08-20',NULL,'2025-10-16 18:06:01.982','2025-10-16 18:06:01.982'),(7,7,4,1,'2025-08-20',NULL,'2025-10-16 18:06:01.982','2025-10-16 18:06:01.982'),(8,8,3,1,'2025-08-20',NULL,'2025-10-16 18:06:01.982','2025-10-16 18:06:01.982');
/*!40000 ALTER TABLE `patient_insurance` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_pi_primary_no_overlap_bi` BEFORE INSERT ON `patient_insurance` FOR EACH ROW BEGIN
  IF NEW.is_primary THEN
    IF EXISTS (
      SELECT 1 FROM patient_insurance pi
      WHERE pi.patient_id = NEW.patient_id
        AND pi.is_primary = TRUE
        AND (COALESCE(NEW.effective_end, '9999-12-31') >= COALESCE(pi.effective_start, '0001-01-01'))
        AND (COALESCE(pi.effective_end, '9999-12-31') >= COALESCE(NEW.effective_start, '0001-01-01'))
    ) THEN
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Primary insurance periods must not overlap';
    END IF;
  END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_pi_primary_no_overlap_bu` BEFORE UPDATE ON `patient_insurance` FOR EACH ROW BEGIN
  IF NEW.is_primary THEN
    IF EXISTS (
      SELECT 1 FROM patient_insurance pi
      WHERE pi.patient_insurance_id <> OLD.patient_insurance_id
        AND pi.patient_id = NEW.patient_id
        AND pi.is_primary = TRUE
        AND (COALESCE(NEW.effective_end, '9999-12-31') >= COALESCE(pi.effective_start, '0001-01-01'))
        AND (COALESCE(pi.effective_end, '9999-12-31') >= COALESCE(NEW.effective_start, '0001-01-01'))
    ) THEN
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Primary insurance periods must not overlap';
    END IF;
  END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `patient_problem`
--

DROP TABLE IF EXISTS `patient_problem`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `patient_problem` (
  `problem_id` int NOT NULL AUTO_INCREMENT,
  `patient_id` int NOT NULL,
  `code` varchar(40) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `onset_date` date DEFAULT NULL,
  `resolution_date` date DEFAULT NULL,
  `status` enum('active','resolved','inactive') COLLATE utf8mb4_unicode_ci DEFAULT 'active',
  `created_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updated_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`problem_id`),
  KEY `idx_prb_patient_status` (`patient_id`,`status`),
  CONSTRAINT `fk_prb_patient` FOREIGN KEY (`patient_id`) REFERENCES `patient` (`patient_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `ck_prb_dates` CHECK (((`resolution_date` is null) or (`resolution_date` >= `onset_date`)))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `patient_problem`
--

LOCK TABLES `patient_problem` WRITE;
/*!40000 ALTER TABLE `patient_problem` DISABLE KEYS */;
/*!40000 ALTER TABLE `patient_problem` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Table structure for table `payer`
--

DROP TABLE IF EXISTS `payer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `payer` (
  `payer_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`payer_id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payer`
--

LOCK TABLES `payer` WRITE;
/*!40000 ALTER TABLE `payer` DISABLE KEYS */;
INSERT INTO `payer` VALUES (2,'BluePlus'),(1,'Campus Health Plan');
/*!40000 ALTER TABLE `payer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `permission`
--

DROP TABLE IF EXISTS `permission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `permission` (
  `permission_id` int NOT NULL AUTO_INCREMENT,
  `resource` varchar(80) COLLATE utf8mb4_unicode_ci NOT NULL,
  `action` varchar(40) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`permission_id`),
  UNIQUE KEY `uq_perm` (`resource`,`action`)
) ENGINE=InnoDB AUTO_INCREMENT=68 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `permission`
--

LOCK TABLES `permission` WRITE;
/*!40000 ALTER TABLE `permission` DISABLE KEYS */;
INSERT INTO `permission` VALUES (21,'admin','MANAGE_USERS'),(18,'billing','SELECT'),(7,'diagnosis','INSERT'),(6,'diagnosis','SELECT'),(8,'diagnosis','UPDATE'),(19,'inventory','SELECT'),(20,'inventory','UPDATE'),(10,'observation','INSERT'),(9,'observation','SELECT'),(15,'order','INSERT'),(14,'order','SELECT'),(16,'order','UPDATE'),(1,'patient','SELECT'),(2,'patient','UPDATE'),(22,'pharmacy','DISPENSE'),(12,'prescription','INSERT'),(11,'prescription','SELECT'),(13,'prescription','UPDATE'),(17,'result','SELECT'),(4,'visit','INSERT'),(3,'visit','SELECT'),(5,'visit','UPDATE');
/*!40000 ALTER TABLE `permission` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pharmacy_dispense`
--

DROP TABLE IF EXISTS `pharmacy_dispense`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pharmacy_dispense` (
  `dispense_id` int NOT NULL AUTO_INCREMENT,
  `prescription_id` int NOT NULL,
  `dispensed_by_user_id` int NOT NULL,
  `dispensed_qty` decimal(10,2) NOT NULL,
  `dispensed_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `notes` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`dispense_id`),
  KEY `fk_disp_rx` (`prescription_id`),
  KEY `fk_disp_user` (`dispensed_by_user_id`),
  CONSTRAINT `fk_disp_rx` FOREIGN KEY (`prescription_id`) REFERENCES `prescription` (`prescription_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_disp_user` FOREIGN KEY (`dispensed_by_user_id`) REFERENCES `staff_user` (`user_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `pharmacy_dispense_chk_1` CHECK ((`dispensed_qty` > 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pharmacy_dispense`
--

LOCK TABLES `pharmacy_dispense` WRITE;
/*!40000 ALTER TABLE `pharmacy_dispense` DISABLE KEYS */;
/*!40000 ALTER TABLE `pharmacy_dispense` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `prescription`
--

DROP TABLE IF EXISTS `prescription`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `prescription` (
  `prescription_id` int NOT NULL AUTO_INCREMENT,
  `visit_id` int NOT NULL,
  `drug_code` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  `drug_name` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `dose` decimal(10,3) DEFAULT NULL,
  `dose_unit` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `route` varchar(40) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `frequency` varchar(40) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `duration_days` int DEFAULT NULL,
  `quantity` decimal(10,2) DEFAULT NULL,
  `refills` int DEFAULT '0',
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `status` enum('active','completed','canceled') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'active',
  `created_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updated_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`prescription_id`),
  KEY `fk_rx_drug` (`drug_code`),
  KEY `idx_rx_visit` (`visit_id`),
  CONSTRAINT `fk_rx_drug` FOREIGN KEY (`drug_code`) REFERENCES `rx_drug_ref` (`drug_code`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_rx_visit` FOREIGN KEY (`visit_id`) REFERENCES `visit` (`visit_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `ck_rx_dates` CHECK (((`end_date` is null) or (`end_date` >= `start_date`))),
  CONSTRAINT `ck_rx_qty` CHECK (((`quantity` is null) or (`quantity` >= 0)))
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `prescription`
--

LOCK TABLES `prescription` WRITE;
/*!40000 ALTER TABLE `prescription` DISABLE KEYS */;
INSERT INTO `prescription` VALUES (1,1,'RX-001',NULL,500.000,'mg','PO','TID',7,21.00,0,'2025-10-06',NULL,'active','2025-10-11 23:48:21.017','2025-10-11 23:48:21.017'),(2,3,'RX-002',NULL,200.000,'mg','PO','q6h PRN',3,12.00,0,'2025-10-10',NULL,'active','2025-10-11 23:48:21.017','2025-10-11 23:48:21.017'),(3,4,'RX-002',NULL,200.000,'mg','PO','q6h PRN',5,20.00,0,'2025-10-11',NULL,'active','2025-10-16 18:06:02.097','2025-10-16 18:06:02.097'),(4,5,'RX-001',NULL,500.000,'mg','PO','BID',7,14.00,0,'2025-10-12',NULL,'active','2025-10-16 18:06:02.097','2025-10-16 18:06:02.097');
/*!40000 ALTER TABLE `prescription` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_prescription_after_insert` AFTER INSERT ON `prescription` FOR EACH ROW BEGIN
    INSERT INTO audit_log (table_name, record_id, action, user_id, new_values, created_at)
    VALUES ('prescription', NEW.prescription_id, 'INSERT', @app_user_id,
            JSON_OBJECT('visit_id', NEW.visit_id, 'drug_code', NEW.drug_code, 'status', NEW.status),
            NOW());
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_prescription_after_update` AFTER UPDATE ON `prescription` FOR EACH ROW BEGIN
    INSERT INTO audit_log (table_name, record_id, action, user_id, old_values, new_values, created_at)
    VALUES ('prescription', NEW.prescription_id, 'UPDATE', @app_user_id,
            JSON_OBJECT('status', OLD.status, 'quantity', OLD.quantity),
            JSON_OBJECT('status', NEW.status, 'quantity', NEW.quantity),
            NOW());
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `procedure_item`
--

DROP TABLE IF EXISTS `procedure_item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `procedure_item` (
  `procedure_id` int NOT NULL AUTO_INCREMENT,
  `visit_id` int NOT NULL,
  `cpt_code` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `performed_at` datetime(3) NOT NULL,
  `created_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updated_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`procedure_id`),
  KEY `fk_proc_cpt` (`cpt_code`),
  KEY `idx_proc_visit_time` (`visit_id`,`performed_at`),
  CONSTRAINT `fk_proc_cpt` FOREIGN KEY (`cpt_code`) REFERENCES `cpt_ref` (`cpt_code`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_proc_visit` FOREIGN KEY (`visit_id`) REFERENCES `visit` (`visit_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `procedure_item`
--

LOCK TABLES `procedure_item` WRITE;
/*!40000 ALTER TABLE `procedure_item` DISABLE KEYS */;
INSERT INTO `procedure_item` VALUES (1,2,'90471','2025-10-08 09:12:00.000','2025-10-11 23:48:21.047','2025-10-11 23:48:21.047');
/*!40000 ALTER TABLE `procedure_item` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `provider`
--

DROP TABLE IF EXISTS `provider`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `provider` (
  `provider_id` int NOT NULL AUTO_INCREMENT,
  `npi` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `first_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `specialty` varchar(120) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `credentials` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updated_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`provider_id`),
  UNIQUE KEY `npi` (`npi`),
  KEY `idx_provider_name` (`last_name`,`first_name`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `provider`
--

LOCK TABLES `provider` WRITE;
/*!40000 ALTER TABLE `provider` DISABLE KEYS */;
INSERT INTO `provider` VALUES (1,'1111111111','Alice','Nguyen','Family Medicine','MD','2025-10-11 23:48:20.936','2025-10-11 23:48:20.936'),(2,'2222222222','Brian','Lopez','Internal Medicine','DO','2025-10-11 23:48:20.936','2025-10-11 23:48:20.936'),(3,'3333333333','Cathy','Singh','Pediatrics','NP','2025-10-11 23:48:20.936','2025-10-11 23:48:20.936'),(4,'4444444444','David','Kim','Dermatology','MD','2025-10-16 18:06:01.793','2025-10-16 18:06:01.793'),(5,'5555555555','Emily','Johnson','Gynecology','MD','2025-10-16 18:06:01.793','2025-10-16 18:06:01.793');
/*!40000 ALTER TABLE `provider` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `provider_department`
--

DROP TABLE IF EXISTS `provider_department`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `provider_department` (
  `provider_id` int NOT NULL,
  `department_id` int NOT NULL,
  PRIMARY KEY (`provider_id`,`department_id`),
  KEY `fk_pd_department` (`department_id`),
  CONSTRAINT `fk_pd_department` FOREIGN KEY (`department_id`) REFERENCES `department` (`department_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_pd_provider` FOREIGN KEY (`provider_id`) REFERENCES `provider` (`provider_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `provider_department`
--

LOCK TABLES `provider_department` WRITE;
/*!40000 ALTER TABLE `provider_department` DISABLE KEYS */;
INSERT INTO `provider_department` VALUES (1,1),(2,2),(3,3),(4,5),(5,5);
/*!40000 ALTER TABLE `provider_department` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `result`
--

DROP TABLE IF EXISTS `result`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `result` (
  `result_id` int NOT NULL AUTO_INCREMENT,
  `order_id` int NOT NULL,
  `result_code` varchar(40) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `result_text` varchar(400) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `value_num` decimal(12,4) DEFAULT NULL,
  `value_text` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `units` varchar(40) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `abnormal_flag` enum('N','A','H','L','U') COLLATE utf8mb4_unicode_ci DEFAULT 'U',
  `result_date` datetime(3) NOT NULL,
  `created_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updated_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`result_id`),
  KEY `idx_res_order_date` (`order_id`,`result_date`),
  CONSTRAINT `fk_res_order` FOREIGN KEY (`order_id`) REFERENCES `order` (`order_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `result`
--

LOCK TABLES `result` WRITE;
/*!40000 ALTER TABLE `result` DISABLE KEYS */;
INSERT INTO `result` VALUES (1,2,'LDL','LDL-C',NULL,'110 mg/dL',NULL,'N','2025-10-08 11:00:00.000','2025-10-11 23:48:21.039','2025-10-11 23:48:21.039'),(2,2,'HDL','HDL-C',NULL,'55 mg/dL',NULL,'N','2025-10-08 11:00:00.000','2025-10-11 23:48:21.039','2025-10-11 23:48:21.039'),(3,2,'TG','Triglycerides',NULL,'140 mg/dL',NULL,'N','2025-10-08 11:00:00.000','2025-10-11 23:48:21.039','2025-10-11 23:48:21.039'),(4,3,'LDL','LDL-C',NULL,'100 mg/dL',NULL,'N','2025-10-12 13:00:00.000','2025-10-16 18:06:02.151','2025-10-16 18:06:02.151'),(5,3,'HDL','HDL-C',NULL,'60 mg/dL',NULL,'N','2025-10-12 13:00:00.000','2025-10-16 18:06:02.151','2025-10-16 18:06:02.151'),(6,3,'TG','Triglycerides',NULL,'120 mg/dL',NULL,'N','2025-10-12 13:00:00.000','2025-10-16 18:06:02.151','2025-10-16 18:06:02.151');
/*!40000 ALTER TABLE `result` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `role`
--

DROP TABLE IF EXISTS `role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `role` (
  `role_id` int NOT NULL AUTO_INCREMENT,
  `role_name` varchar(80) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`role_id`),
  UNIQUE KEY `role_name` (`role_name`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `role`
--

LOCK TABLES `role` WRITE;
/*!40000 ALTER TABLE `role` DISABLE KEYS */;
INSERT INTO `role` VALUES (1,'Doctor'),(5,'Hospital IT Admin'),(4,'Hospital Manager'),(3,'Hospital Support'),(2,'Nurse'),(8,'Patient'),(6,'Pharmacist'),(7,'Pharmacy Manager');
/*!40000 ALTER TABLE `role` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `role_permission`
--

DROP TABLE IF EXISTS `role_permission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `role_permission` (
  `role_id` int NOT NULL,
  `permission_id` int NOT NULL,
  PRIMARY KEY (`role_id`,`permission_id`),
  KEY `fk_rp_perm` (`permission_id`),
  CONSTRAINT `fk_rp_perm` FOREIGN KEY (`permission_id`) REFERENCES `permission` (`permission_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_rp_role` FOREIGN KEY (`role_id`) REFERENCES `role` (`role_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `role_permission`
--

LOCK TABLES `role_permission` WRITE;
/*!40000 ALTER TABLE `role_permission` DISABLE KEYS */;
INSERT INTO `role_permission` VALUES (1,1),(2,1),(3,1),(4,1),(8,1),(1,3),(2,3),(3,3),(4,3),(8,3),(1,4),(2,4),(1,5),(2,5),(1,6),(4,6),(8,6),(1,7),(1,8),(1,9),(2,9),(4,9),(8,9),(1,10),(2,10),(1,11),(4,11),(6,11),(7,11),(8,11),(1,12),(1,13),(1,14),(2,14),(4,14),(8,14),(1,15),(2,15),(1,16),(2,16),(1,17),(2,17),(4,17),(8,17),(1,18),(4,18),(8,18),(6,19),(7,19),(7,20),(5,21),(6,22),(7,22);
/*!40000 ALTER TABLE `role_permission` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rx_drug_ref`
--

DROP TABLE IF EXISTS `rx_drug_ref`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rx_drug_ref` (
  `drug_code` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  `drug_name` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`drug_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rx_drug_ref`
--

LOCK TABLES `rx_drug_ref` WRITE;
/*!40000 ALTER TABLE `rx_drug_ref` DISABLE KEYS */;
INSERT INTO `rx_drug_ref` VALUES ('RX-001','Amoxicillin 500 mg cap'),('RX-002','Ibuprofen 200 mg tab');
/*!40000 ALTER TABLE `rx_drug_ref` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `staff_department`
--

DROP TABLE IF EXISTS `staff_department`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `staff_department` (
  `user_id` int NOT NULL,
  `department_id` int NOT NULL,
  PRIMARY KEY (`user_id`,`department_id`),
  KEY `fk_sd_department` (`department_id`),
  CONSTRAINT `fk_sd_department` FOREIGN KEY (`department_id`) REFERENCES `department` (`department_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_sd_user` FOREIGN KEY (`user_id`) REFERENCES `staff_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `staff_department`
--

LOCK TABLES `staff_department` WRITE;
/*!40000 ALTER TABLE `staff_department` DISABLE KEYS */;
INSERT INTO `staff_department` VALUES (10,4),(11,4),(12,5),(13,6),(14,7),(15,7);
/*!40000 ALTER TABLE `staff_department` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `staff_user`
--

DROP TABLE IF EXISTS `staff_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `staff_user` (
  `user_id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `display_name` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updated_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=68 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `staff_user`
--

LOCK TABLES `staff_user` WRITE;
/*!40000 ALTER TABLE `staff_user` DISABLE KEYS */;
INSERT INTO `staff_user` VALUES (1,'test','Test Test',1,'2025-10-11 23:48:20.906','2025-12-02 03:24:56.900'),(2,'nurse1','Nurse One',1,'2025-10-11 23:48:20.906','2025-10-11 23:48:20.906'),(3,'doc1','Doctor One',1,'2025-10-11 23:48:20.906','2025-10-11 23:48:20.906'),(4,'nurse2','Nurse Two',1,'2025-10-16 18:06:01.758','2025-10-16 18:06:01.758'),(5,'doc2','Doctor Two',1,'2025-10-16 18:06:01.758','2025-10-16 18:06:01.758'),(6,'doc_amy','Dr. Amy Carter',1,'2025-11-10 21:28:27.770','2025-12-01 22:18:54.561'),(7,'doc_ben','Dr. Ben Ortiz',1,'2025-11-10 21:28:27.770','2025-11-10 21:28:27.770'),(8,'nurse_cara','Nurse Cara Patel',1,'2025-11-10 21:28:27.770','2025-11-10 21:28:27.770'),(9,'nurse_dan','Nurse Dan Moore',1,'2025-11-10 21:28:27.770','2025-11-10 21:28:27.770'),(10,'support_ella','Support Ella Kim',1,'2025-11-10 21:28:27.770','2025-11-10 21:28:27.770'),(11,'support_fred','Support Fred Zhou',1,'2025-11-10 21:28:27.770','2025-11-10 21:28:27.770'),(12,'manager_gina','Manager Gina Ross',1,'2025-11-10 21:28:27.770','2025-11-10 21:28:27.770'),(13,'itadmin_hank','IT Admin Hank Lee',1,'2025-11-10 21:28:27.770','2025-11-10 21:28:27.770'),(14,'pharm_ivy','Pharmacist Ivy Rao',1,'2025-11-10 21:28:27.770','2025-11-10 21:28:27.770'),(15,'pharm_mgr_jack','Pharmacy Manager Jack Wu',1,'2025-11-10 21:28:27.770','2025-11-10 21:28:27.770'),(16,'patient_kim','Kim Allen (Portal)',1,'2025-11-10 21:28:27.770','2025-11-10 21:28:27.770'),(17,'patient_lee','Lee Baker (Portal)',1,'2025-11-10 21:28:27.770','2025-11-10 21:28:27.770'),(18,'patient_mia','Mia Clark (Portal)',1,'2025-11-10 21:28:27.770','2025-11-10 21:28:27.770'),(19,'patient_noah','Noah Davis (Portal)',1,'2025-11-10 21:28:27.770','2025-11-10 21:28:27.770'),(20,'patient_olivia','Olivia Evans (Portal)',1,'2025-11-10 21:28:27.770','2025-11-10 21:28:27.770'),(21,'patient_paul','Paul Foster (Portal)',1,'2025-11-10 21:28:27.770','2025-11-10 21:28:27.770'),(22,'patient_quinn','Quinn Garcia (Portal)',1,'2025-11-10 21:28:27.770','2025-11-10 21:28:27.770'),(23,'patient_ria','Ria Hughes (Portal)',1,'2025-11-10 21:28:27.770','2025-11-10 21:28:27.770'),(24,'patient_sam','Sam Ibrahim (Portal)',1,'2025-11-10 21:28:27.770','2025-11-10 21:28:27.770'),(25,'patient_tom','Tom Jones (Portal)',1,'2025-11-10 21:28:27.770','2025-11-10 21:28:27.770'),(67,'TestF','TestF TestL',1,'2025-12-05 00:12:48.998','2025-12-05 00:12:48.999');
/*!40000 ALTER TABLE `staff_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `supply`
--

DROP TABLE IF EXISTS `supply`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `supply` (
  `supply_id` int NOT NULL AUTO_INCREMENT,
  `sku` varchar(40) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL,
  `lot` varchar(60) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `expiry` date DEFAULT NULL,
  `unit_cost` decimal(10,2) NOT NULL DEFAULT '0.00',
  `on_hand_qty` int NOT NULL DEFAULT '0',
  `created_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updated_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`supply_id`),
  UNIQUE KEY `sku` (`sku`),
  CONSTRAINT `ck_supply_qty` CHECK ((`on_hand_qty` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `supply`
--

LOCK TABLES `supply` WRITE;
/*!40000 ALTER TABLE `supply` DISABLE KEYS */;
INSERT INTO `supply` VALUES (1,'SWAB-01','Throat swab','LOT1','2026-12-31',0.50,200,'2025-10-11 23:48:21.071','2025-10-11 23:48:21.071'),(2,'GLOV-M','Exam gloves M','LOT2','2027-06-30',0.10,500,'2025-10-11 23:48:21.071','2025-10-11 23:48:21.071'),(3,'MASK-N95','N95 Mask','LOT3','2026-05-31',2.00,100,'2025-10-16 18:06:02.224','2025-10-16 18:06:02.224'),(4,'SANITIZER','Hand Sanitizer','LOT4','2026-12-31',3.00,50,'2025-10-16 18:06:02.224','2025-10-16 18:06:02.224');
/*!40000 ALTER TABLE `supply` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_supply_low_after_update` AFTER UPDATE ON `supply` FOR EACH ROW BEGIN
  IF NEW.on_hand_qty < 10 THEN
    SIGNAL SQLSTATE '01000' SET MESSAGE_TEXT = 'Warning: supply on_hand_qty below threshold';
  END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `supply_movement`
--

DROP TABLE IF EXISTS `supply_movement`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `supply_movement` (
  `movement_id` int NOT NULL AUTO_INCREMENT,
  `supply_id` int NOT NULL,
  `visit_id` int DEFAULT NULL,
  `quantity_change` int NOT NULL,
  `reason` enum('purchase','consume','adjust') COLLATE utf8mb4_unicode_ci NOT NULL,
  `moved_at` datetime(3) NOT NULL,
  `created_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updated_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`movement_id`),
  KEY `fk_mov_visit` (`visit_id`),
  KEY `idx_mov_supply_time` (`supply_id`,`moved_at`),
  CONSTRAINT `fk_mov_supply` FOREIGN KEY (`supply_id`) REFERENCES `supply` (`supply_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_mov_visit` FOREIGN KEY (`visit_id`) REFERENCES `visit` (`visit_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `ck_mov_qty` CHECK ((`quantity_change` <> 0))
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `supply_movement`
--

LOCK TABLES `supply_movement` WRITE;
/*!40000 ALTER TABLE `supply_movement` DISABLE KEYS */;
INSERT INTO `supply_movement` VALUES (1,1,1,-1,'consume','2025-10-06 14:06:00.000','2025-10-11 23:48:21.078','2025-10-11 23:48:21.078'),(2,2,1,-2,'consume','2025-10-06 14:06:00.000','2025-10-11 23:48:21.078','2025-10-11 23:48:21.078'),(3,3,NULL,100,'purchase','2025-10-09 08:00:00.000','2025-10-16 18:06:02.261','2025-10-16 18:06:02.261'),(4,4,NULL,50,'purchase','2025-10-09 08:00:00.000','2025-10-16 18:06:02.261','2025-10-16 18:06:02.261'),(5,2,4,-2,'consume','2025-10-11 09:05:00.000','2025-10-16 18:06:02.261','2025-10-16 18:06:02.261'),(6,1,4,-1,'consume','2025-10-11 09:05:00.000','2025-10-16 18:06:02.261','2025-10-16 18:06:02.261'),(7,2,5,-1,'consume','2025-10-12 10:05:00.000','2025-10-16 18:06:02.261','2025-10-16 18:06:02.261');
/*!40000 ALTER TABLE `supply_movement` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_auth`
--

DROP TABLE IF EXISTS `user_auth`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_auth` (
  `user_id` int NOT NULL,
  `email` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `password_hash` char(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updated_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `email` (`email`),
  CONSTRAINT `fk_userauth_user` FOREIGN KEY (`user_id`) REFERENCES `staff_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_auth`
--

LOCK TABLES `user_auth` WRITE;
/*!40000 ALTER TABLE `user_auth` DISABLE KEYS */;
INSERT INTO `user_auth` VALUES (1,'test@test.com','ce5dfef604343236fe0979e3b081999280d68ca108b7c9ea4797b9de06c2786c',1,'2025-12-02 03:24:56.910','2025-12-02 03:24:56.910'),(6,'doc_amy@example.org','ce5dfef604343236fe0979e3b081999280d68ca108b7c9ea4797b9de06c2786c',1,'2025-11-10 21:28:27.776','2025-12-02 03:15:45.585'),(7,'doc_ben@example.org','ce5dfef604343236fe0979e3b081999280d68ca108b7c9ea4797b9de06c2786c',1,'2025-11-10 21:28:27.776','2025-11-10 21:28:27.776'),(8,'nurse_cara@example.org','ce5dfef604343236fe0979e3b081999280d68ca108b7c9ea4797b9de06c2786c',1,'2025-11-10 21:28:27.776','2025-11-10 21:28:27.776'),(9,'nurse_dan@example.org','ce5dfef604343236fe0979e3b081999280d68ca108b7c9ea4797b9de06c2786c',1,'2025-11-10 21:28:27.776','2025-11-10 21:28:27.776'),(10,'support_ella@example.org','ce5dfef604343236fe0979e3b081999280d68ca108b7c9ea4797b9de06c2786c',1,'2025-11-10 21:28:27.776','2025-11-10 21:28:27.776'),(11,'support_fred@example.org','ce5dfef604343236fe0979e3b081999280d68ca108b7c9ea4797b9de06c2786c',1,'2025-11-10 21:28:27.776','2025-11-10 21:28:27.776'),(12,'manager_gina@example.org','ce5dfef604343236fe0979e3b081999280d68ca108b7c9ea4797b9de06c2786c',1,'2025-11-10 21:28:27.776','2025-11-10 21:28:27.776'),(13,'itadmin_hank@example.org','ce5dfef604343236fe0979e3b081999280d68ca108b7c9ea4797b9de06c2786c',1,'2025-11-10 21:28:27.776','2025-11-10 21:28:27.776'),(14,'pharm_ivy@example.org','ce5dfef604343236fe0979e3b081999280d68ca108b7c9ea4797b9de06c2786c',1,'2025-11-10 21:28:27.776','2025-11-10 21:28:27.776'),(15,'pharm_mgr_jack@example.org','ce5dfef604343236fe0979e3b081999280d68ca108b7c9ea4797b9de06c2786c',1,'2025-11-10 21:28:27.776','2025-11-10 21:28:27.776'),(16,'patient_kim@example.org','ce5dfef604343236fe0979e3b081999280d68ca108b7c9ea4797b9de06c2786c',1,'2025-11-10 21:28:27.776','2025-11-10 21:28:27.776'),(17,'patient_lee@example.org','ce5dfef604343236fe0979e3b081999280d68ca108b7c9ea4797b9de06c2786c',1,'2025-11-10 21:28:27.776','2025-11-10 21:28:27.776'),(18,'patient_mia@example.org','ce5dfef604343236fe0979e3b081999280d68ca108b7c9ea4797b9de06c2786c',1,'2025-11-10 21:28:27.776','2025-11-10 21:28:27.776'),(19,'patient_noah@example.org','ce5dfef604343236fe0979e3b081999280d68ca108b7c9ea4797b9de06c2786c',1,'2025-11-10 21:28:27.776','2025-11-10 21:28:27.776'),(20,'patient_olivia@example.org','ce5dfef604343236fe0979e3b081999280d68ca108b7c9ea4797b9de06c2786c',1,'2025-11-10 21:28:27.776','2025-11-10 21:28:27.776'),(21,'patient_paul@example.org','ce5dfef604343236fe0979e3b081999280d68ca108b7c9ea4797b9de06c2786c',1,'2025-11-10 21:28:27.776','2025-11-10 21:28:27.776'),(22,'patient_quinn@example.org','ce5dfef604343236fe0979e3b081999280d68ca108b7c9ea4797b9de06c2786c',1,'2025-11-10 21:28:27.776','2025-11-10 21:28:27.776'),(23,'patient_ria@example.org','ce5dfef604343236fe0979e3b081999280d68ca108b7c9ea4797b9de06c2786c',1,'2025-11-10 21:28:27.776','2025-11-10 21:28:27.776'),(24,'patient_sam@example.org','ce5dfef604343236fe0979e3b081999280d68ca108b7c9ea4797b9de06c2786c',1,'2025-11-10 21:28:27.776','2025-11-10 21:28:27.776'),(25,'patient_tom@example.org','ce5dfef604343236fe0979e3b081999280d68ca108b7c9ea4797b9de06c2786c',1,'2025-11-10 21:28:27.776','2025-11-10 21:28:27.776'),(67,'TestF@testL.com','ce5dfef604343236fe0979e3b081999280d68ca108b7c9ea4797b9de06c2786c',1,'2025-12-05 00:12:49.706','2025-12-05 00:12:49.706');
/*!40000 ALTER TABLE `user_auth` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_patient_link`
--

DROP TABLE IF EXISTS `user_patient_link`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_patient_link` (
  `user_id` int NOT NULL,
  `patient_id` int NOT NULL,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `patient_id` (`patient_id`),
  CONSTRAINT `fk_upl_patient` FOREIGN KEY (`patient_id`) REFERENCES `patient` (`patient_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_upl_user` FOREIGN KEY (`user_id`) REFERENCES `staff_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_patient_link`
--

LOCK TABLES `user_patient_link` WRITE;
/*!40000 ALTER TABLE `user_patient_link` DISABLE KEYS */;
INSERT INTO `user_patient_link` VALUES (16,5),(17,6),(18,7),(19,8),(20,9),(21,10),(22,11),(23,12),(24,13),(25,14);
/*!40000 ALTER TABLE `user_patient_link` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_role`
--

DROP TABLE IF EXISTS `user_role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_role` (
  `user_id` int NOT NULL,
  `role_id` int NOT NULL,
  PRIMARY KEY (`user_id`,`role_id`),
  KEY `fk_ur_role` (`role_id`),
  CONSTRAINT `fk_ur_role` FOREIGN KEY (`role_id`) REFERENCES `role` (`role_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_ur_user` FOREIGN KEY (`user_id`) REFERENCES `staff_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_role`
--

LOCK TABLES `user_role` WRITE;
/*!40000 ALTER TABLE `user_role` DISABLE KEYS */;
INSERT INTO `user_role` VALUES (6,1),(7,1),(8,2),(9,2),(10,3),(11,3),(12,4),(13,5),(14,6),(15,7),(16,8),(17,8),(18,8),(19,8),(20,8),(21,8),(22,8),(23,8),(24,8),(25,8);
/*!40000 ALTER TABLE `user_role` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Table structure for table `visit`
--

DROP TABLE IF EXISTS `visit`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `visit` (
  `visit_id` int NOT NULL AUTO_INCREMENT,
  `patient_id` int NOT NULL,
  `provider_id` int NOT NULL,
  `appointment_id` int DEFAULT NULL,
  `exam_room_id` int DEFAULT NULL,
  `check_in_time` datetime(3) NOT NULL,
  `check_out_time` datetime(3) DEFAULT NULL,
  `status` enum('in_progress','completed','canceled') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'in_progress',
  `chief_complaint` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `reason` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `discharge_disposition` enum('home','specialist_referral','ed_referral','other') COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `discharge_notes` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updated_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`visit_id`),
  KEY `fk_visit_appt` (`appointment_id`),
  KEY `fk_visit_exam_room` (`exam_room_id`),
  KEY `idx_visit_provider_time` (`provider_id`,`check_in_time`),
  KEY `idx_visit_patient_time` (`patient_id`,`check_in_time`),
  KEY `idx_visit_date` (`check_in_time`),
  CONSTRAINT `fk_visit_appt` FOREIGN KEY (`appointment_id`) REFERENCES `appointment` (`appointment_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_visit_exam_room` FOREIGN KEY (`exam_room_id`) REFERENCES `exam_room` (`exam_room_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_visit_patient` FOREIGN KEY (`patient_id`) REFERENCES `patient` (`patient_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_visit_provider` FOREIGN KEY (`provider_id`) REFERENCES `provider` (`provider_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `ck_visit_time` CHECK (((`check_out_time` is null) or (`check_out_time` > `check_in_time`)))
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `visit`
--

LOCK TABLES `visit` WRITE;
/*!40000 ALTER TABLE `visit` DISABLE KEYS */;
INSERT INTO `visit` VALUES (1,1,1,1,1,'2025-10-06 14:02:00.000','2025-10-06 14:18:00.000','completed',NULL,'Sore throat','home','Return if not improved','2025-10-11 23:48:20.993','2025-10-11 23:48:20.993'),(2,2,2,2,2,'2025-10-08 09:01:00.000','2025-10-08 09:22:00.000','completed',NULL,'Annual physical','home','Labs reviewed','2025-10-11 23:48:20.993','2025-10-11 23:48:20.993'),(3,1,1,3,1,'2025-10-10 10:03:00.000','2025-10-10 10:18:00.000','completed',NULL,'Follow-up','home','Symptom improved','2025-10-11 23:48:20.993','2025-10-11 23:48:20.993'),(4,5,4,5,1,'2025-10-11 09:05:00.000','2025-10-11 09:18:00.000','completed',NULL,'Skin rash','home','Topical cream recommended','2025-10-16 18:06:02.050','2025-10-16 18:06:02.050'),(5,6,5,6,2,'2025-10-12 10:05:00.000','2025-10-12 10:25:00.000','completed',NULL,'Annual gynecological exam','home','Routine check, no issues','2025-10-16 18:06:02.050','2025-10-16 18:06:02.050');
/*!40000 ALTER TABLE `visit` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_visit_after_insert` AFTER INSERT ON `visit` FOR EACH ROW BEGIN
    INSERT INTO audit_log (table_name, record_id, action, user_id, new_values, created_at)
    VALUES ('visit', NEW.visit_id, 'INSERT', @app_user_id,
            JSON_OBJECT('patient_id', NEW.patient_id, 'provider_id', NEW.provider_id, 'status', NEW.status),
            NOW());
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_visit_after_update` AFTER UPDATE ON `visit` FOR EACH ROW BEGIN
    INSERT INTO audit_log (table_name, record_id, action, user_id, old_values, new_values, created_at)
    VALUES ('visit', NEW.visit_id, 'UPDATE', @app_user_id,
            JSON_OBJECT('status', OLD.status, 'check_out_time', OLD.check_out_time),
            JSON_OBJECT('status', NEW.status, 'check_out_time', NEW.check_out_time),
            NOW());
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

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
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-12-04 21:26:41
