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
-- Table structure for table `billing_line`
--

DROP TABLE IF EXISTS `billing_line`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `billing_line` (
  `billing_line_id` int NOT NULL AUTO_INCREMENT,
  `visit_id` int NOT NULL,
  `cpt_code` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `units` int NOT NULL DEFAULT '1',
  `unit_price` decimal(10,2) NOT NULL DEFAULT '0.00',
  `amount` decimal(12,2) GENERATED ALWAYS AS ((`units` * `unit_price`)) STORED,
  `payer_id` int DEFAULT NULL,
  `claim_status` enum('pending','submitted','paid','denied','adjusted') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  `billed_date` date DEFAULT NULL,
  `paid_amount` decimal(10,2) NOT NULL DEFAULT '0.00',
  `created_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updated_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`billing_line_id`),
  KEY `fk_bill_payer` (`payer_id`),
  KEY `fk_bill_cpt` (`cpt_code`),
  KEY `idx_bill_visit` (`visit_id`),
  KEY `idx_bill_status` (`claim_status`),
  CONSTRAINT `fk_bill_cpt` FOREIGN KEY (`cpt_code`) REFERENCES `cpt_ref` (`cpt_code`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_bill_payer` FOREIGN KEY (`payer_id`) REFERENCES `payer` (`payer_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_bill_visit` FOREIGN KEY (`visit_id`) REFERENCES `visit` (`visit_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `ck_paid` CHECK ((`paid_amount` >= 0)),
  CONSTRAINT `ck_price` CHECK ((`unit_price` >= 0)),
  CONSTRAINT `ck_units` CHECK ((`units` > 0))
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `billing_line`
--

LOCK TABLES `billing_line` WRITE;
/*!40000 ALTER TABLE `billing_line` DISABLE KEYS */;
INSERT INTO `billing_line` (`billing_line_id`, `visit_id`, `cpt_code`, `units`, `unit_price`, `payer_id`, `claim_status`, `billed_date`, `paid_amount`, `created_at`, `updated_at`) VALUES (1,1,'87880',1,25.00,1,'submitted','2025-10-06',0.00,'2025-10-11 23:48:21.063','2025-10-11 23:48:21.063'),(2,1,'99213',1,95.00,1,'submitted','2025-10-06',0.00,'2025-10-11 23:48:21.063','2025-10-11 23:48:21.063'),(3,2,'99395',1,140.00,1,'paid','2025-10-08',140.00,'2025-10-11 23:48:21.063','2025-10-11 23:48:21.063'),(4,3,'99212',1,70.00,1,'pending','2025-10-10',0.00,'2025-10-11 23:48:21.063','2025-10-11 23:48:21.063'),(5,4,'99212',1,75.00,1,'submitted','2025-10-11',0.00,'2025-10-16 18:06:02.186','2025-10-16 18:06:02.186'),(6,5,'99395',1,140.00,2,'pending','2025-10-12',0.00,'2025-10-16 18:06:02.186','2025-10-16 18:06:02.186');
/*!40000 ALTER TABLE `billing_line` ENABLE KEYS */;
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
