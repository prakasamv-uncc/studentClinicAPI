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
-- Table structure for table `appointment`
--

DROP TABLE IF EXISTS `appointment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `appointment` (
  `appointment_id` int NOT NULL AUTO_INCREMENT,
  `patient_id` int NOT NULL,
  `provider_id` int NOT NULL,
  `exam_room_id` int DEFAULT NULL,
  `scheduled_start` datetime(3) NOT NULL,
  `scheduled_end` datetime(3) NOT NULL,
  `status` enum('scheduled','checked_in','no_show','canceled','completed') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'scheduled',
  `reason` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updated_at` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`appointment_id`),
  KEY `idx_appt_provider_time` (`provider_id`,`scheduled_start`),
  KEY `idx_appt_patient_time` (`patient_id`,`scheduled_start`),
  KEY `idx_appt_room_time` (`exam_room_id`,`scheduled_start`,`scheduled_end`),
  CONSTRAINT `fk_appt_exam_room` FOREIGN KEY (`exam_room_id`) REFERENCES `exam_room` (`exam_room_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_appt_patient` FOREIGN KEY (`patient_id`) REFERENCES `patient` (`patient_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_appt_provider` FOREIGN KEY (`provider_id`) REFERENCES `provider` (`provider_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `ck_appt_time` CHECK ((`scheduled_end` > `scheduled_start`))
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `appointment`
--

LOCK TABLES `appointment` WRITE;
/*!40000 ALTER TABLE `appointment` DISABLE KEYS */;
INSERT INTO `appointment` VALUES (1,1,1,1,'2025-10-06 14:00:00.000','2025-10-06 14:20:00.000','completed','Sore throat','2025-10-11 23:48:20.978','2025-10-11 23:48:20.978'),(2,2,2,2,'2025-10-08 09:00:00.000','2025-10-08 09:20:00.000','completed','Annual physical','2025-10-11 23:48:20.978','2025-10-11 23:48:20.978'),(3,1,1,1,'2025-10-10 10:00:00.000','2025-10-10 10:20:00.000','completed','Follow-up','2025-10-11 23:48:20.978','2025-10-11 23:48:20.978'),(4,3,3,1,'2025-10-10 11:00:00.000','2025-10-10 11:20:00.000','scheduled','Flu shot','2025-10-11 23:48:20.978','2025-10-11 23:48:20.978'),(5,5,4,1,'2025-10-11 09:00:00.000','2025-10-11 09:20:00.000','completed','Skin rash','2025-10-16 18:06:02.034','2025-10-16 18:06:02.034'),(6,6,5,2,'2025-10-12 10:00:00.000','2025-10-12 10:20:00.000','completed','Annual gynecological exam','2025-10-16 18:06:02.034','2025-10-16 18:06:02.034'),(7,7,4,1,'2025-10-13 11:00:00.000','2025-10-13 11:20:00.000','scheduled','Follow-up visit','2025-10-16 18:06:02.034','2025-10-16 18:06:02.034'),(8,8,5,2,'2025-10-14 13:00:00.000','2025-10-14 13:20:00.000','scheduled','Birth control consultation','2025-10-16 18:06:02.034','2025-10-16 18:06:02.034'),(9,5,4,1,'2025-10-15 14:00:00.000','2025-10-15 14:20:00.000','scheduled','Rash follow-up','2025-10-16 18:06:02.034','2025-10-16 18:06:02.034');
/*!40000 ALTER TABLE `appointment` ENABLE KEYS */;
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_appt_no_overlap_bi` BEFORE INSERT ON `appointment` FOR EACH ROW BEGIN
  IF NEW.exam_room_id IS NOT NULL THEN
    IF EXISTS (
      SELECT 1 FROM appointment a
      WHERE a.exam_room_id = NEW.exam_room_id
        AND a.status IN ('scheduled','checked_in','completed')
        AND NOT (NEW.scheduled_end <= a.scheduled_start OR NEW.scheduled_start >= a.scheduled_end)
    ) THEN
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Appointment overlaps existing booking in this exam room';
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_appt_no_overlap_bu` BEFORE UPDATE ON `appointment` FOR EACH ROW BEGIN
  IF NEW.exam_room_id IS NOT NULL THEN
    IF EXISTS (
      SELECT 1 FROM appointment a
      WHERE a.appointment_id <> OLD.appointment_id
        AND a.exam_room_id = NEW.exam_room_id
        AND a.status IN ('scheduled','checked_in','completed')
        AND NOT (NEW.scheduled_end <= a.scheduled_start OR NEW.scheduled_start >= a.scheduled_end)
    ) THEN
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Appointment overlaps existing booking in this exam room';
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

-- Dump completed on 2025-12-03  9:04:48
