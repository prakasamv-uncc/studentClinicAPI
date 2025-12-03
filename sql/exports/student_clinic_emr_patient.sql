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
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-12-03  9:04:56
