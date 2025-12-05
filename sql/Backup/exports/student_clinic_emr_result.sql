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
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-12-03  9:04:54
