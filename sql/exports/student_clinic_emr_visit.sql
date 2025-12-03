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
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-12-03  9:04:55
