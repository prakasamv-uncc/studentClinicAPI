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
-- Table structure for table `audit_log`
--

DROP TABLE IF EXISTS `audit_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `audit_log` (
  `audit_id` int NOT NULL AUTO_INCREMENT,
  `table_name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `record_id` int NOT NULL,
  `action` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` int DEFAULT NULL,
  `username` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `old_values` text COLLATE utf8mb4_unicode_ci,
  `new_values` text COLLATE utf8mb4_unicode_ci,
  `ip_address` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_agent` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
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
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-12-03  9:04:57
