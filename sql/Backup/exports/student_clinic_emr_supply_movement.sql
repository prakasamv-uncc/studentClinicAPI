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
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-12-03  9:04:48
