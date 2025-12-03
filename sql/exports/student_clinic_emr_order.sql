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
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-12-03  9:04:47
