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
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-12-03  9:04:55
