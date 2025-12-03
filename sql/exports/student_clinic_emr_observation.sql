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
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-12-03  9:04:57
