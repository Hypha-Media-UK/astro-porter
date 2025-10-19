/*M!999999\- enable the sandbox mode */ 
-- MariaDB dump 10.19  Distrib 10.11.14-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: porter_management
-- ------------------------------------------------------
-- Server version	10.11.14-MariaDB-ubu2204

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Dumping data for table `allocations`
--

LOCK TABLES `allocations` WRITE;
/*!40000 ALTER TABLE `allocations` DISABLE KEYS */;
INSERT INTO `allocations` VALUES
('cmgxcym3n000332wnww805brd','cmgwa3gic000kp7bbec9z25u9','cmgwat6an0001fwu60tugr323',NULL,'2025-10-18 08:00:00.000',NULL,'REGULAR','Regular assignment to Emergency Department','2025-10-19 07:01:21.636','2025-10-19 07:01:21.636'),
('cmgxhwqn800012a3pi6cu6xia','cmgwa3gic000kp7bbec9z25u9','cmgwat6an0001fwu60tugr323',NULL,'2025-10-19 10:00:00.000',NULL,'TEMPORARY','Test allocation via API','2025-10-19 09:19:52.292','2025-10-19 09:19:52.292');
/*!40000 ALTER TABLE `allocations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `availability`
--

LOCK TABLES `availability` WRITE;
/*!40000 ALTER TABLE `availability` DISABLE KEYS */;
INSERT INTO `availability` VALUES
('cmgxcyxrm000532wn93pnuxxj','cmgwa3gic000kp7bbec9z25u9','2025-10-18 09:00:00.000','2025-10-18 17:00:00.000','UNAVAILABLE','Sick Leave','2025-10-19 07:01:36.755','2025-10-19 07:01:36.755');
/*!40000 ALTER TABLE `availability` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `buildings`
--

LOCK TABLES `buildings` WRITE;
/*!40000 ALTER TABLE `buildings` DISABLE KEYS */;
INSERT INTO `buildings` VALUES
('cmgwa3gga0000p7bbj3v6bcep','Main Hospital','City Centre','Primary hospital facility','2025-10-18 12:53:22.571','2025-10-18 12:53:22.571'),
('cmgwanuq40000twg3mc4dm2wa','Updated Main Hospital','North Campus','Emergency services building','2025-10-18 13:09:14.189','2025-10-19 09:19:14.253');
/*!40000 ALTER TABLE `buildings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `capabilities`
--

LOCK TABLES `capabilities` WRITE;
/*!40000 ALTER TABLE `capabilities` DISABLE KEYS */;
INSERT INTO `capabilities` VALUES
('cmgwa3ggj0001p7bb6bvu4ykb','Theatre Access','Access to operating theatres','2025-10-18 12:53:22.579','2025-10-18 12:53:22.579'),
('cmgwa3ggj0002p7bb65q3zw3b','MRI Clearance','Cleared for MRI environment','2025-10-18 12:53:22.579','2025-10-18 12:53:22.579'),
('cmgwa3ggj0003p7bbe9ifeo9s','Radiation Safety','Radiation safety training','2025-10-18 12:53:22.579','2025-10-18 12:53:22.579'),
('cmgwa3ggj0004p7bb4izp11sx','Forklift Licence','Licensed to operate forklift','2025-10-18 12:53:22.579','2025-10-18 12:53:22.579'),
('cmgwa3ggj0005p7bbr2jio09n','Patient Transport','Qualified for patient transport','2025-10-18 12:53:22.579','2025-10-18 12:53:22.579');
/*!40000 ALTER TABLE `capabilities` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `department_capabilities`
--

LOCK TABLES `department_capabilities` WRITE;
/*!40000 ALTER TABLE `department_capabilities` DISABLE KEYS */;
/*!40000 ALTER TABLE `department_capabilities` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `department_schedule_periods`
--

LOCK TABLES `department_schedule_periods` WRITE;
/*!40000 ALTER TABLE `department_schedule_periods` DISABLE KEYS */;
INSERT INTO `department_schedule_periods` VALUES
('cmgwa3ghg000ap7bbrrx4zg4z','cmgwa3ghg0009p7bbhua48rbg','MONDAY','08:00','18:00',3),
('cmgwa3ghg000bp7bbvjpw25vf','cmgwa3ghg0009p7bbhua48rbg','TUESDAY','08:00','18:00',3),
('cmgwa3ghg000cp7bbuq60cr2z','cmgwa3ghg0009p7bbhua48rbg','WEDNESDAY','08:00','18:00',3),
('cmgwa3ghg000dp7bbx22evjbh','cmgwa3ghg0009p7bbhua48rbg','THURSDAY','08:00','18:00',3),
('cmgwa3ghg000ep7bbodshirnd','cmgwa3ghg0009p7bbhua48rbg','FRIDAY','08:00','18:00',3);
/*!40000 ALTER TABLE `department_schedule_periods` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `department_schedules`
--

LOCK TABLES `department_schedules` WRITE;
/*!40000 ALTER TABLE `department_schedules` DISABLE KEYS */;
INSERT INTO `department_schedules` VALUES
('cmgwa3ghg0009p7bbhua48rbg','Standard Weekday Schedule',NULL,'Monday to Friday operational hours',1,'2025-10-18 12:53:22.612','2025-10-18 12:53:22.612');
/*!40000 ALTER TABLE `department_schedules` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `departments`
--

LOCK TABLES `departments` WRITE;
/*!40000 ALTER TABLE `departments` DISABLE KEYS */;
INSERT INTO `departments` VALUES
('cmgwa3gi1000gp7bb2q2pbvbb','Radiology','cmgwa3gga0000p7bbj3v6bcep','cmgwa3ghg0009p7bbhua48rbg','Medical imaging department',0,'2025-10-18 12:53:22.634','2025-10-18 12:53:22.634'),
('cmgwat6an0001fwu60tugr323','Emergency Department','cmgwanuq40000twg3mc4dm2wa',NULL,'Emergency medical services',0,'2025-10-18 13:13:22.463','2025-10-19 07:53:18.902');
/*!40000 ALTER TABLE `departments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `porter_capabilities`
--

LOCK TABLES `porter_capabilities` WRITE;
/*!40000 ALTER TABLE `porter_capabilities` DISABLE KEYS */;
/*!40000 ALTER TABLE `porter_capabilities` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `porters`
--

LOCK TABLES `porters` WRITE;
/*!40000 ALTER TABLE `porters` DISABLE KEYS */;
INSERT INTO `porters` VALUES
('cmgwa3gic000kp7bbec9z25u9','John Smith','SHIFT','cmgwa3gh80008p7bbcmfko7kj',NULL,NULL,'cmgwa3gi1000gp7bb2q2pbvbb','PORTER',1,'2025-10-18 12:53:22.644','2025-10-18 12:53:22.644'),
('cmgwc3r390000ykt0ugyvfl0a','John Smith','SHIFT',NULL,NULL,NULL,NULL,'PORTER',1,'2025-10-18 13:49:35.589','2025-10-18 13:49:35.589');
/*!40000 ALTER TABLE `porters` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `service_capabilities`
--

LOCK TABLES `service_capabilities` WRITE;
/*!40000 ALTER TABLE `service_capabilities` DISABLE KEYS */;
/*!40000 ALTER TABLE `service_capabilities` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `services`
--

LOCK TABLES `services` WRITE;
/*!40000 ALTER TABLE `services` DISABLE KEYS */;
INSERT INTO `services` VALUES
('cmgwa3gi6000ip7bb99gt0gv0','Patient Transport','cmgwa3gi1000gp7bb2q2pbvbb','Transport patients to and from radiology',1,1,'2025-10-18 12:53:22.638','2025-10-18 12:53:22.638'),
('cmgwbw02x0001691gidufr9wn','Equipment Transport','cmgwat6an0001fwu60tugr323','Transport medical equipment',1,1,'2025-10-18 13:43:33.993','2025-10-18 13:43:33.993');
/*!40000 ALTER TABLE `services` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `shift_patterns`
--

LOCK TABLES `shift_patterns` WRITE;
/*!40000 ALTER TABLE `shift_patterns` DISABLE KEYS */;
INSERT INTO `shift_patterns` VALUES
('cmgwa3ggt0006p7bb4e57l3dm','4 on 4 off Pattern','[{\"type\":\"day\",\"label\":\"Day Shift\",\"duration_days\":4},{\"type\":\"off\",\"label\":\"Rest\",\"duration_days\":4}]','4 days on, 4 days off rotation','2025-10-18 12:53:22.590','2025-10-18 12:53:22.590'),
('cmgwd8qn80000lr7wt79ofpfr','Day/Night Rotation','[{\"type\":\"ON\",\"label\":\"Day Shift\",\"duration_days\":2},{\"type\":\"OFF\",\"label\":\"Rest\",\"duration_days\":1},{\"type\":\"ON\",\"label\":\"Night Shift\",\"duration_days\":2},{\"type\":\"OFF\",\"label\":\"Rest\",\"duration_days\":2}]','Alternating day and night shifts','2025-10-18 14:21:27.908','2025-10-18 14:21:27.908');
/*!40000 ALTER TABLE `shift_patterns` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `shifts`
--

LOCK TABLES `shifts` WRITE;
/*!40000 ALTER TABLE `shifts` DISABLE KEYS */;
INSERT INTO `shifts` VALUES
('cmgwa3gh80008p7bbcmfko7kj','Day Shift A','cmgwa3ggt0006p7bb4e57l3dm','DAY','A',4,4,0,'2024-01-01 00:00:00.000','2025-10-18 12:53:22.604','2025-10-18 12:53:22.604');
/*!40000 ALTER TABLE `shifts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `system_settings`
--

LOCK TABLES `system_settings` WRITE;
/*!40000 ALTER TABLE `system_settings` DISABLE KEYS */;
INSERT INTO `system_settings` VALUES
('auto_refresh_interval','300','Dashboard auto-refresh interval in seconds','2025-10-18 15:01:02.818'),
('day_shift_end','20:00','Default day shift end time','2025-10-18 12:53:22.545'),
('day_shift_start','08:00','Default day shift start time','2025-10-18 12:53:22.545'),
('default_shift_duration','12','Default shift duration in hours','2025-10-18 15:01:02.837'),
('enable_capability_enforcement','true','Enforce capability requirements for assignments','2025-10-18 15:01:02.829'),
('enforce_capability_expiry','false','Whether to strictly enforce capability expiry dates','2025-10-18 12:53:22.545'),
('minimum_coverage_percentage','75','Minimum acceptable coverage percentage','2025-10-18 15:01:02.785'),
('night_shift_end','08:00','Default night shift end time','2025-10-18 12:53:22.545'),
('night_shift_start','20:00','Default night shift start time','2025-10-18 12:53:22.545');
/*!40000 ALTER TABLE `system_settings` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-10-19  9:20:16
