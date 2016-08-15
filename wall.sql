-- MySQL dump 10.13  Distrib 5.7.12, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: walldb
-- ------------------------------------------------------
-- Server version	5.5.49-log

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
-- Table structure for table `comments`
--

DROP TABLE IF EXISTS `comments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `comments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `comment` longtext,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `user_id` int(11) NOT NULL,
  `message_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_comments_users1_idx` (`user_id`),
  KEY `fk_comments_messages1_idx` (`message_id`),
  CONSTRAINT `fk_comments_users1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_comments_messages1` FOREIGN KEY (`message_id`) REFERENCES `messages` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `comments`
--

LOCK TABLES `comments` WRITE;
/*!40000 ALTER TABLE `comments` DISABLE KEYS */;
INSERT INTO `comments` VALUES (1,'\"By men posing as armed police\".\r\nWe had a similar article just before the olympics opened and the victim said the same thing - he was robbed by men posing as police officers.','2016-08-15 01:08:07','2016-08-15 01:08:07',1,2),(2,'You never hear about the on-duty police in Brazil. It\'s always the off-duty cop that takes out an entire group of thugs who tried to rob somebody or someplace. Shoot-to-kill in Brazil!','2016-08-15 01:13:04','2016-08-15 01:13:04',2,2),(3,'Realistically, spend 15 minutes panicking and another 15 minutes running in a random direction','2016-08-15 01:14:30','2016-08-15 01:14:30',2,1),(4,'Hi, whats up ','2016-08-15 08:39:13','2016-08-15 08:39:13',3,2),(5,'That\'s pretty messed up man. Brazil is still pretty rough.','2016-08-15 08:42:22','2016-08-15 08:42:22',4,2),(6,'Ok buddy.','2016-08-15 08:44:09','2016-08-15 08:44:09',4,3),(7,'Ok buddy.','2016-08-15 09:04:11','2016-08-15 09:04:11',4,3),(11,'Delete ','2016-08-15 12:45:21','2016-08-15 12:45:21',5,7),(12,'New comment','2016-08-15 12:45:43','2016-08-15 12:45:43',5,3),(13,'Hi Elliot','2016-08-15 12:51:18','2016-08-15 12:51:18',1,4),(14,'but its not the next google','2016-08-15 12:55:31','2016-08-15 12:55:31',6,11),(15,'hey','2016-08-15 13:50:12','2016-08-15 13:50:12',7,15);
/*!40000 ALTER TABLE `comments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `messages`
--

DROP TABLE IF EXISTS `messages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `messages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `message` longtext,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_messages_users_idx` (`user_id`),
  CONSTRAINT `fk_messages_users` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `messages`
--

LOCK TABLES `messages` WRITE;
/*!40000 ALTER TABLE `messages` DISABLE KEYS */;
INSERT INTO `messages` VALUES (1,'For the next 24 hours, every single person on the planet will be trying to find and kill you. You are given a thirty minute head start. What is your plan?','2016-08-15 01:07:15','2016-08-15 01:07:15',1),(2,'Rio Olympics: US swimmer Ryan Lochte and three others robbed - BBC News','2016-08-15 01:07:38','2016-08-15 01:07:38',1),(3,'Humans have evolved a disproportionately large brain as a result of sizing each other up in large cooperative social groups, researchers have proposed.','2016-08-15 08:36:41','2016-08-15 08:36:41',2),(4,'Hey Phil','2016-08-15 08:41:53','2016-08-15 08:41:53',4),(7,'TIL Its been shown bronze medal winners are happier than silver medal winners. This is due to counterfactual thinking: the silver medalists are more likely to compare themselves with gold medalist, while the bronze medal winners are more likely to compare themselves with 4th place finishers.','2016-08-15 12:45:11','2016-08-15 12:45:11',5),(8,'We have two universal languages: mathematics, and music. One to describe the universe, and one to describe how we feel about it.','2016-08-15 12:50:39','2016-08-15 12:50:39',5),(9,'ELI5: what is that horrible tingling feeling you get in your chest and stomach when receiving bad news? or when something really hurts your feelings?','2016-08-15 12:53:11','2016-08-15 12:53:11',1),(11,'this is tight','2016-08-15 12:55:14','2016-08-15 12:55:14',6),(15,'hiii,great work!!!!!','2016-08-15 13:49:41','2016-08-15 13:49:41',7);
/*!40000 ALTER TABLE `messages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `first_name` varchar(255) DEFAULT NULL,
  `last_name` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'Philip','Vo','philiptranbavo@gmail.com','$2b$12$7Ca5mPvhN/bSI55t0PddauUJv0E.TuhWwRrduZIVZs.WNFGYzOvUO','2016-08-15 01:06:32','2016-08-15 01:06:32'),(2,'Jon','Snow','jonsnow@winterfell.com','$2b$12$OuRsHe/OKu9Ii87h2N9Q8uMsbmuzMSLiwps76QqoTPSz7dm85MVT.','2016-08-15 01:12:23','2016-08-15 01:12:23'),(3,'joey','sidhu','joeysidhu@yahoo.com','$2b$12$Ppkl2bO0wNFNR.Y7vFH64uuArHAhmSkqOGcHuN1awQAOBQnRVdTCe','2016-08-15 08:38:01','2016-08-15 08:38:01'),(4,'Elliot','Young','elliotsyoung@gmail.com','$2b$12$SDHJKGWYY4ydp5/mRgFwSuWYLssJmrQVRVkHOmaDHHKDiD4TOiJhK','2016-08-15 08:41:35','2016-08-15 08:41:35'),(5,'Philip','Vo','kevin@ucdavis.edu','$2b$12$edC9m9IZqszHcJ6.vbvgWeImPmmdri/qkeuDG5oEHvwf8ZF8cs5hS','2016-08-15 10:32:41','2016-08-15 10:32:41'),(6,'sonny','tosco','nuttnl@gmail.com','$2b$12$q1CTyxJDcMyc7/qpbnlPzO1lAzIcF10hXnDqDfoB4V/SghRtwq37.','2016-08-15 12:54:37','2016-08-15 12:54:37'),(7,'aman','deep','bhjbj@gmail.com','$2b$12$tAAS8ovwkdr3ldlFEirIS.LVYydLmLQjqakTDZ.LJPL0Kp.cS6li2','2016-08-15 13:49:09','2016-08-15 13:49:09');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2016-08-15 14:00:40
