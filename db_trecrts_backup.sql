-- MySQL dump 10.13  Distrib 5.7.18, for macos10.12 (x86_64)
--
-- Host: localhost    Database: trec_rts
-- ------------------------------------------------------
-- Server version	5.7.18

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `assessments_pulled`
--

DROP TABLE IF EXISTS `assessments_pulled`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `assessments_pulled` (
  `rowid` int(11) NOT NULL AUTO_INCREMENT,
  `clientid` varchar(12) DEFAULT NULL,
  `topid` text,
  `submitted` timestamp DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`rowid`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `assessments_pulled`
--

LOCK TABLES `assessments_pulled` WRITE;
/*!40000 ALTER TABLE `assessments_pulled` DISABLE KEYS */;
INSERT INTO `assessments_pulled` VALUES (1,'aRKzD4hVOV1I','1234','2017-06-09 13:32:14'),(2,'aRKzD4hVOV1I','1122','2017-06-09 13:32:39'),(3,'aRKzD4hVOV1I','1111','2017-06-09 13:32:51'),(4,'aRKzD4hVOV1I','5678','2017-06-09 13:55:40');
/*!40000 ALTER TABLE `assessments_pulled` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `clients`
--

DROP TABLE IF EXISTS `clients`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `clients` (
  `groupid` text,
  `clientid` varchar(12) DEFAULT NULL,
  `ip` varchar(30) DEFAULT NULL,
  `register_time` timestamp DEFAULT CURRENT_TIMESTAMP,
  `alias` text,
  KEY `groupid` (`groupid`(40),`clientid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clients`
--

LOCK TABLES `clients` WRITE;
/*!40000 ALTER TABLE `clients` DISABLE KEYS */;
INSERT INTO `clients` VALUES ('mygroup','aRKzD4hVOV1I','::1','2017-05-31 00:14:36','MyBaseline'),('uwar','hcTCNQGClXaB','::1','2017-06-09 12:50:37','AdamsGroup'),('test3','1g3E001fKjhG','::1','2017-06-09 12:51:32','TestGroup3'),('salman','LryTAJahe9nG','::1','2017-06-09 12:52:18','SalmansGroup');
/*!40000 ALTER TABLE `clients` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `groups`
--

DROP TABLE IF EXISTS `groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `groups` (
  `groupid` text,
  `email` text,
  KEY `groupid` (`groupid`(40))
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `groups`
--

LOCK TABLES `groups` WRITE;
/*!40000 ALTER TABLE `groups` DISABLE KEYS */;
INSERT INTO `groups` VALUES ('uwar','aroegies@uwaterloo.ca'),('mygroup','mygroup@example.com'),('test3','test@email.com'),('salman','s43moham@uwaterloo.ca');
/*!40000 ALTER TABLE `groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `judgements`
--

DROP TABLE IF EXISTS `judgements`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `judgements` (
  `assessor` text NOT NULL,
  `topid` varchar(40) NOT NULL,
  `tweetid` text NOT NULL,
  `rel` int(11) DEFAULT '0',
  `submitted` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`assessor`(40),`topid`,`tweetid`(40)),
  KEY `assessor` (`assessor`(40),`topid`,`tweetid`(40))
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `judgements`
--

LOCK TABLES `judgements` WRITE;
/*!40000 ALTER TABLE `judgements` DISABLE KEYS */;
INSERT INTO `judgements` VALUES ('1','1111','871080786350424064',0,'2017-06-09 17:15:49'),('1','1111','871786010119618561',0,'2017-06-09 17:15:48'),('1','1111','872973674806104064',0,'2017-06-09 17:15:48'),('1','1111','873208318327758848',0,'2017-06-09 17:14:02'),('1','1111','873212534886735872',0,'2017-06-09 17:14:01'),('1','1111','873218638169374722',0,'2017-06-09 17:14:01'),('1','1122','871080786350424064',1,'2017-06-09 17:15:19'),('1','1122','871786010119618561',1,'2017-06-09 17:15:17'),('1','1122','872973674806104064',1,'2017-06-09 17:15:17'),('1','1122','873208318327758848',0,'2017-06-09 17:14:33'),('1','1122','873212534886735872',0,'2017-06-09 17:14:32'),('1','1122','873218638169374722',0,'2017-06-09 17:14:32'),('1','1234','868256575714021376',1,'2017-06-03 05:08:46'),('1','1234','871080786350424064',0,'2017-06-09 17:15:36'),('1','1234','871786010119618561',0,'2017-06-09 17:15:35'),('1','1234','872973674806104064',0,'2017-06-09 17:15:35'),('1','1234','873208318327758848',1,'2017-06-09 17:13:32'),('1','1234','873212534886735872',1,'2017-06-09 17:13:31'),('1','1234','873218638169374722',1,'2017-06-09 17:13:31'),('1','5678','871080786350424064',0,'2017-06-09 17:16:23'),('1','5678','871786010119618561',0,'2017-06-09 17:16:22'),('1','5678','872973674806104064',0,'2017-06-09 17:16:22'),('1','5678','873208318327758848',0,'2017-06-09 17:14:21'),('1','5678','873212534886735872',0,'2017-06-09 17:14:20'),('1','5678','873218638169374722',0,'2017-06-09 17:14:20'),('3','5678','873215884864761856',1,'2017-06-09 17:53:54'),('3','5678','873220352335392768',0,'2017-06-09 17:54:46');
/*!40000 ALTER TABLE `judgements` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `log_table`
--

DROP TABLE IF EXISTS `log_table`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `log_table` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `level` varchar(45) NOT NULL,
  `message` text NOT NULL,
  `timestamp` timestamp NOT NULL,
  `meta` varchar(255) DEFAULT NULL,
  `hostname` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id` (`id`,`level`,`message`(100),`meta`)
) ENGINE=InnoDB AUTO_INCREMENT=79 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `log_table`
--

LOCK TABLES `log_table` WRITE;
/*!40000 ALTER TABLE `log_table` DISABLE KEYS */;
INSERT INTO `log_table` VALUES (1,'info','::1 - - [31/May/2017:04:03:42 +0000] \"POST /register/system HTTP/1.1\" 500 60 \"-\" \"curl/7.52.1\"\n','2017-05-31 00:03:42',NULL,'Salmans-MBP'),(2,'info','::1 - - [31/May/2017:04:04:08 +0000] \"POST /register/system HTTP/1.1\" 500 60 \"-\" \"curl/7.52.1\"\n','2017-05-31 00:04:08',NULL,'Salmans-MBP'),(3,'info','::1 - - [31/May/2017:04:14:15 +0000] \"POST /register/system HTTP/1.1\" 500 60 \"-\" \"curl/7.52.1\"\n','2017-05-31 00:14:16',NULL,'Salmans-MBP'),(4,'info','::1 - - [31/May/2017:04:14:36 +0000] \"POST /register/system HTTP/1.1\" 200 27 \"-\" \"curl/7.52.1\"\n','2017-05-31 00:14:37',NULL,'Salmans-MBP'),(5,'info','::1 - - [31/May/2017:04:16:59 +0000] \"POST /tweet/1234/868256575714021376/47mP4lPAXXuc HTTP/1.1\" 500 53 \"-\" \"curl/7.52.1\"\n','2017-05-31 00:17:00',NULL,'Salmans-MBP'),(6,'info','::1 - - [31/May/2017:04:17:16 +0000] \"POST /tweet/1234/868256575714021376/aRKzD4hVOV1I HTTP/1.1\" 204 - \"-\" \"curl/7.52.1\"\n','2017-05-31 00:17:17',NULL,'Salmans-MBP'),(7,'info','::1 - - [31/May/2017:04:29:05 +0000] \"POST /tweet/1234/868256575714021376/aRKzD4hVOV1I HTTP/1.1\" 204 - \"-\" \"curl/7.52.1\"\n','2017-05-31 00:29:05',NULL,'Salmans-MBP'),(8,'info','::1 - - [31/May/2017:04:29:30 +0000] \"POST /tweet/1234/868256575714021376/aRKzD4hVOV1I HTTP/1.1\" 204 - \"-\" \"curl/7.52.1\"\n','2017-05-31 00:29:30',NULL,'Salmans-MBP'),(9,'info','::1 - - [31/May/2017:04:44:19 +0000] \"POST /tweet/1234/868256575714021376/aRKzD4hVOV1I HTTP/1.1\" 204 - \"-\" \"curl/7.52.1\"\n','2017-05-31 00:44:19',NULL,'Salmans-MBP'),(10,'info','::1 - - [31/May/2017:04:46:17 +0000] \"POST /tweet/1234/868256575714021376/aRKzD4hVOV1I HTTP/1.1\" 204 - \"-\" \"curl/7.52.1\"\n','2017-05-31 00:46:18',NULL,'Salmans-MBP'),(11,'info','::1 - - [31/May/2017:04:48:09 +0000] \"POST /tweet/1234/868256575714021376/aRKzD4hVOV1I HTTP/1.1\" 204 - \"-\" \"curl/7.52.1\"\n','2017-05-31 00:48:09',NULL,'Salmans-MBP'),(12,'info','::1 - - [31/May/2017:04:52:30 +0000] \"POST /tweet/1234/868256575714021376/aRKzD4hVOV1I HTTP/1.1\" 204 - \"-\" \"curl/7.52.1\"\n','2017-05-31 00:52:31',NULL,'Salmans-MBP'),(13,'info','::1 - - [31/May/2017:04:55:34 +0000] \"POST /tweet/1234/868256575714021376/aRKzD4hVOV1I HTTP/1.1\" 204 - \"-\" \"curl/7.52.1\"\n','2017-05-31 00:55:34',NULL,'Salmans-MBP'),(14,'info','::1 - - [31/May/2017:04:57:23 +0000] \"POST /tweet/1234/868256575714021376/aRKzD4hVOV1I HTTP/1.1\" 204 - \"-\" \"curl/7.52.1\"\n','2017-05-31 00:57:24',NULL,'Salmans-MBP'),(15,'info','::1 - - [31/May/2017:04:59:10 +0000] \"POST /tweet/1234/868256575714021376/aRKzD4hVOV1I HTTP/1.1\" 204 - \"-\" \"curl/7.52.1\"\n','2017-05-31 00:59:10',NULL,'Salmans-MBP'),(16,'info','::1 - - [31/May/2017:05:02:01 +0000] \"POST /tweet/1234/868256575714021376/aRKzD4hVOV1I HTTP/1.1\" 204 - \"-\" \"curl/7.52.1\"\n','2017-05-31 01:02:02',NULL,'Salmans-MBP'),(17,'info','::1 - - [31/May/2017:05:02:39 +0000] \"POST /tweet/1234/868256575714021376/aRKzD4hVOV1I HTTP/1.1\" 204 - \"-\" \"curl/7.52.1\"\n','2017-05-31 01:02:40',NULL,'Salmans-MBP'),(18,'info','::1 - - [31/May/2017:05:03:13 +0000] \"POST /tweet/1234/868256575714021376/aRKzD4hVOV1I HTTP/1.1\" 204 - \"-\" \"curl/7.52.1\"\n','2017-05-31 01:03:13',NULL,'Salmans-MBP'),(19,'info','::1 - - [31/May/2017:05:04:03 +0000] \"POST /tweet/1234/868256575714021376/aRKzD4hVOV1I HTTP/1.1\" 204 - \"-\" \"curl/7.52.1\"\n','2017-05-31 01:04:03',NULL,'Salmans-MBP'),(20,'info','::1 - - [31/May/2017:05:04:44 +0000] \"POST /tweet/1234/868256575714021376/aRKzD4hVOV1I HTTP/1.1\" 204 - \"-\" \"curl/7.52.1\"\n','2017-05-31 01:04:44',NULL,'Salmans-MBP'),(21,'info','::1 - - [31/May/2017:05:10:18 +0000] \"POST /tweet/1234/868256575714021376/aRKzD4hVOV1I HTTP/1.1\" 204 - \"-\" \"curl/7.52.1\"\n','2017-05-31 01:10:18',NULL,'Salmans-MBP'),(22,'info','::1 - - [31/May/2017:05:11:21 +0000] \"POST /tweet/1234/868256575714021376/aRKzD4hVOV1I HTTP/1.1\" 204 - \"-\" \"curl/7.52.1\"\n','2017-05-31 01:11:22',NULL,'Salmans-MBP'),(23,'info','::1 - - [31/May/2017:05:12:24 +0000] \"POST /tweet/1234/868256575714021376/aRKzD4hVOV1I HTTP/1.1\" 204 - \"-\" \"curl/7.52.1\"\n','2017-05-31 01:12:25',NULL,'Salmans-MBP'),(24,'info','::1 - - [31/May/2017:05:16:02 +0000] \"POST /tweet/1234/868256575714021376/aRKzD4hVOV1I HTTP/1.1\" 204 - \"-\" \"curl/7.52.1\"\n','2017-05-31 01:16:02',NULL,'Salmans-MBP'),(25,'info','::1 - - [01/Jun/2017:16:55:44 +0000] \"POST /tweet/1234/868256575714021376/aRKzD4hVOV1I HTTP/1.1\" 204 - \"-\" \"curl/7.52.1\"\n','2017-06-01 12:55:45',NULL,'v1020-wn-36-214.campus-dynamic.uwaterloo.ca'),(26,'info','::1 - - [01/Jun/2017:16:56:37 +0000] \"POST /tweet/1234/868256575714021376/aRKzD4hVOV1I HTTP/1.1\" 204 - \"-\" \"curl/7.52.1\"\n','2017-06-01 12:56:38',NULL,'v1020-wn-36-214.campus-dynamic.uwaterloo.ca'),(27,'info','::1 - - [01/Jun/2017:16:59:46 +0000] \"POST /tweet/1234/868256575714021376/aRKzD4hVOV1I HTTP/1.1\" 204 - \"-\" \"curl/7.52.1\"\n','2017-06-01 12:59:47',NULL,'v1020-wn-36-214.campus-dynamic.uwaterloo.ca'),(28,'info','::1 - - [01/Jun/2017:17:01:16 +0000] \"POST /tweet/1234/868256575714021376/aRKzD4hVOV1I HTTP/1.1\" 204 - \"-\" \"curl/7.52.1\"\n','2017-06-01 13:01:17',NULL,'v1020-wn-36-214.campus-dynamic.uwaterloo.ca'),(29,'info','::1 - - [01/Jun/2017:17:03:29 +0000] \"POST /tweet/1234/869636558374281217/aRKzD4hVOV1I HTTP/1.1\" 204 - \"-\" \"curl/7.52.1\"\n','2017-06-01 13:03:30',NULL,'v1020-wn-36-214.campus-dynamic.uwaterloo.ca'),(30,'info','::1 - - [01/Jun/2017:17:05:34 +0000] \"POST /tweet/1234/869636558374281217/aRKzD4hVOV1I HTTP/1.1\" 204 - \"-\" \"curl/7.52.1\"\n','2017-06-01 13:05:35',NULL,'v1020-wn-36-214.campus-dynamic.uwaterloo.ca'),(31,'info','::1 - - [01/Jun/2017:17:07:56 +0000] \"POST /tweet/1234/870314146499309574/aRKzD4hVOV1I HTTP/1.1\" 204 - \"-\" \"curl/7.52.1\"\n','2017-06-01 13:07:57',NULL,'v1020-wn-36-214.campus-dynamic.uwaterloo.ca'),(32,'info','::1 - - [01/Jun/2017:17:14:31 +0000] \"POST /tweet/1234/870277412831068160/aRKzD4hVOV1I HTTP/1.1\" 204 - \"-\" \"curl/7.52.1\"\n','2017-06-01 13:14:31',NULL,'v1020-wn-36-214.campus-dynamic.uwaterloo.ca'),(33,'info','::1 - - [03/Jun/2017:03:55:42 +0000] \"POST /tweet/1234/868256575714021376/aRKzD4hVOV1I HTTP/1.1\" 204 - \"-\" \"curl/7.52.1\"\n','2017-06-02 23:55:42',NULL,'Salmans-MBP'),(34,'info','::1 - - [03/Jun/2017:03:58:42 +0000] \"POST /tweet/1234/868256575714021376/aRKzD4hVOV1I HTTP/1.1\" 204 - \"-\" \"curl/7.52.1\"\n','2017-06-02 23:58:43',NULL,'Salmans-MBP'),(35,'info','::1 - - [03/Jun/2017:03:59:01 +0000] \"GET /judge/1234/868256575714021376/1/1 HTTP/1.1\" 204 - \"-\" \"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.36\"\n','2017-06-02 23:59:02',NULL,'Salmans-MBP'),(36,'info','::1 - - [03/Jun/2017:04:00:56 +0000] \"GET /judge/1234/868256575714021376/0/1 HTTP/1.1\" 204 - \"-\" \"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.36\"\n','2017-06-03 00:00:56',NULL,'Salmans-MBP'),(37,'info','::1 - - [03/Jun/2017:04:25:00 +0000] \"POST /tweet/1234/868256575714021376/aRKzD4hVOV1I HTTP/1.1\" 204 - \"-\" \"curl/7.52.1\"\n','2017-06-03 00:25:00',NULL,'Salmans-MBP'),(38,'info','::1 - - [03/Jun/2017:04:25:09 +0000] \"GET /judge/1234/868256575714021376/1/1 HTTP/1.1\" 500 44 \"-\" \"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.36\"\n','2017-06-03 00:25:10',NULL,'Salmans-MBP'),(39,'info','::1 - - [03/Jun/2017:04:25:10 +0000] \"GET /favicon.ico HTTP/1.1\" 404 1245 \"http://localhost:10101/judge/1234/868256575714021376/1/1\" \"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.36\"\n','2017-06-03 00:25:11',NULL,'Salmans-MBP'),(40,'info','::1 - - [03/Jun/2017:04:28:13 +0000] \"POST /tweet/1234/868256575714021376/aRKzD4hVOV1I HTTP/1.1\" 204 - \"-\" \"curl/7.52.1\"\n','2017-06-03 00:28:14',NULL,'Salmans-MBP'),(41,'info','::1 - - [03/Jun/2017:04:28:35 +0000] \"GET /judge/1234/868256575714021376/0/1 HTTP/1.1\" 500 44 \"-\" \"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.36\"\n','2017-06-03 00:28:36',NULL,'Salmans-MBP'),(42,'info','::1 - - [03/Jun/2017:04:29:27 +0000] \"POST /tweet/1234/868256575714021376/aRKzD4hVOV1I HTTP/1.1\" 204 - \"-\" \"curl/7.52.1\"\n','2017-06-03 00:29:28',NULL,'Salmans-MBP'),(43,'info','::1 - - [03/Jun/2017:04:29:36 +0000] \"GET /judge/1234/868256575714021376/0/1 HTTP/1.1\" 500 44 \"-\" \"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.36\"\n','2017-06-03 00:29:36',NULL,'Salmans-MBP'),(44,'info','::1 - - [03/Jun/2017:04:30:48 +0000] \"POST /tweet/1234/868256575714021376/aRKzD4hVOV1I HTTP/1.1\" 204 - \"-\" \"curl/7.52.1\"\n','2017-06-03 00:30:49',NULL,'Salmans-MBP'),(45,'info','::1 - - [03/Jun/2017:04:30:52 +0000] \"GET /judge/1234/868256575714021376/0/1 HTTP/1.1\" 204 - \"-\" \"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.36\"\n','2017-06-03 00:30:52',NULL,'Salmans-MBP'),(46,'info','::1 - - [03/Jun/2017:04:33:30 +0000] \"POST /tweet/1234/868256575714021376/aRKzD4hVOV1I HTTP/1.1\" 204 - \"-\" \"curl/7.52.1\"\n','2017-06-03 00:33:30',NULL,'Salmans-MBP'),(47,'info','::1 - - [03/Jun/2017:04:33:42 +0000] \"GET /judge/1234/868256575714021376/1/1 HTTP/1.1\" 204 - \"-\" \"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.36\"\n','2017-06-03 00:33:42',NULL,'Salmans-MBP'),(48,'info','::1 - - [03/Jun/2017:04:34:37 +0000] \"GET /judge/1234/868256575714021376/0/1 HTTP/1.1\" 204 - \"-\" \"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.36\"\n','2017-06-03 00:34:37',NULL,'Salmans-MBP'),(49,'info','::1 - - [03/Jun/2017:04:35:18 +0000] \"POST /tweet/1234/868256575714021376/aRKzD4hVOV1I HTTP/1.1\" 204 - \"-\" \"curl/7.52.1\"\n','2017-06-03 00:35:18',NULL,'Salmans-MBP'),(50,'info','::1 - - [03/Jun/2017:04:36:42 +0000] \"GET /judge/1234/868256575714021376/2/1 HTTP/1.1\" 204 - \"-\" \"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.36\"\n','2017-06-03 00:36:42',NULL,'Salmans-MBP'),(51,'info','::1 - - [03/Jun/2017:05:08:46 +0000] \"GET /judge/1234/868256575714021376/1/1 HTTP/1.1\" 204 - \"-\" \"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.36\"\n','2017-06-03 01:08:47',NULL,'Salmans-MBP'),(52,'info','::1 - - [03/Jun/2017:05:38:24 +0000] \"POST /assessments/1234/aRKzD4hVOV1I HTTP/1.1\" 200 57 \"-\" \"curl/7.52.1\"\n','2017-06-03 01:38:25',NULL,'Salmans-MBP'),(53,'info','::1 - - [03/Jun/2017:06:06:08 +0000] \"POST /tweet/1234/868256575714021376/aRKzD4hVOV1I HTTP/1.1\" 204 - \"-\" \"curl/7.52.1\"\n','2017-06-03 02:06:09',NULL,'Salmans-MBP'),(54,'info','::1 - - [09/Jun/2017:16:48:55 +0000] \"POST /register/system HTTP/1.1\" 500 61 \"-\" \"curl/7.52.1\"\n','2017-06-09 12:48:56',NULL,'v1020-wn-95-89.campus-dynamic.uwaterloo.ca'),(55,'info','::1 - - [09/Jun/2017:16:49:35 +0000] \"POST /register/system HTTP/1.1\" 500 59 \"-\" \"curl/7.52.1\"\n','2017-06-09 12:49:36',NULL,'v1020-wn-95-89.campus-dynamic.uwaterloo.ca'),(56,'info','::1 - - [09/Jun/2017:16:50:37 +0000] \"POST /register/system HTTP/1.1\" 200 27 \"-\" \"curl/7.52.1\"\n','2017-06-09 12:50:38',NULL,'v1020-wn-95-89.campus-dynamic.uwaterloo.ca'),(57,'info','::1 - - [09/Jun/2017:16:51:32 +0000] \"POST /register/system HTTP/1.1\" 200 27 \"-\" \"curl/7.52.1\"\n','2017-06-09 12:51:33',NULL,'v1020-wn-95-89.campus-dynamic.uwaterloo.ca'),(58,'info','::1 - - [09/Jun/2017:16:52:18 +0000] \"POST /register/system HTTP/1.1\" 200 27 \"-\" \"curl/7.52.1\"\n','2017-06-09 12:52:19',NULL,'v1020-wn-95-89.campus-dynamic.uwaterloo.ca'),(59,'info','::1 - - [09/Jun/2017:17:18:33 +0000] \"POST /tweet/1234/873218638169374722/aRKzD4hVOV1I HTTP/1.1\" 204 - \"-\" \"curl/7.52.1\"\n','2017-06-09 13:18:33',NULL,'v1020-wn-95-89.campus-dynamic.uwaterloo.ca'),(60,'info','::1 - - [09/Jun/2017:17:19:30 +0000] \"POST /tweet/1234/873212534886735872/aRKzD4hVOV1I HTTP/1.1\" 204 - \"-\" \"curl/7.52.1\"\n','2017-06-09 13:19:30',NULL,'v1020-wn-95-89.campus-dynamic.uwaterloo.ca'),(61,'info','::1 - - [09/Jun/2017:17:20:02 +0000] \"POST /tweet/1234/873208318327758848/1g3E001fKjhG HTTP/1.1\" 204 - \"-\" \"curl/7.52.1\"\n','2017-06-09 13:20:02',NULL,'v1020-wn-95-89.campus-dynamic.uwaterloo.ca'),(62,'info','::1 - - [09/Jun/2017:17:20:12 +0000] \"POST /tweet/1234/873212534886735872/1g3E001fKjhG HTTP/1.1\" 204 - \"-\" \"curl/7.52.1\"\n','2017-06-09 13:20:13',NULL,'v1020-wn-95-89.campus-dynamic.uwaterloo.ca'),(63,'info','::1 - - [09/Jun/2017:17:21:34 +0000] \"POST /tweet/1234/871080786350424064/1g3E001fKjhG HTTP/1.1\" 204 - \"-\" \"curl/7.52.1\"\n','2017-06-09 13:21:35',NULL,'v1020-wn-95-89.campus-dynamic.uwaterloo.ca'),(64,'info','::1 - - [09/Jun/2017:17:22:00 +0000] \"POST /tweet/1234/872973674806104064/aRKzD4hVOV1I HTTP/1.1\" 204 - \"-\" \"curl/7.52.1\"\n','2017-06-09 13:22:00',NULL,'v1020-wn-95-89.campus-dynamic.uwaterloo.ca'),(65,'info','::1 - - [09/Jun/2017:17:22:28 +0000] \"POST /tweet/1122/872973674806104064/aRKzD4hVOV1I HTTP/1.1\" 204 - \"-\" \"curl/7.52.1\"\n','2017-06-09 13:22:29',NULL,'v1020-wn-95-89.campus-dynamic.uwaterloo.ca'),(66,'info','::1 - - [09/Jun/2017:17:22:40 +0000] \"POST /tweet/1122/871786010119618561/aRKzD4hVOV1I HTTP/1.1\" 204 - \"-\" \"curl/7.52.1\"\n','2017-06-09 13:22:41',NULL,'v1020-wn-95-89.campus-dynamic.uwaterloo.ca'),(67,'info','::1 - - [09/Jun/2017:17:22:51 +0000] \"POST /tweet/1122/871786010119618561/1g3E001fKjhG HTTP/1.1\" 204 - \"-\" \"curl/7.52.1\"\n','2017-06-09 13:22:52',NULL,'v1020-wn-95-89.campus-dynamic.uwaterloo.ca'),(68,'info','::1 - - [09/Jun/2017:17:24:53 +0000] \"POST /assessments/1234/aRKzD4hVOV1I HTTP/1.1\" 500 77 \"-\" \"curl/7.52.1\"\n','2017-06-09 13:24:54',NULL,'v1020-wn-95-89.campus-dynamic.uwaterloo.ca'),(69,'info','::1 - - [09/Jun/2017:17:32:14 +0000] \"POST /assessments/1234/aRKzD4hVOV1I HTTP/1.1\" 200 225 \"-\" \"curl/7.52.1\"\n','2017-06-09 13:32:14',NULL,'v1020-wn-95-89.campus-dynamic.uwaterloo.ca'),(70,'info','::1 - - [09/Jun/2017:17:32:39 +0000] \"POST /assessments/1122/aRKzD4hVOV1I HTTP/1.1\" 200 113 \"-\" \"curl/7.52.1\"\n','2017-06-09 13:32:40',NULL,'v1020-wn-95-89.campus-dynamic.uwaterloo.ca'),(71,'info','::1 - - [09/Jun/2017:17:32:51 +0000] \"POST /assessments/1111/aRKzD4hVOV1I HTTP/1.1\" 200 2 \"-\" \"curl/7.52.1\"\n','2017-06-09 13:32:51',NULL,'v1020-wn-95-89.campus-dynamic.uwaterloo.ca'),(72,'info','::1 - - [09/Jun/2017:17:33:55 +0000] \"POST /assessments/1111/aRKzD4hVOV1I HTTP/1.1\" 429 105 \"-\" \"curl/7.52.1\"\n','2017-06-09 13:33:56',NULL,'v1020-wn-95-89.campus-dynamic.uwaterloo.ca'),(73,'info','::1 - - [09/Jun/2017:17:40:34 +0000] \"POST /tweet/1234/873220352335392768/LryTAJahe9nG HTTP/1.1\" 204 - \"-\" \"curl/7.52.1\"\n','2017-06-09 13:40:34',NULL,'v1020-wn-95-89.campus-dynamic.uwaterloo.ca'),(74,'info','::1 - - [09/Jun/2017:17:53:42 +0000] \"POST /tweet/5678/873215884864761856/aRKzD4hVOV1I HTTP/1.1\" 204 - \"-\" \"curl/7.52.1\"\n','2017-06-09 13:53:42',NULL,'v1020-wn-95-89.campus-dynamic.uwaterloo.ca'),(75,'info','::1 - - [09/Jun/2017:17:53:54 +0000] \"GET /judge/5678/873215884864761856/1/3 HTTP/1.1\" 204 - \"-\" \"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.36\"\n','2017-06-09 13:53:55',NULL,'v1020-wn-95-89.campus-dynamic.uwaterloo.ca'),(76,'info','::1 - - [09/Jun/2017:17:54:29 +0000] \"POST /tweet/5678/873220352335392768/aRKzD4hVOV1I HTTP/1.1\" 204 - \"-\" \"curl/7.52.1\"\n','2017-06-09 13:54:29',NULL,'v1020-wn-95-89.campus-dynamic.uwaterloo.ca'),(77,'info','::1 - - [09/Jun/2017:17:54:46 +0000] \"GET /judge/5678/873220352335392768/0/3 HTTP/1.1\" 204 - \"-\" \"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.36\"\n','2017-06-09 13:54:46',NULL,'v1020-wn-95-89.campus-dynamic.uwaterloo.ca'),(78,'info','::1 - - [09/Jun/2017:17:55:40 +0000] \"POST /assessments/5678/aRKzD4hVOV1I HTTP/1.1\" 200 113 \"-\" \"curl/7.52.1\"\n','2017-06-09 13:55:40',NULL,'v1020-wn-95-89.campus-dynamic.uwaterloo.ca');
/*!40000 ALTER TABLE `log_table` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `participants`
--

DROP TABLE IF EXISTS `participants`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `participants` (
  `partid` varchar(40) NOT NULL,
  `email` text,
  `twitterhandle` text,
  `deviceid` text,
  PRIMARY KEY (`partid`),
  KEY `partid` (`partid`,`deviceid`(40))
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `participants`
--

LOCK TABLES `participants` WRITE;
/*!40000 ALTER TABLE `participants` DISABLE KEYS */;
INSERT INTO `participants` VALUES ('1','trec.rts.assessor1@gmail.com','rts_assessor1',NULL),('2','jimmylin@uwaterloo.ca','lintool',NULL),('3','s43moham@uwaterloo.ca','smohammed93',NULL),('batman','batman@batcave.org','batman_tweets',NULL);
/*!40000 ALTER TABLE `participants` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `requests`
--

DROP TABLE IF EXISTS `requests`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `requests` (
  `topid` varchar(40) DEFAULT NULL,
  `tweetid` text,
  `clientid` varchar(12) DEFAULT NULL,
  `submitted` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  KEY `topid` (`topid`,`tweetid`(40),`clientid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `requests`
--

LOCK TABLES `requests` WRITE;
/*!40000 ALTER TABLE `requests` DISABLE KEYS */;
INSERT INTO `requests` VALUES ('1234','868256575714021376','aRKzD4hVOV1I','2017-06-03 06:06:08'),('1234','873218638169374722','aRKzD4hVOV1I','2017-06-09 17:18:33'),('1234','873212534886735872','aRKzD4hVOV1I','2017-06-09 17:19:30'),('1234','873208318327758848','1g3E001fKjhG','2017-06-09 17:20:02'),('1234','873212534886735872','1g3E001fKjhG','2017-06-09 17:20:12'),('1234','871080786350424064','1g3E001fKjhG','2017-06-09 17:21:34'),('1234','872973674806104064','aRKzD4hVOV1I','2017-06-09 17:22:00'),('1122','872973674806104064','aRKzD4hVOV1I','2017-06-09 17:22:28'),('1122','871786010119618561','aRKzD4hVOV1I','2017-06-09 17:22:40'),('1122','871786010119618561','1g3E001fKjhG','2017-06-09 17:22:51'),('1234','873220352335392768','LryTAJahe9nG','2017-06-09 17:40:34'),('5678','873215884864761856','aRKzD4hVOV1I','2017-06-09 17:53:42'),('5678','873220352335392768','aRKzD4hVOV1I','2017-06-09 17:54:29');
/*!40000 ALTER TABLE `requests` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `seen`
--

DROP TABLE IF EXISTS `seen`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `seen` (
  `tweetid` text,
  `topid` varchar(40) DEFAULT NULL,
  KEY `tweetid` (`tweetid`(40),`topid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `seen`
--

LOCK TABLES `seen` WRITE;
/*!40000 ALTER TABLE `seen` DISABLE KEYS */;
INSERT INTO `seen` VALUES ('868256575714021376','1234'),('873218638169374722','1234'),('873212534886735872','1234'),('873208318327758848','1234'),('871080786350424064','1234'),('872973674806104064','1234'),('872973674806104064','1122'),('871786010119618561','1122'),('873220352335392768','1234'),('873215884864761856','5678'),('873220352335392768','5678');
/*!40000 ALTER TABLE `seen` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `topic_assignments`
--

DROP TABLE IF EXISTS `topic_assignments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `topic_assignments` (
  `topid` varchar(40) NOT NULL,
  `partid` varchar(40) NOT NULL,
  PRIMARY KEY (`topid`,`partid`),
  KEY `topid` (`topid`,`partid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `topic_assignments`
--

LOCK TABLES `topic_assignments` WRITE;
/*!40000 ALTER TABLE `topic_assignments` DISABLE KEYS */;
INSERT INTO `topic_assignments` VALUES ('1111','1'),('1111','3'),('1122','1'),('1234','1'),('1234','2'),('5678','3');
/*!40000 ALTER TABLE `topic_assignments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `topics`
--

DROP TABLE IF EXISTS `topics`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `topics` (
  `topid` varchar(20) NOT NULL,
  `title` text,
  `description` text,
  `narrative` text,
  PRIMARY KEY (`topid`),
  KEY `topid` (`topid`,`title`(40),`description`(40),`narrative`(40))
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `topics`
--

LOCK TABLES `topics` WRITE;
/*!40000 ALTER TABLE `topics` DISABLE KEYS */;
INSERT INTO `topics` VALUES ('1111','sports tweets','any tweet related to sports - hockey, soccer, etc.','tweets on sports topic'),('1122','random tweets','descr - all other tweets','narrative - other tweets'),('1234','political tweets','any tweet related to politics - us, canada, etc.','tweets on political topic'),('5678','science tech','any tweet related to tech/gadgets/science','tweets on science tech topic');
/*!40000 ALTER TABLE `topics` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2017-06-09 13:56:17
