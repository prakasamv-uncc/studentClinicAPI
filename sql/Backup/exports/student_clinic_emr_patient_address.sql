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
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-12-03  9:04:53
