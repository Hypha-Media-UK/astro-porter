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
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `allocations`
--

DROP TABLE IF EXISTS `allocations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `allocations` (
  `id` varchar(191) NOT NULL,
  `porter_id` varchar(191) NOT NULL,
  `department_id` varchar(191) NOT NULL,
  `service_id` varchar(191) DEFAULT NULL,
  `start_datetime` datetime(3) NOT NULL,
  `end_datetime` datetime(3) DEFAULT NULL,
  `type` enum('REGULAR','TEMPORARY','RELIEF') NOT NULL,
  `reason` varchar(191) DEFAULT NULL,
  `created_at` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updated_at` datetime(3) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `allocations_porter_id_fkey` (`porter_id`),
  KEY `allocations_department_id_fkey` (`department_id`),
  KEY `allocations_service_id_fkey` (`service_id`),
  CONSTRAINT `allocations_department_id_fkey` FOREIGN KEY (`department_id`) REFERENCES `departments` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `allocations_porter_id_fkey` FOREIGN KEY (`porter_id`) REFERENCES `porters` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `allocations_service_id_fkey` FOREIGN KEY (`service_id`) REFERENCES `services` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `allocations`
--

LOCK TABLES `allocations` WRITE;
/*!40000 ALTER TABLE `allocations` DISABLE KEYS */;
INSERT INTO `allocations` VALUES
('cmgz1ntko009vo7naehmdfxj4','cmgz1nt5g0059o7nadayasrhm','cmgz1nswh002bo7naahnoqotd','cmgz1nt1z0045o7napmumyeg5','2024-01-01 08:00:00.000',NULL,'REGULAR','Assigned to Patient Transport service','2025-10-20 11:20:34.680','2025-10-20 11:20:34.680'),
('cmgz1ntkw009xo7naybcbji31','cmgz1nt9r006lo7nakt8nwgro','cmgz1nswh002bo7naahnoqotd','cmgz1nt1z0045o7napmumyeg5','2024-01-01 08:00:00.000',NULL,'REGULAR','Assigned to Patient Transport service','2025-10-20 11:20:34.689','2025-10-20 11:20:34.689'),
('cmgz1ntl5009zo7naflfei8bg','cmgz1nta1006no7naa3m94fi0','cmgz1nswh002bo7naahnoqotd','cmgz1nt1z0045o7napmumyeg5','2024-01-01 08:00:00.000',NULL,'REGULAR','Assigned to Patient Transport service','2025-10-20 11:20:34.698','2025-10-20 11:20:34.698'),
('cmgz1ntlc00a1o7natc1i30bb','cmgz1nta8006po7naw6b28pc6','cmgz1nswh002bo7naahnoqotd','cmgz1nt1z0045o7napmumyeg5','2024-01-01 08:00:00.000',NULL,'REGULAR','Assigned to Patient Transport service','2025-10-20 11:20:34.704','2025-10-20 11:20:34.704'),
('cmgz1ntlg00a3o7navi1b6om9','cmgz1ntae006ro7naad50b6ir','cmgz1nswh002bo7naahnoqotd','cmgz1nt1z0045o7napmumyeg5','2024-01-01 08:00:00.000',NULL,'REGULAR','Assigned to Patient Transport service','2025-10-20 11:20:34.709','2025-10-20 11:20:34.709'),
('cmgz1ntlm00a5o7na0d43ywua','cmgz1ntar006vo7naf01ghaza','cmgz1nsqu000ho7na31tg4hnv','cmgz1nt260047o7narqq3jh9e','2024-01-01 08:00:00.000',NULL,'REGULAR','Assigned to District Drivers service','2025-10-20 11:20:34.715','2025-10-20 11:20:34.715'),
('cmgz1ntlr00a7o7naz32muemv','cmgz1ntfw0089o7nabhfjdy9w','cmgz1nswh002bo7naahnoqotd','cmgz1nt1z0045o7napmumyeg5','2024-01-01 08:00:00.000',NULL,'REGULAR','Assigned to Patient Transport service - 12:00 - 20:00 - Mon-Fri','2025-10-20 11:20:34.719','2025-10-20 11:20:34.719'),
('cmgz1ntlv00a9o7nacfbgiq3o','cmgz1ntg2008bo7naf715fl36','cmgz1nswh002bo7naahnoqotd','cmgz1nt1z0045o7napmumyeg5','2024-01-01 08:00:00.000',NULL,'REGULAR','Assigned to Patient Transport service - 12:00 - 20:00 - Mon-Fri','2025-10-20 11:20:34.724','2025-10-20 11:20:34.724'),
('cmgz1ntm000abo7nar9jr457s','cmgz1ntg6008do7nabbtvm1n0','cmgz1nsuq001ro7nat7d628jz','cmgz1nt2b0049o7nabjvv5kkl','2024-01-01 08:00:00.000',NULL,'REGULAR','Assigned to Medical Records service - Mon-Fri','2025-10-20 11:20:34.729','2025-10-20 11:20:34.729'),
('cmgz1ntm500ado7nacswvtany','cmgz1ntgb008fo7na95ugieag','cmgz1nsuq001ro7nat7d628jz','cmgz1nt2b0049o7nabjvv5kkl','2024-01-01 08:00:00.000',NULL,'REGULAR','Assigned to Medical Records service - Mon-Fri','2025-10-20 11:20:34.734','2025-10-20 11:20:34.734'),
('cmgz1ntme00afo7nagvs0svsh','cmgz1ntgf008ho7nanesm6wa9','cmgz1nsuq001ro7nat7d628jz','cmgz1nt2b0049o7nabjvv5kkl','2024-01-01 08:00:00.000',NULL,'REGULAR','Assigned to Medical Records service - Mon-Fri','2025-10-20 11:20:34.743','2025-10-20 11:20:34.743'),
('cmgz1ntmm00aho7na1pvbpqc9','cmgz1ntgk008jo7nauim6pmkm','cmgz1nsqu000ho7na31tg4hnv','cmgz1nt2f004bo7na42kgxxag','2024-01-01 08:00:00.000',NULL,'REGULAR','Assigned to Post service - Mon-Fri','2025-10-20 11:20:34.751','2025-10-20 11:20:34.751'),
('cmgz1ntmr00ajo7na4epwi980','cmgz1ntgu008lo7natg6t49fq','cmgz1nsqu000ho7na31tg4hnv','cmgz1nt2f004bo7na42kgxxag','2024-01-01 08:00:00.000',NULL,'REGULAR','Assigned to Post service - Mon-Fri','2025-10-20 11:20:34.756','2025-10-20 11:20:34.756'),
('cmgz1ntmx00alo7na8bi4z7y0','cmgz1nth3008no7na6kqbnwpn','cmgz1nsvx0025o7naddqi0pkw','cmgz1nt2k004do7najzv42ay4','2024-01-01 08:00:00.000',NULL,'REGULAR','Assigned to Stores service - Mon-Fri','2025-10-20 11:20:34.761','2025-10-20 11:20:34.761'),
('cmgz1ntn200ano7na30uxtv2x','cmgz1nthd008ro7naeijde3y1','cmgz1nsqu000ho7na31tg4hnv','cmgz1nt260047o7narqq3jh9e','2024-01-01 08:00:00.000',NULL,'REGULAR','Assigned to District Drivers service - Mon-Fri','2025-10-20 11:20:34.766','2025-10-20 11:20:34.766'),
('cmgz1ntn700apo7nad7mtw1zr','cmgz1nthj008to7nage0hknjh','cmgz1nsqu000ho7na31tg4hnv','cmgz1nt2p004fo7nai92lqq03','2024-01-01 08:00:00.000',NULL,'REGULAR','Assigned to Blood Drivers service - Mon-Fri','2025-10-20 11:20:34.772','2025-10-20 11:20:34.772'),
('cmgz1ntnc00aro7na8yrfh1ze','cmgz1ntho008vo7natvakso4i','cmgz1nsqu000ho7na31tg4hnv','cmgz1nt2p004fo7nai92lqq03','2024-01-01 08:00:00.000',NULL,'REGULAR','Assigned to Blood Drivers service - Mon-Fri','2025-10-20 11:20:34.777','2025-10-20 11:20:34.777'),
('cmgz1ntnh00ato7natkx5typs','cmgz1ntht008xo7na76zaxqsq','cmgz1nsqu000ho7na31tg4hnv','cmgz1nt2p004fo7nai92lqq03','2024-01-01 08:00:00.000',NULL,'REGULAR','Assigned to Blood Drivers service - Mon-Fri','2025-10-20 11:20:34.782','2025-10-20 11:20:34.782'),
('cmgz1ntnp00avo7na44k8xdb7','cmgz1nthy008zo7na66s2foo3','cmgz1nsqu000ho7na31tg4hnv','cmgz1nt2p004fo7nai92lqq03','2024-01-01 08:00:00.000',NULL,'REGULAR','Assigned to Blood Drivers service - Mon-Fri','2025-10-20 11:20:34.789','2025-10-20 11:20:34.789'),
('cmgz1ntny00axo7naqfoom1fr','cmgz1nti70091o7naumaxd445','cmgz1nt11003vo7napta16xy9','cmgz1nt2y004ho7nar26mzy8f','2024-01-01 08:00:00.000',NULL,'REGULAR','Assigned to Laundry service - Mon-Fri','2025-10-20 11:20:34.799','2025-10-20 11:20:34.799'),
('cmgz1nto400azo7na4xco3qhi','cmgz1ntim0095o7naickazxvk','cmgz1nsqu000ho7na31tg4hnv','cmgz1nt37004jo7na13skg3l7','2024-01-01 08:00:00.000',NULL,'REGULAR','Assigned to External Waste service','2025-10-20 11:20:34.805','2025-10-20 11:20:34.805'),
('cmgz1nto900b1o7najibsxn95','cmgz1ntir0097o7nat257o7xy','cmgz1nsqu000ho7na31tg4hnv','cmgz1nt37004jo7na13skg3l7','2024-01-01 08:00:00.000',NULL,'REGULAR','Assigned to External Waste service - Mon-Fri','2025-10-20 11:20:34.809','2025-10-20 11:20:34.809'),
('cmgz1ntof00b3o7naqt8jk5d2','cmgz1ntiw0099o7nae7wbbr6a','cmgz1nsqu000ho7na31tg4hnv','cmgz1nt3e004lo7na7k3csx8p','2024-01-01 08:00:00.000',NULL,'REGULAR','Assigned to Ad-Hoc service - Mon-Fri','2025-10-20 11:20:34.815','2025-10-20 11:20:34.815'),
('cmgz1ntok00b5o7na0axx73pz','cmgz1ntj1009bo7nahjc6w5be','cmgz1nsqu000ho7na31tg4hnv','cmgz1nt3e004lo7na7k3csx8p','2024-01-01 08:00:00.000',NULL,'REGULAR','Assigned to Ad-Hoc service - Mon-Fri','2025-10-20 11:20:34.820','2025-10-20 11:20:34.820'),
('cmgz1ntoo00b7o7na3giamc2g','cmgz1ntjb009fo7nayu2qo0a9','cmgz1nt11003vo7napta16xy9','cmgz1nt2y004ho7nar26mzy8f','2024-01-01 08:00:00.000',NULL,'REGULAR','Assigned to Laundry service - Mon-Fri','2025-10-20 11:20:34.825','2025-10-20 11:20:34.825'),
('cmgz1ntov00b9o7naljkihl9r','cmgz1ntjr009jo7napm54b60z','cmgz1nswh002bo7naahnoqotd','cmgz1nt1z0045o7napmumyeg5','2024-01-01 08:00:00.000',NULL,'REGULAR','Assigned to Patient Transport service','2025-10-20 11:20:34.831','2025-10-20 11:20:34.831'),
('cmgz1ntp300bbo7na859trpwy','cmgz1ntjy009lo7nakm8azuyi','cmgz1nswh002bo7naahnoqotd','cmgz1nt1z0045o7napmumyeg5','2024-01-01 08:00:00.000',NULL,'REGULAR','Assigned to Patient Transport service','2025-10-20 11:20:34.839','2025-10-20 11:20:34.839'),
('cmgz1ntpc00bdo7naprr4c2cp','cmgz1ntk2009no7name6gm7wt','cmgz1nswh002bo7naahnoqotd','cmgz1nt1z0045o7napmumyeg5','2024-01-01 08:00:00.000',NULL,'REGULAR','Assigned to Patient Transport service','2025-10-20 11:20:34.848','2025-10-20 11:20:34.848');
/*!40000 ALTER TABLE `allocations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `availability`
--

DROP TABLE IF EXISTS `availability`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `availability` (
  `id` varchar(191) NOT NULL,
  `porter_id` varchar(191) NOT NULL,
  `start_datetime` datetime(3) NOT NULL,
  `end_datetime` datetime(3) NOT NULL,
  `status` enum('AVAILABLE','UNAVAILABLE','OVERTIME') NOT NULL,
  `reason` varchar(191) DEFAULT NULL,
  `created_at` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updated_at` datetime(3) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `availability_porter_id_fkey` (`porter_id`),
  CONSTRAINT `availability_porter_id_fkey` FOREIGN KEY (`porter_id`) REFERENCES `porters` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `availability`
--

LOCK TABLES `availability` WRITE;
/*!40000 ALTER TABLE `availability` DISABLE KEYS */;
/*!40000 ALTER TABLE `availability` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `buildings`
--

DROP TABLE IF EXISTS `buildings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `buildings` (
  `id` varchar(191) NOT NULL,
  `name` varchar(191) NOT NULL,
  `location` varchar(191) DEFAULT NULL,
  `description` varchar(191) DEFAULT NULL,
  `created_at` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updated_at` datetime(3) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `buildings`
--

LOCK TABLES `buildings` WRITE;
/*!40000 ALTER TABLE `buildings` DISABLE KEYS */;
INSERT INTO `buildings` VALUES
('cmgz1nso10000o7na0xwoj7uv','Charlesworth','Hospital Campus','Charlesworth facility','2025-10-20 11:20:33.505','2025-10-20 11:20:33.505'),
('cmgz1nsod0001o7navxu4n5xy','Ladysmith','Hospital Campus','Ladysmith facility','2025-10-20 11:20:33.517','2025-10-20 11:20:33.517'),
('cmgz1nsoi0002o7nas6879x9q','Buckton Building','Hospital Campus','Buckton Building facility','2025-10-20 11:20:33.522','2025-10-20 11:20:33.522'),
('cmgz1nsom0003o7na6q582az7','Etherow Building','Hospital Campus','Etherow Building facility','2025-10-20 11:20:33.527','2025-10-20 11:20:33.527'),
('cmgz1nsos0004o7nawlw5414x','New Century House','Hospital Campus','New Century House facility','2025-10-20 11:20:33.532','2025-10-20 11:20:33.532'),
('cmgz1nsp00005o7naimauwf6z','Werneth House','Hospital Campus','Werneth House facility','2025-10-20 11:20:33.541','2025-10-20 11:20:33.541'),
('cmgz1nsp90006o7na0yh3kxk7','Stamford Unit','Hospital Campus','Stamford Unit facility','2025-10-20 11:20:33.550','2025-10-20 11:20:33.550'),
('cmgz1nspe0007o7nak5rryoob','Renal Unit','Hospital Campus','Renal Unit facility','2025-10-20 11:20:33.555','2025-10-20 11:20:33.555'),
('cmgz1nspj0008o7nae505jltc','Main Stores','Hospital Campus','Main Stores facility','2025-10-20 11:20:33.559','2025-10-20 11:20:33.559'),
('cmgz1nspp0009o7nadgiqdliy','Silver Springs','Hospital Campus','Silver Springs facility','2025-10-20 11:20:33.566','2025-10-20 11:20:33.566'),
('cmgz1nspu000ao7naigy5598f','Springhill','Hospital Campus','Springhill facility','2025-10-20 11:20:33.570','2025-10-20 11:20:33.570'),
('cmgz1nspy000bo7naizetikqs','Hartshead','Hospital Campus','Hartshead facility','2025-10-20 11:20:33.575','2025-10-20 11:20:33.575'),
('cmgz1nsq3000co7nac2wees43','Macmillan Unit','Hospital Campus','Macmillan Unit facility','2025-10-20 11:20:33.580','2025-10-20 11:20:33.580'),
('cmgz1nsqa000do7nazxexihld','Astley House','Hospital Campus','Astley House facility','2025-10-20 11:20:33.586','2025-10-20 11:20:33.586'),
('cmgz1nsqi000eo7nalcxfu2we','Portland House','Hospital Campus','Portland House facility','2025-10-20 11:20:33.594','2025-10-20 11:20:33.594'),
('cmgz1nsqp000fo7nac0nshhw8','Mellor House','Hospital Campus','Mellor House facility','2025-10-20 11:20:33.602','2025-10-20 11:20:33.602');
/*!40000 ALTER TABLE `buildings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `capabilities`
--

DROP TABLE IF EXISTS `capabilities`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `capabilities` (
  `id` varchar(191) NOT NULL,
  `name` varchar(191) NOT NULL,
  `description` varchar(191) DEFAULT NULL,
  `created_at` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updated_at` datetime(3) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `capabilities_name_key` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

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
-- Table structure for table `department_capabilities`
--

DROP TABLE IF EXISTS `department_capabilities`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `department_capabilities` (
  `department_id` varchar(191) NOT NULL,
  `capability_id` varchar(191) NOT NULL,
  `required_level` enum('REQUIRED','PREFERRED') NOT NULL,
  PRIMARY KEY (`department_id`,`capability_id`),
  KEY `department_capabilities_capability_id_fkey` (`capability_id`),
  CONSTRAINT `department_capabilities_capability_id_fkey` FOREIGN KEY (`capability_id`) REFERENCES `capabilities` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `department_capabilities_department_id_fkey` FOREIGN KEY (`department_id`) REFERENCES `departments` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `department_capabilities`
--

LOCK TABLES `department_capabilities` WRITE;
/*!40000 ALTER TABLE `department_capabilities` DISABLE KEYS */;
/*!40000 ALTER TABLE `department_capabilities` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `department_schedule_periods`
--

DROP TABLE IF EXISTS `department_schedule_periods`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `department_schedule_periods` (
  `id` varchar(191) NOT NULL,
  `schedule_id` varchar(191) NOT NULL,
  `day_of_week` enum('MONDAY','TUESDAY','WEDNESDAY','THURSDAY','FRIDAY','SATURDAY','SUNDAY') NOT NULL,
  `open_time` varchar(191) NOT NULL,
  `close_time` varchar(191) NOT NULL,
  `required_porters` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `department_schedule_periods_schedule_id_fkey` (`schedule_id`),
  CONSTRAINT `department_schedule_periods_schedule_id_fkey` FOREIGN KEY (`schedule_id`) REFERENCES `department_schedules` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

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
-- Table structure for table `department_schedules`
--

DROP TABLE IF EXISTS `department_schedules`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `department_schedules` (
  `id` varchar(191) NOT NULL,
  `name` varchar(191) NOT NULL,
  `pattern_id` varchar(191) DEFAULT NULL,
  `description` varchar(191) DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updated_at` datetime(3) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

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
-- Table structure for table `departments`
--

DROP TABLE IF EXISTS `departments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `departments` (
  `id` varchar(191) NOT NULL,
  `name` varchar(191) NOT NULL,
  `building_id` varchar(191) NOT NULL,
  `schedule_id` varchar(191) DEFAULT NULL,
  `description` varchar(191) DEFAULT NULL,
  `is_247` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updated_at` datetime(3) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `departments_building_id_fkey` (`building_id`),
  KEY `departments_schedule_id_fkey` (`schedule_id`),
  CONSTRAINT `departments_building_id_fkey` FOREIGN KEY (`building_id`) REFERENCES `buildings` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `departments_schedule_id_fkey` FOREIGN KEY (`schedule_id`) REFERENCES `department_schedules` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `departments`
--

LOCK TABLES `departments` WRITE;
/*!40000 ALTER TABLE `departments` DISABLE KEYS */;
INSERT INTO `departments` VALUES
('cmgz1nsqu000ho7na31tg4hnv','Ward 27','cmgz1nso10000o7na0xwoj7uv',NULL,'Ward 27 in Charlesworth',0,'2025-10-20 11:20:33.607','2025-10-20 11:20:33.607'),
('cmgz1nsr2000jo7naye5ldkq2','Ward 30 (HCU)','cmgz1nso10000o7na0xwoj7uv',NULL,'Ward 30 (HCU) in Charlesworth',0,'2025-10-20 11:20:33.614','2025-10-20 11:20:33.614'),
('cmgz1nsr6000lo7na1052rpob','Ward 31','cmgz1nso10000o7na0xwoj7uv',NULL,'Ward 31 in Charlesworth',0,'2025-10-20 11:20:33.619','2025-10-20 11:20:33.619'),
('cmgz1nsrb000no7nafx5718p0','Acorn Birth Center','cmgz1nso10000o7na0xwoj7uv',NULL,'Acorn Birth Center in Charlesworth',0,'2025-10-20 11:20:33.624','2025-10-20 11:20:33.624'),
('cmgz1nsrg000po7nazyx150pd','Labour Ward','cmgz1nso10000o7na0xwoj7uv',NULL,'Labour Ward in Charlesworth',0,'2025-10-20 11:20:33.629','2025-10-20 11:20:33.629'),
('cmgz1nsrl000ro7narzcs54bl','NICU','cmgz1nso10000o7na0xwoj7uv',NULL,'NICU in Charlesworth',0,'2025-10-20 11:20:33.634','2025-10-20 11:20:33.634'),
('cmgz1nsru000to7nakmyza0pe','Maternity Triage','cmgz1nso10000o7na0xwoj7uv',NULL,'Maternity Triage in Charlesworth',0,'2025-10-20 11:20:33.642','2025-10-20 11:20:33.642'),
('cmgz1nss3000vo7nayp2h9lmg','Women\'s Health','cmgz1nso10000o7na0xwoj7uv',NULL,'Women\'s Health in Charlesworth',0,'2025-10-20 11:20:33.651','2025-10-20 11:20:33.651'),
('cmgz1nss8000xo7naj1ry8mxo','Ante-Natal Unit','cmgz1nso10000o7na0xwoj7uv',NULL,'Ante-Natal Unit in Charlesworth',0,'2025-10-20 11:20:33.656','2025-10-20 11:20:33.656'),
('cmgz1nssd000zo7nagfcd14qo','Security','cmgz1nso10000o7na0xwoj7uv',NULL,'Security in Charlesworth',0,'2025-10-20 11:20:33.661','2025-10-20 11:20:33.661'),
('cmgz1nssi0011o7nao93w3rg5','Ward 40','cmgz1nsod0001o7navxu4n5xy',NULL,'Ward 40 in Ladysmith',0,'2025-10-20 11:20:33.666','2025-10-20 11:20:33.666'),
('cmgz1nssn0013o7na0btfqgwc','Ward 41','cmgz1nsod0001o7navxu4n5xy',NULL,'Ward 41 in Ladysmith',0,'2025-10-20 11:20:33.672','2025-10-20 11:20:33.672'),
('cmgz1nssr0015o7nafh9l1s1m','Ward 42','cmgz1nsod0001o7navxu4n5xy',NULL,'Ward 42 in Ladysmith',0,'2025-10-20 11:20:33.676','2025-10-20 11:20:33.676'),
('cmgz1nssx0017o7nahx6r9rj2','Ward 43','cmgz1nsod0001o7navxu4n5xy',NULL,'Ward 43 in Ladysmith',0,'2025-10-20 11:20:33.681','2025-10-20 11:20:33.681'),
('cmgz1nst30019o7namncyk2pk','Ward 44','cmgz1nsod0001o7navxu4n5xy',NULL,'Ward 44 in Ladysmith',0,'2025-10-20 11:20:33.687','2025-10-20 11:20:33.687'),
('cmgz1nstb001bo7nafvo3kq2h','Ward 45','cmgz1nsod0001o7navxu4n5xy',NULL,'Ward 45 in Ladysmith',0,'2025-10-20 11:20:33.695','2025-10-20 11:20:33.695'),
('cmgz1nsti001do7na5nnu3e0h','Ward 46','cmgz1nsod0001o7navxu4n5xy',NULL,'Ward 46 in Ladysmith',0,'2025-10-20 11:20:33.703','2025-10-20 11:20:33.703'),
('cmgz1nstn001fo7nazm9uemwl','Xray 4','cmgz1nsod0001o7navxu4n5xy',NULL,'Xray 4 in Ladysmith',0,'2025-10-20 11:20:33.707','2025-10-20 11:20:33.707'),
('cmgz1nsts001ho7nasnkrx0pe','Walkerwood Unit','cmgz1nsoi0002o7nas6879x9q',NULL,'Walkerwood Unit in Buckton Building',0,'2025-10-20 11:20:33.712','2025-10-20 11:20:33.712'),
('cmgz1nsu0001jo7nax9epx7qo','Saxon Ward','cmgz1nsom0003o7na6q582az7',NULL,'Saxon Ward in Etherow Building',0,'2025-10-20 11:20:33.720','2025-10-20 11:20:33.720'),
('cmgz1nsu4001lo7naegjfem8m','Summers Ward','cmgz1nsom0003o7na6q582az7',NULL,'Summers Ward in Etherow Building',0,'2025-10-20 11:20:33.725','2025-10-20 11:20:33.725'),
('cmgz1nsua001no7na6scg39wp','Hague Ward','cmgz1nsom0003o7na6q582az7',NULL,'Hague Ward in Etherow Building',0,'2025-10-20 11:20:33.730','2025-10-20 11:20:33.730'),
('cmgz1nsug001po7nawp8g0lyc','Infection Control','cmgz1nsos0004o7nawlw5414x',NULL,'Infection Control in New Century House',0,'2025-10-20 11:20:33.736','2025-10-20 11:20:33.736'),
('cmgz1nsuq001ro7nat7d628jz','Library','cmgz1nsos0004o7nawlw5414x',NULL,'Library in New Century House',0,'2025-10-20 11:20:33.746','2025-10-20 11:20:33.746'),
('cmgz1nsux001to7naafsxjjca','Lecture Theatre','cmgz1nsp00005o7naimauwf6z',NULL,'Lecture Theatre in Werneth House',0,'2025-10-20 11:20:33.754','2025-10-20 11:20:33.754'),
('cmgz1nsv2001vo7napnzhjy5m','Classrooms','cmgz1nsp00005o7naimauwf6z',NULL,'Classrooms in Werneth House',0,'2025-10-20 11:20:33.759','2025-10-20 11:20:33.759'),
('cmgz1nsv8001xo7natolhsfym','Stamford Ground','cmgz1nsp90006o7na0yh3kxk7',NULL,'Stamford Ground in Stamford Unit',0,'2025-10-20 11:20:33.765','2025-10-20 11:20:33.765'),
('cmgz1nsve001zo7nat0w8b5om','Stamford 1st Floor','cmgz1nsp90006o7na0yh3kxk7',NULL,'Stamford 1st Floor in Stamford Unit',0,'2025-10-20 11:20:33.770','2025-10-20 11:20:33.770'),
('cmgz1nsvj0021o7naq8vvfpuf','Stamford 2nd Floor','cmgz1nsp90006o7na0yh3kxk7',NULL,'Stamford 2nd Floor in Stamford Unit',0,'2025-10-20 11:20:33.775','2025-10-20 11:20:33.775'),
('cmgz1nsvp0023o7nay5ury61o','Renal Ward','cmgz1nspe0007o7nak5rryoob',NULL,'Renal Ward in Renal Unit',0,'2025-10-20 11:20:33.781','2025-10-20 11:20:33.781'),
('cmgz1nsvx0025o7naddqi0pkw','Supplies','cmgz1nspj0008o7nae505jltc',NULL,'Supplies in Main Stores',0,'2025-10-20 11:20:33.789','2025-10-20 11:20:33.789'),
('cmgz1nsw60027o7naomwp5qtc','Offices','cmgz1nspp0009o7nadgiqdliy',NULL,'Offices in Silver Springs',0,'2025-10-20 11:20:33.798','2025-10-20 11:20:33.798'),
('cmgz1nswc0029o7nad9qzvdre','Offices','cmgz1nspu000ao7naigy5598f',NULL,'Offices in Springhill',0,'2025-10-20 11:20:33.804','2025-10-20 11:20:33.804'),
('cmgz1nswh002bo7naahnoqotd','AMU','cmgz1nspy000bo7naizetikqs',NULL,'AMU in Hartshead',1,'2025-10-20 11:20:33.809','2025-10-20 11:20:33.809'),
('cmgz1nswn002do7nayh3xu499','IAU','cmgz1nspy000bo7naizetikqs',NULL,'IAU in Hartshead',1,'2025-10-20 11:20:33.815','2025-10-20 11:20:33.815'),
('cmgz1nsws002fo7nancqd30zr','ACU','cmgz1nspy000bo7naizetikqs',NULL,'ACU in Hartshead',1,'2025-10-20 11:20:33.821','2025-10-20 11:20:33.821'),
('cmgz1nswx002ho7natwjfqau8','ITU','cmgz1nspy000bo7naizetikqs',NULL,'ITU in Hartshead',1,'2025-10-20 11:20:33.825','2025-10-20 11:20:33.825'),
('cmgz1nsx3002jo7na9pq9zrts','Theatres North','cmgz1nspy000bo7naizetikqs',NULL,'Theatres North in Hartshead',0,'2025-10-20 11:20:33.832','2025-10-20 11:20:33.832'),
('cmgz1nsxb002lo7nazw0pdfww','Theatres South','cmgz1nspy000bo7naizetikqs',NULL,'Theatres South in Hartshead',0,'2025-10-20 11:20:33.839','2025-10-20 11:20:33.839'),
('cmgz1nsxj002no7nae220cn0p','DSEU','cmgz1nspy000bo7naizetikqs',NULL,'DSEU in Hartshead',0,'2025-10-20 11:20:33.848','2025-10-20 11:20:33.848'),
('cmgz1nsxq002po7naod7g1qx1','Children\'s O+A','cmgz1nspy000bo7naizetikqs',NULL,'Children\'s O+A in Hartshead',0,'2025-10-20 11:20:33.854','2025-10-20 11:20:33.854'),
('cmgz1nsxv002ro7na0hwbs2ca','Children\'s Unit','cmgz1nspy000bo7naizetikqs',NULL,'Children\'s Unit in Hartshead',0,'2025-10-20 11:20:33.859','2025-10-20 11:20:33.859'),
('cmgz1nsy0002to7na9g84l0t5','Children\'s Outpatients','cmgz1nspy000bo7naizetikqs',NULL,'Children\'s Outpatients in Hartshead',0,'2025-10-20 11:20:33.864','2025-10-20 11:20:33.864'),
('cmgz1nsy4002vo7nayb86dwok','Clinics A-F','cmgz1nspy000bo7naizetikqs',NULL,'Clinics A-F in Hartshead',0,'2025-10-20 11:20:33.869','2025-10-20 11:20:33.869'),
('cmgz1nsy9002xo7navu8dsdlq','G/F Xray','cmgz1nspy000bo7naizetikqs',NULL,'G/F Xray in Hartshead',0,'2025-10-20 11:20:33.873','2025-10-20 11:20:33.873'),
('cmgz1nsyd002zo7naty9duruc','Green Suite','cmgz1nspy000bo7naizetikqs',NULL,'Green Suite in Hartshead',0,'2025-10-20 11:20:33.878','2025-10-20 11:20:33.878'),
('cmgz1nsyi0031o7nayo2v3jma','Plaster Room','cmgz1nspy000bo7naizetikqs',NULL,'Plaster Room in Hartshead',0,'2025-10-20 11:20:33.882','2025-10-20 11:20:33.882'),
('cmgz1nsyr0033o7na4ktoqyph','Discharge Lounge','cmgz1nspy000bo7naizetikqs',NULL,'Discharge Lounge in Hartshead',0,'2025-10-20 11:20:33.891','2025-10-20 11:20:33.891'),
('cmgz1nsz00035o7nasffo7nmq','ISGU','cmgz1nspy000bo7naizetikqs',NULL,'ISGU in Hartshead',0,'2025-10-20 11:20:33.900','2025-10-20 11:20:33.900'),
('cmgz1nsz60037o7na2yc3sqpe','ED (A+E)','cmgz1nspy000bo7naizetikqs',NULL,'ED (A+E) in Hartshead',1,'2025-10-20 11:20:33.906','2025-10-20 11:20:33.906'),
('cmgz1nsza0039o7nasz09g425','L/G/F Xray','cmgz1nspy000bo7naizetikqs',NULL,'L/G/F Xray in Hartshead',0,'2025-10-20 11:20:33.911','2025-10-20 11:20:33.911'),
('cmgz1nszg003bo7nab11if7vu','L/G/F CT Scan','cmgz1nspy000bo7naizetikqs',NULL,'L/G/F CT Scan in Hartshead',0,'2025-10-20 11:20:33.916','2025-10-20 11:20:33.916'),
('cmgz1nszk003do7na6vu6g7pb','MRI','cmgz1nspy000bo7naizetikqs',NULL,'MRI in Hartshead',0,'2025-10-20 11:20:33.921','2025-10-20 11:20:33.921'),
('cmgz1nszp003fo7nacl9reqh1','Walk in Center','cmgz1nspy000bo7naizetikqs',NULL,'Walk in Center in Hartshead',0,'2025-10-20 11:20:33.925','2025-10-20 11:20:33.925'),
('cmgz1nszv003ho7na05nghgs9','Mattress Store','cmgz1nspy000bo7naizetikqs',NULL,'Mattress Store in Hartshead',0,'2025-10-20 11:20:33.931','2025-10-20 11:20:33.931'),
('cmgz1nt02003jo7na5y5y55m7','Pharmacy','cmgz1nspy000bo7naizetikqs',NULL,'Pharmacy in Hartshead',0,'2025-10-20 11:20:33.938','2025-10-20 11:20:33.938'),
('cmgz1nt0c003lo7nalfjs3qpo','Swan Room','cmgz1nspy000bo7naizetikqs',NULL,'Swan Room in Hartshead',0,'2025-10-20 11:20:33.948','2025-10-20 11:20:33.948'),
('cmgz1nt0i003no7na4lhlrwd8','Parking Office','cmgz1nspy000bo7naizetikqs',NULL,'Parking Office in Hartshead',0,'2025-10-20 11:20:33.954','2025-10-20 11:20:33.954'),
('cmgz1nt0m003po7narzpa7u71','CRI','cmgz1nspy000bo7naizetikqs',NULL,'CRI in Hartshead',0,'2025-10-20 11:20:33.959','2025-10-20 11:20:33.959'),
('cmgz1nt0s003ro7na95dxw4ba','Macmillan','cmgz1nsq3000co7nac2wees43',NULL,'Macmillan in Macmillan Unit',0,'2025-10-20 11:20:33.964','2025-10-20 11:20:33.964'),
('cmgz1nt0w003to7najiavjnxq','Mattress Store','cmgz1nsqa000do7nazxexihld',NULL,'Mattress Store in Astley House',0,'2025-10-20 11:20:33.969','2025-10-20 11:20:33.969'),
('cmgz1nt11003vo7napta16xy9','Laundry','cmgz1nsqi000eo7nalcxfu2we',NULL,'Laundry in Portland House',0,'2025-10-20 11:20:33.974','2025-10-20 11:20:33.974'),
('cmgz1nt17003xo7naf20ytcnf','Meeting Rooms','cmgz1nsqp000fo7nac0nshhw8',NULL,'Meeting Rooms in Mellor House',0,'2025-10-20 11:20:33.979','2025-10-20 11:20:33.979'),
('cmgz1nt1d003zo7nacvttg75i','Porters Lodge','cmgz1nsqp000fo7nac0nshhw8',NULL,'Porters Lodge in Mellor House',0,'2025-10-20 11:20:33.985','2025-10-20 11:20:33.985'),
('cmgz1nt1m0041o7nafamenq1c','I.T.','cmgz1nsqp000fo7nac0nshhw8',NULL,'I.T. in Mellor House',0,'2025-10-20 11:20:33.994','2025-10-20 11:20:33.994'),
('cmgz1nt1u0043o7nal9kd1w2d','Equipment Repair','cmgz1nsqp000fo7nac0nshhw8',NULL,'Equipment Repair in Mellor House',0,'2025-10-20 11:20:34.002','2025-10-20 11:20:34.002');
/*!40000 ALTER TABLE `departments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `porter_capabilities`
--

DROP TABLE IF EXISTS `porter_capabilities`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `porter_capabilities` (
  `porter_id` varchar(191) NOT NULL,
  `capability_id` varchar(191) NOT NULL,
  `expiry_date` datetime(3) DEFAULT NULL,
  `created_at` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  PRIMARY KEY (`porter_id`,`capability_id`),
  KEY `porter_capabilities_capability_id_fkey` (`capability_id`),
  CONSTRAINT `porter_capabilities_capability_id_fkey` FOREIGN KEY (`capability_id`) REFERENCES `capabilities` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `porter_capabilities_porter_id_fkey` FOREIGN KEY (`porter_id`) REFERENCES `porters` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `porter_capabilities`
--

LOCK TABLES `porter_capabilities` WRITE;
/*!40000 ALTER TABLE `porter_capabilities` DISABLE KEYS */;
/*!40000 ALTER TABLE `porter_capabilities` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `porters`
--

DROP TABLE IF EXISTS `porters`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `porters` (
  `id` varchar(191) NOT NULL,
  `name` varchar(191) NOT NULL,
  `contract_type` enum('SHIFT','FIXED','RELIEF') NOT NULL,
  `shift_id` varchar(191) DEFAULT NULL,
  `weekly_min_hours` int(11) DEFAULT NULL,
  `contracted_hours` int(11) DEFAULT NULL,
  `regular_department_id` varchar(191) DEFAULT NULL,
  `porter_type` enum('PORTER','SUPERVISOR') NOT NULL DEFAULT 'PORTER',
  `counts_towards_staffing` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updated_at` datetime(3) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `porters_shift_id_fkey` (`shift_id`),
  KEY `porters_regular_department_id_fkey` (`regular_department_id`),
  CONSTRAINT `porters_regular_department_id_fkey` FOREIGN KEY (`regular_department_id`) REFERENCES `departments` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `porters_shift_id_fkey` FOREIGN KEY (`shift_id`) REFERENCES `shifts` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `porters`
--

LOCK TABLES `porters` WRITE;
/*!40000 ALTER TABLE `porters` DISABLE KEYS */;
INSERT INTO `porters` VALUES
('cmgz1nt3q004po7naku6g17tl','Martin Smith','FIXED',NULL,37,37,NULL,'SUPERVISOR',1,'2025-10-20 11:20:34.070','2025-10-20 11:20:34.070'),
('cmgz1nt3x004ro7nafhjq6tbi','Chris Crombie','FIXED',NULL,37,37,NULL,'SUPERVISOR',1,'2025-10-20 11:20:34.077','2025-10-20 11:20:34.077'),
('cmgz1nt42004to7natrzm5ngo','Martin Fearon','FIXED',NULL,37,37,NULL,'SUPERVISOR',1,'2025-10-20 11:20:34.083','2025-10-20 11:20:34.083'),
('cmgz1nt4b004vo7nabt88yc2m','Luke Clements','FIXED',NULL,37,37,NULL,'SUPERVISOR',1,'2025-10-20 11:20:34.091','2025-10-20 11:20:34.091'),
('cmgz1nt4j004xo7nawxit68c1','Chris Threadgold','FIXED',NULL,37,37,NULL,'SUPERVISOR',1,'2025-10-20 11:20:34.100','2025-10-20 11:20:34.100'),
('cmgz1nt4p004zo7naupzohro1','Rob Mcpartland','SHIFT',NULL,37,37,NULL,'PORTER',1,'2025-10-20 11:20:34.105','2025-10-20 11:20:34.105'),
('cmgz1nt4u0051o7naeuloul7w','John Evans','SHIFT',NULL,37,37,NULL,'PORTER',1,'2025-10-20 11:20:34.110','2025-10-20 11:20:34.110'),
('cmgz1nt4z0053o7nat4yalrys','Charlotte Rimmer','SHIFT',NULL,37,37,NULL,'PORTER',1,'2025-10-20 11:20:34.116','2025-10-20 11:20:34.116'),
('cmgz1nt550055o7na2qqycnlf','Carla Barton','SHIFT',NULL,37,37,NULL,'PORTER',1,'2025-10-20 11:20:34.121','2025-10-20 11:20:34.121'),
('cmgz1nt590057o7nausc8xzvy','Andrew Trudgeon','SHIFT',NULL,37,37,NULL,'PORTER',1,'2025-10-20 11:20:34.126','2025-10-20 11:20:34.126'),
('cmgz1nt5g0059o7nadayasrhm','Stepen Bowater','SHIFT',NULL,37,37,NULL,'PORTER',1,'2025-10-20 11:20:34.132','2025-10-20 11:20:34.132'),
('cmgz1nt5m005bo7nax0yfkdhz','Matthew Bennett','SHIFT',NULL,37,37,NULL,'PORTER',1,'2025-10-20 11:20:34.138','2025-10-20 11:20:34.138'),
('cmgz1nt5u005do7nah23nota1','Stephen Scarsbrook','SHIFT',NULL,37,37,NULL,'PORTER',1,'2025-10-20 11:20:34.147','2025-10-20 11:20:34.147'),
('cmgz1nt61005fo7nap072ii37','Jordon Fish','SHIFT',NULL,37,37,NULL,'PORTER',1,'2025-10-20 11:20:34.154','2025-10-20 11:20:34.154'),
('cmgz1nt66005ho7nakobbw0jt','Steven Richardson','SHIFT',NULL,37,37,NULL,'PORTER',1,'2025-10-20 11:20:34.158','2025-10-20 11:20:34.158'),
('cmgz1nt6b005jo7na55st73b9','Chris Roach','RELIEF',NULL,20,20,NULL,'PORTER',0,'2025-10-20 11:20:34.164','2025-10-20 11:20:34.164'),
('cmgz1nt6g005lo7nasg13wynl','Simon Collins','RELIEF',NULL,20,20,NULL,'PORTER',0,'2025-10-20 11:20:34.169','2025-10-20 11:20:34.169'),
('cmgz1nt6l005no7nah8z95k8o','Mark Walton','FIXED',NULL,37,37,NULL,'PORTER',1,'2025-10-20 11:20:34.173','2025-10-20 11:20:34.173'),
('cmgz1nt6q005po7navd0se6w1','Allen Butler','FIXED',NULL,37,37,NULL,'PORTER',1,'2025-10-20 11:20:34.179','2025-10-20 11:20:34.179'),
('cmgz1nt6w005ro7nak55t5992','Steven Richardson','RELIEF',NULL,20,20,NULL,'PORTER',0,'2025-10-20 11:20:34.184','2025-10-20 11:20:34.184'),
('cmgz1nt74005to7nad847jw8m','Simon Collins','FIXED',NULL,37,37,NULL,'PORTER',1,'2025-10-20 11:20:34.193','2025-10-20 11:20:34.193'),
('cmgz1nt7d005vo7nan8b4usjy','Darren Flowers','SHIFT',NULL,37,37,NULL,'PORTER',1,'2025-10-20 11:20:34.202','2025-10-20 11:20:34.202'),
('cmgz1nt7i005xo7nahthfzpos','Brian Cassidy','SHIFT',NULL,37,37,NULL,'PORTER',1,'2025-10-20 11:20:34.207','2025-10-20 11:20:34.207'),
('cmgz1nt7n005zo7na52xsc0h8','Karen Blackett','SHIFT',NULL,37,37,NULL,'PORTER',1,'2025-10-20 11:20:34.211','2025-10-20 11:20:34.211'),
('cmgz1nt7s0061o7nanmxnp6je','James Mitchell','SHIFT',NULL,37,37,NULL,'PORTER',1,'2025-10-20 11:20:34.216','2025-10-20 11:20:34.216'),
('cmgz1nt7x0063o7na8qb0imq5','Alan Kelly','SHIFT',NULL,37,37,NULL,'PORTER',1,'2025-10-20 11:20:34.221','2025-10-20 11:20:34.221'),
('cmgz1nt820065o7nadodf24pl','Tomas Konkol','SHIFT',NULL,37,37,NULL,'PORTER',1,'2025-10-20 11:20:34.226','2025-10-20 11:20:34.226'),
('cmgz1nt870067o7nave4fa06o','Kyle Blackshaw','RELIEF',NULL,20,20,NULL,'PORTER',0,'2025-10-20 11:20:34.232','2025-10-20 11:20:34.232'),
('cmgz1nt8f0069o7naxlyfslyt','David Sykes','RELIEF',NULL,20,20,NULL,'PORTER',0,'2025-10-20 11:20:34.239','2025-10-20 11:20:34.239'),
('cmgz1nt8o006bo7nauxh2zzt4','Stuart Ford','FIXED',NULL,37,37,'cmgz1nsz60037o7na2yc3sqpe','PORTER',1,'2025-10-20 11:20:34.248','2025-10-20 11:20:34.248'),
('cmgz1nt8u006do7nayqwbbryb','Lee Stafford','FIXED',NULL,37,37,'cmgz1nsz60037o7na2yc3sqpe','PORTER',1,'2025-10-20 11:20:34.255','2025-10-20 11:20:34.255'),
('cmgz1nt8z006fo7natsm5s5mu','Nicola Benger','FIXED',NULL,37,37,'cmgz1nsz60037o7na2yc3sqpe','PORTER',1,'2025-10-20 11:20:34.260','2025-10-20 11:20:34.260'),
('cmgz1nt97006ho7nab70ar4eg','Jeff Robinson','FIXED',NULL,37,37,'cmgz1nswh002bo7naahnoqotd','PORTER',1,'2025-10-20 11:20:34.267','2025-10-20 11:20:34.267'),
('cmgz1nt9i006jo7nam3501ycc','Dean Pickering','FIXED',NULL,37,37,'cmgz1nsy9002xo7navu8dsdlq','PORTER',1,'2025-10-20 11:20:34.279','2025-10-20 11:20:34.279'),
('cmgz1nt9r006lo7nakt8nwgro','Colin Bromley','SHIFT',NULL,37,37,NULL,'PORTER',1,'2025-10-20 11:20:34.287','2025-10-20 11:20:34.287'),
('cmgz1nta1006no7naa3m94fi0','Gary Booth','SHIFT',NULL,37,37,NULL,'PORTER',1,'2025-10-20 11:20:34.297','2025-10-20 11:20:34.297'),
('cmgz1nta8006po7naw6b28pc6','Ian Moss','SHIFT',NULL,37,37,NULL,'PORTER',1,'2025-10-20 11:20:34.304','2025-10-20 11:20:34.304'),
('cmgz1ntae006ro7naad50b6ir','Paul Fisher','SHIFT',NULL,37,37,NULL,'PORTER',1,'2025-10-20 11:20:34.311','2025-10-20 11:20:34.311'),
('cmgz1ntak006to7nan6q047ig','Stephen Kirk','SHIFT',NULL,37,37,NULL,'PORTER',1,'2025-10-20 11:20:34.317','2025-10-20 11:20:34.317'),
('cmgz1ntar006vo7naf01ghaza','Ian Speakes','FIXED',NULL,37,37,NULL,'PORTER',1,'2025-10-20 11:20:34.323','2025-10-20 11:20:34.323'),
('cmgz1ntax006xo7na2k1u9vvn','Stuart Lomas','FIXED',NULL,37,37,'cmgz1nsz60037o7na2yc3sqpe','PORTER',1,'2025-10-20 11:20:34.329','2025-10-20 11:20:34.329'),
('cmgz1ntb3006zo7na5rzzzf1t','Stephen Cooper','SHIFT',NULL,37,37,NULL,'PORTER',1,'2025-10-20 11:20:34.336','2025-10-20 11:20:34.336'),
('cmgz1ntbd0071o7naskmhyxrh','Darren Milhench','SHIFT',NULL,37,37,NULL,'PORTER',1,'2025-10-20 11:20:34.345','2025-10-20 11:20:34.345'),
('cmgz1ntbk0073o7na07m7lp1g','Darren Mycroft','SHIFT',NULL,37,37,NULL,'PORTER',1,'2025-10-20 11:20:34.353','2025-10-20 11:20:34.353'),
('cmgz1ntbq0075o7nag1v1t9d2','Kevin Gaskell','RELIEF',NULL,20,20,NULL,'PORTER',0,'2025-10-20 11:20:34.358','2025-10-20 11:20:34.358'),
('cmgz1ntbx0077o7naxj7xr5m3','Merv Permalloo','SHIFT',NULL,37,37,NULL,'PORTER',1,'2025-10-20 11:20:34.365','2025-10-20 11:20:34.365'),
('cmgz1ntc30079o7naa5kvx4am','Regan Stringer','SHIFT',NULL,37,37,NULL,'PORTER',1,'2025-10-20 11:20:34.371','2025-10-20 11:20:34.371'),
('cmgz1ntc8007bo7nafod6sjhf','Matthew Cope','SHIFT',NULL,37,37,NULL,'PORTER',1,'2025-10-20 11:20:34.377','2025-10-20 11:20:34.377'),
('cmgz1ntce007do7nademfh3yk','AJ','SHIFT',NULL,37,37,NULL,'PORTER',1,'2025-10-20 11:20:34.382','2025-10-20 11:20:34.382'),
('cmgz1ntco007fo7nav3g7r1lv','Michael Shaw','SHIFT',NULL,37,37,NULL,'PORTER',1,'2025-10-20 11:20:34.392','2025-10-20 11:20:34.392'),
('cmgz1ntcy007ho7na59cxlcmd','James Bennett','FIXED',NULL,37,37,NULL,'PORTER',1,'2025-10-20 11:20:34.403','2025-10-20 11:20:34.403'),
('cmgz1ntd5007jo7nax7zbfiik','Martin Hobson','SHIFT',NULL,37,37,NULL,'PORTER',1,'2025-10-20 11:20:34.409','2025-10-20 11:20:34.409'),
('cmgz1ntdd007lo7nas2ddph9s','Martin Kenyon','SHIFT',NULL,37,37,NULL,'PORTER',1,'2025-10-20 11:20:34.417','2025-10-20 11:20:34.417'),
('cmgz1ntdj007no7naa1j6w4zk','Scott Cartledge','SHIFT',NULL,37,37,NULL,'PORTER',1,'2025-10-20 11:20:34.423','2025-10-20 11:20:34.423'),
('cmgz1ntdo007po7naey6pdlom','Tony Batters','SHIFT',NULL,37,37,NULL,'PORTER',1,'2025-10-20 11:20:34.429','2025-10-20 11:20:34.429'),
('cmgz1ntdu007ro7nacv680nd9','Lewis Yearsley','SHIFT',NULL,37,37,NULL,'PORTER',1,'2025-10-20 11:20:34.435','2025-10-20 11:20:34.435'),
('cmgz1nte4007to7nafboqccpl','Mark Lloyd','FIXED',NULL,37,37,'cmgz1nsy9002xo7navu8dsdlq','PORTER',1,'2025-10-20 11:20:34.444','2025-10-20 11:20:34.444'),
('cmgz1ntec007vo7na3cad69uv','Stephen Burke','FIXED',NULL,37,37,'cmgz1nsy9002xo7navu8dsdlq','PORTER',1,'2025-10-20 11:20:34.452','2025-10-20 11:20:34.452'),
('cmgz1nteh007xo7nacll54nji','Julie Greenough','FIXED',NULL,37,37,'cmgz1nszg003bo7nab11if7vu','PORTER',1,'2025-10-20 11:20:34.457','2025-10-20 11:20:34.457'),
('cmgz1ntem007zo7nal8iz7ijz','Edward Collier','FIXED',NULL,37,37,'cmgz1nszg003bo7nab11if7vu','PORTER',1,'2025-10-20 11:20:34.463','2025-10-20 11:20:34.463'),
('cmgz1nter0081o7na2w70vbrb','Phil Hollinshead','FIXED',NULL,37,37,'cmgz1nsza0039o7nasz09g425','PORTER',1,'2025-10-20 11:20:34.468','2025-10-20 11:20:34.468'),
('cmgz1ntew0083o7nazoa91xr8','Kevin Tomlinson','FIXED',NULL,37,37,NULL,'PORTER',1,'2025-10-20 11:20:34.473','2025-10-20 11:20:34.473'),
('cmgz1ntf10085o7nasvaf3tf2','Soloman Offei','FIXED',NULL,37,37,NULL,'PORTER',1,'2025-10-20 11:20:34.477','2025-10-20 11:20:34.477'),
('cmgz1ntfr0087o7naejb2ios5','Colin Bromley','RELIEF',NULL,20,20,NULL,'PORTER',0,'2025-10-20 11:20:34.503','2025-10-20 11:20:34.503'),
('cmgz1ntfw0089o7nabhfjdy9w','Lynne Warner','FIXED',NULL,37,37,NULL,'PORTER',1,'2025-10-20 11:20:34.508','2025-10-20 11:20:34.508'),
('cmgz1ntg2008bo7naf715fl36','Roy Harris','FIXED',NULL,37,37,NULL,'PORTER',1,'2025-10-20 11:20:34.514','2025-10-20 11:20:34.514'),
('cmgz1ntg6008do7nabbtvm1n0','Kyle Sanderson','FIXED',NULL,37,37,NULL,'PORTER',1,'2025-10-20 11:20:34.519','2025-10-20 11:20:34.519'),
('cmgz1ntgb008fo7na95ugieag','Peter Moss','FIXED',NULL,37,37,NULL,'PORTER',1,'2025-10-20 11:20:34.523','2025-10-20 11:20:34.523'),
('cmgz1ntgf008ho7nanesm6wa9','Chris Wardle','FIXED',NULL,37,37,NULL,'PORTER',1,'2025-10-20 11:20:34.528','2025-10-20 11:20:34.528'),
('cmgz1ntgk008jo7nauim6pmkm','Eloisa Andrew','FIXED',NULL,37,37,NULL,'PORTER',1,'2025-10-20 11:20:34.533','2025-10-20 11:20:34.533'),
('cmgz1ntgu008lo7natg6t49fq','Gary Bromley','FIXED',NULL,37,37,NULL,'PORTER',1,'2025-10-20 11:20:34.543','2025-10-20 11:20:34.543'),
('cmgz1nth3008no7na6kqbnwpn','Mike Brennan','FIXED',NULL,37,37,NULL,'PORTER',1,'2025-10-20 11:20:34.552','2025-10-20 11:20:34.552'),
('cmgz1nth8008po7naor6szyxt','Lucy Redfearn','SHIFT',NULL,37,37,NULL,'PORTER',1,'2025-10-20 11:20:34.557','2025-10-20 11:20:34.557'),
('cmgz1nthd008ro7naeijde3y1','Mark Dickinson','FIXED',NULL,37,37,NULL,'PORTER',1,'2025-10-20 11:20:34.561','2025-10-20 11:20:34.561'),
('cmgz1nthj008to7nage0hknjh','Paul Berry','FIXED',NULL,37,37,NULL,'PORTER',1,'2025-10-20 11:20:34.567','2025-10-20 11:20:34.567'),
('cmgz1ntho008vo7natvakso4i','Robert Frost','FIXED',NULL,37,37,NULL,'PORTER',1,'2025-10-20 11:20:34.572','2025-10-20 11:20:34.572'),
('cmgz1ntht008xo7na76zaxqsq','Andrew Gibson','FIXED',NULL,37,37,NULL,'PORTER',1,'2025-10-20 11:20:34.578','2025-10-20 11:20:34.578'),
('cmgz1nthy008zo7na66s2foo3','Nigel Beesley','FIXED',NULL,37,37,NULL,'PORTER',1,'2025-10-20 11:20:34.582','2025-10-20 11:20:34.582'),
('cmgz1nti70091o7naumaxd445','Andy Clayton','FIXED',NULL,37,37,NULL,'PORTER',1,'2025-10-20 11:20:34.591','2025-10-20 11:20:34.591'),
('cmgz1ntig0093o7nar250fnby','Matthew Rushton','FIXED',NULL,37,37,NULL,'PORTER',1,'2025-10-20 11:20:34.601','2025-10-20 11:20:34.601'),
('cmgz1ntim0095o7naickazxvk','Mark Haughton','FIXED',NULL,37,37,NULL,'PORTER',1,'2025-10-20 11:20:34.606','2025-10-20 11:20:34.606'),
('cmgz1ntir0097o7nat257o7xy','Graham Brown','FIXED',NULL,37,37,NULL,'PORTER',1,'2025-10-20 11:20:34.611','2025-10-20 11:20:34.611'),
('cmgz1ntiw0099o7nae7wbbr6a','Chris Huckaby','FIXED',NULL,37,37,NULL,'PORTER',1,'2025-10-20 11:20:34.616','2025-10-20 11:20:34.616'),
('cmgz1ntj1009bo7nahjc6w5be','Jason Newton','FIXED',NULL,37,37,NULL,'PORTER',1,'2025-10-20 11:20:34.621','2025-10-20 11:20:34.621'),
('cmgz1ntj5009do7na0pp7ndsb','Joe Redfearn','SHIFT',NULL,37,37,NULL,'PORTER',1,'2025-10-20 11:20:34.625','2025-10-20 11:20:34.625'),
('cmgz1ntjb009fo7nayu2qo0a9','Paul Flowers','FIXED',NULL,37,37,NULL,'PORTER',1,'2025-10-20 11:20:34.631','2025-10-20 11:20:34.631'),
('cmgz1ntjj009ho7nacelob8pa','Jake Moran','RELIEF',NULL,20,20,NULL,'PORTER',0,'2025-10-20 11:20:34.640','2025-10-20 11:20:34.640'),
('cmgz1ntjr009jo7napm54b60z','Gavin Marsden','SHIFT',NULL,37,37,NULL,'PORTER',1,'2025-10-20 11:20:34.648','2025-10-20 11:20:34.648'),
('cmgz1ntjy009lo7nakm8azuyi','Andrew Hassall','SHIFT',NULL,37,37,NULL,'PORTER',1,'2025-10-20 11:20:34.654','2025-10-20 11:20:34.654'),
('cmgz1ntk2009no7name6gm7wt','Alan Clark','SHIFT',NULL,37,37,NULL,'PORTER',1,'2025-10-20 11:20:34.658','2025-10-20 11:20:34.658'),
('cmgz1ntk8009po7na4u6b5k1u','Duane Kulikowski','FIXED',NULL,37,37,'cmgz1nsza0039o7nasz09g425','PORTER',1,'2025-10-20 11:20:34.664','2025-10-20 11:20:34.664'),
('cmgz1ntkc009ro7na7e4r1e90','Craig Butler','FIXED',NULL,37,37,NULL,'PORTER',1,'2025-10-20 11:20:34.669','2025-10-20 11:20:34.669'),
('cmgz1ntkh009to7nazq7n00si','George Willerton','RELIEF',NULL,20,20,NULL,'PORTER',0,'2025-10-20 11:20:34.674','2025-10-20 11:20:34.674');
/*!40000 ALTER TABLE `porters` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `service_capabilities`
--

DROP TABLE IF EXISTS `service_capabilities`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `service_capabilities` (
  `service_id` varchar(191) NOT NULL,
  `capability_id` varchar(191) NOT NULL,
  `required_level` enum('REQUIRED','PREFERRED') NOT NULL,
  PRIMARY KEY (`service_id`,`capability_id`),
  KEY `service_capabilities_capability_id_fkey` (`capability_id`),
  CONSTRAINT `service_capabilities_capability_id_fkey` FOREIGN KEY (`capability_id`) REFERENCES `capabilities` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `service_capabilities_service_id_fkey` FOREIGN KEY (`service_id`) REFERENCES `services` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `service_capabilities`
--

LOCK TABLES `service_capabilities` WRITE;
/*!40000 ALTER TABLE `service_capabilities` DISABLE KEYS */;
/*!40000 ALTER TABLE `service_capabilities` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `services`
--

DROP TABLE IF EXISTS `services`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `services` (
  `id` varchar(191) NOT NULL,
  `name` varchar(191) NOT NULL,
  `department_id` varchar(191) NOT NULL,
  `description` varchar(191) DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `inherits_schedule` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updated_at` datetime(3) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `services_department_id_fkey` (`department_id`),
  CONSTRAINT `services_department_id_fkey` FOREIGN KEY (`department_id`) REFERENCES `departments` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `services`
--

LOCK TABLES `services` WRITE;
/*!40000 ALTER TABLE `services` DISABLE KEYS */;
INSERT INTO `services` VALUES
('cmgz1nt1z0045o7napmumyeg5','Patient Transport','cmgz1nswh002bo7naahnoqotd','Patient Transport service',1,1,'2025-10-20 11:20:34.007','2025-10-20 11:20:34.007'),
('cmgz1nt260047o7narqq3jh9e','District Drivers','cmgz1nsqu000ho7na31tg4hnv','District Drivers service',1,1,'2025-10-20 11:20:34.014','2025-10-20 11:20:34.014'),
('cmgz1nt2b0049o7nabjvv5kkl','Medical Records','cmgz1nsuq001ro7nat7d628jz','Medical Records service',1,1,'2025-10-20 11:20:34.019','2025-10-20 11:20:34.019'),
('cmgz1nt2f004bo7na42kgxxag','Post','cmgz1nsqu000ho7na31tg4hnv','Post service',1,1,'2025-10-20 11:20:34.024','2025-10-20 11:20:34.024'),
('cmgz1nt2k004do7najzv42ay4','Stores','cmgz1nsvx0025o7naddqi0pkw','Stores service',1,1,'2025-10-20 11:20:34.029','2025-10-20 11:20:34.029'),
('cmgz1nt2p004fo7nai92lqq03','Blood Drivers','cmgz1nsqu000ho7na31tg4hnv','Blood Drivers service',1,1,'2025-10-20 11:20:34.033','2025-10-20 11:20:34.033'),
('cmgz1nt2y004ho7nar26mzy8f','Laundry','cmgz1nt11003vo7napta16xy9','Laundry service',1,1,'2025-10-20 11:20:34.042','2025-10-20 11:20:34.042'),
('cmgz1nt37004jo7na13skg3l7','External Waste','cmgz1nsqu000ho7na31tg4hnv','External Waste service',1,1,'2025-10-20 11:20:34.051','2025-10-20 11:20:34.051'),
('cmgz1nt3e004lo7na7k3csx8p','Ad-Hoc','cmgz1nsqu000ho7na31tg4hnv','Ad-Hoc service',1,1,'2025-10-20 11:20:34.058','2025-10-20 11:20:34.058'),
('cmgz1nt3k004no7naqhkr89gw','Pharmacy','cmgz1nt02003jo7na5y5y55m7','Pharmacy service',1,1,'2025-10-20 11:20:34.065','2025-10-20 11:20:34.065');
/*!40000 ALTER TABLE `services` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `shift_patterns`
--

DROP TABLE IF EXISTS `shift_patterns`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `shift_patterns` (
  `id` varchar(191) NOT NULL,
  `name` varchar(191) NOT NULL,
  `pattern_json` text NOT NULL,
  `description` varchar(191) DEFAULT NULL,
  `created_at` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updated_at` datetime(3) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

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
-- Table structure for table `shifts`
--

DROP TABLE IF EXISTS `shifts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `shifts` (
  `id` varchar(191) NOT NULL,
  `name` varchar(191) NOT NULL,
  `pattern_id` varchar(191) NOT NULL,
  `shift_mode` enum('DAY','NIGHT','MIXED') NOT NULL,
  `ident` varchar(191) NOT NULL,
  `days_on` int(11) NOT NULL,
  `days_off` int(11) NOT NULL,
  `offset_days` int(11) NOT NULL DEFAULT 0,
  `ground_zero` datetime(3) NOT NULL,
  `created_at` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updated_at` datetime(3) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `shifts_pattern_id_fkey` (`pattern_id`),
  CONSTRAINT `shifts_pattern_id_fkey` FOREIGN KEY (`pattern_id`) REFERENCES `shift_patterns` (`id`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `shifts`
--

LOCK TABLES `shifts` WRITE;
/*!40000 ALTER TABLE `shifts` DISABLE KEYS */;
/*!40000 ALTER TABLE `shifts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `system_settings`
--

DROP TABLE IF EXISTS `system_settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `system_settings` (
  `setting_key` varchar(191) NOT NULL,
  `setting_value` varchar(191) NOT NULL,
  `description` varchar(191) DEFAULT NULL,
  `updated_at` datetime(3) NOT NULL,
  PRIMARY KEY (`setting_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

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

--
-- Dumping events for database 'porter_management'
--

--
-- Dumping routines for database 'porter_management'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-10-20 11:26:31
