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
) ENGINE=InnoDB AUTO_INCREMENT=67 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `staff_user`
--

LOCK TABLES `staff_user` WRITE;
/*!40000 ALTER TABLE `staff_user` DISABLE KEYS */;
INSERT INTO `staff_user` VALUES (1,'test','Test Test',1,'2025-10-11 23:48:20.906','2025-12-02 03:24:56.900'),(2,'nurse1','Nurse One',1,'2025-10-11 23:48:20.906','2025-10-11 23:48:20.906'),(3,'doc1','Doctor One',1,'2025-10-11 23:48:20.906','2025-10-11 23:48:20.906'),(4,'nurse2','Nurse Two',1,'2025-10-16 18:06:01.758','2025-10-16 18:06:01.758'),(5,'doc2','Doctor Two',1,'2025-10-16 18:06:01.758','2025-10-16 18:06:01.758'),(6,'doc_amy','Dr. Amy Carter',1,'2025-11-10 21:28:27.770','2025-12-01 22:18:54.561'),(7,'doc_ben','Dr. Ben Ortiz',1,'2025-11-10 21:28:27.770','2025-11-10 21:28:27.770'),(8,'nurse_cara','Nurse Cara Patel',1,'2025-11-10 21:28:27.770','2025-11-10 21:28:27.770'),(9,'nurse_dan','Nurse Dan Moore',1,'2025-11-10 21:28:27.770','2025-11-10 21:28:27.770'),(10,'support_ella','Support Ella Kim',1,'2025-11-10 21:28:27.770','2025-11-10 21:28:27.770'),(11,'support_fred','Support Fred Zhou',1,'2025-11-10 21:28:27.770','2025-11-10 21:28:27.770'),(12,'manager_gina','Manager Gina Ross',1,'2025-11-10 21:28:27.770','2025-11-10 21:28:27.770'),(13,'itadmin_hank','IT Admin Hank Lee',1,'2025-11-10 21:28:27.770','2025-11-10 21:28:27.770'),(14,'pharm_ivy','Pharmacist Ivy Rao',1,'2025-11-10 21:28:27.770','2025-11-10 21:28:27.770'),(15,'pharm_mgr_jack','Pharmacy Manager Jack Wu',1,'2025-11-10 21:28:27.770','2025-11-10 21:28:27.770'),(16,'patient_kim','Kim Allen (Portal)',1,'2025-11-10 21:28:27.770','2025-11-10 21:28:27.770'),(17,'patient_lee','Lee Baker (Portal)',1,'2025-11-10 21:28:27.770','2025-11-10 21:28:27.770'),(18,'patient_mia','Mia Clark (Portal)',1,'2025-11-10 21:28:27.770','2025-11-10 21:28:27.770'),(19,'patient_noah','Noah Davis (Portal)',1,'2025-11-10 21:28:27.770','2025-11-10 21:28:27.770'),(20,'patient_olivia','Olivia Evans (Portal)',1,'2025-11-10 21:28:27.770','2025-11-10 21:28:27.770'),(21,'patient_paul','Paul Foster (Portal)',1,'2025-11-10 21:28:27.770','2025-11-10 21:28:27.770'),(22,'patient_quinn','Quinn Garcia (Portal)',1,'2025-11-10 21:28:27.770','2025-11-10 21:28:27.770'),(23,'patient_ria','Ria Hughes (Portal)',1,'2025-11-10 21:28:27.770','2025-11-10 21:28:27.770'),(24,'patient_sam','Sam Ibrahim (Portal)',1,'2025-11-10 21:28:27.770','2025-11-10 21:28:27.770'),(25,'patient_tom','Tom Jones (Portal)',1,'2025-11-10 21:28:27.770','2025-11-10 21:28:27.770');
/*!40000 ALTER TABLE `staff_user` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-12-03  9:04:55
