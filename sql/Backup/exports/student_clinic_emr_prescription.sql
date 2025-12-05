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
-- Table structure for table `prescription`
--

DROP TABLE IF EXISTS `prescription`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `prescription` (
  `prescription_id` int NOT NULL AUTO_INCREMENT,
  `visit_id` int NOT NULL,
  `drug_code` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  `drug_name` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `dose` decimal(10,3) DEFAULT NULL,
  `dose_unit` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `route` varchar(40) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `frequency` varchar(40) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `duration_days` int DEFAULT NULL,
  `quantity` decimal(10,2) DEFAULT NULL,
  `refills` int DEFAULT '0',
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `status` enum('active','completed','canceled') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'active',
  `created_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updated_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`prescription_id`),
  KEY `fk_rx_drug` (`drug_code`),
  KEY `idx_rx_visit` (`visit_id`),
  CONSTRAINT `fk_rx_drug` FOREIGN KEY (`drug_code`) REFERENCES `rx_drug_ref` (`drug_code`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_rx_visit` FOREIGN KEY (`visit_id`) REFERENCES `visit` (`visit_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `ck_rx_dates` CHECK (((`end_date` is null) or (`end_date` >= `start_date`))),
  CONSTRAINT `ck_rx_qty` CHECK (((`quantity` is null) or (`quantity` >= 0)))
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `prescription`
--

LOCK TABLES `prescription` WRITE;
/*!40000 ALTER TABLE `prescription` DISABLE KEYS */;
INSERT INTO `prescription` VALUES (1,1,'RX-001',NULL,500.000,'mg','PO','TID',7,21.00,0,'2025-10-06',NULL,'active','2025-10-11 23:48:21.017','2025-10-11 23:48:21.017'),(2,3,'RX-002',NULL,200.000,'mg','PO','q6h PRN',3,12.00,0,'2025-10-10',NULL,'active','2025-10-11 23:48:21.017','2025-10-11 23:48:21.017'),(3,4,'RX-002',NULL,200.000,'mg','PO','q6h PRN',5,20.00,0,'2025-10-11',NULL,'active','2025-10-16 18:06:02.097','2025-10-16 18:06:02.097'),(4,5,'RX-001',NULL,500.000,'mg','PO','BID',7,14.00,0,'2025-10-12',NULL,'active','2025-10-16 18:06:02.097','2025-10-16 18:06:02.097');
/*!40000 ALTER TABLE `prescription` ENABLE KEYS */;
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_prescription_after_insert` AFTER INSERT ON `prescription` FOR EACH ROW BEGIN
    INSERT INTO audit_log (table_name, record_id, action, user_id, new_values, created_at)
    VALUES ('prescription', NEW.prescription_id, 'INSERT', @app_user_id,
            JSON_OBJECT('visit_id', NEW.visit_id, 'drug_code', NEW.drug_code, 'status', NEW.status),
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_prescription_after_update` AFTER UPDATE ON `prescription` FOR EACH ROW BEGIN
    INSERT INTO audit_log (table_name, record_id, action, user_id, old_values, new_values, created_at)
    VALUES ('prescription', NEW.prescription_id, 'UPDATE', @app_user_id,
            JSON_OBJECT('status', OLD.status, 'quantity', OLD.quantity),
            JSON_OBJECT('status', NEW.status, 'quantity', NEW.quantity),
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

-- Dump completed on 2025-12-03  9:04:51
