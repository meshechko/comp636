-- MySQL dump 10.13  Distrib 8.0.25, for macos11 (x86_64)
--
-- Host: localhost    Database: Library
-- ------------------------------------------------------
-- Server version	8.0.25

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `Author`
--

DROP TABLE IF EXISTS `Author`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Author` (
  `AuthorId` int NOT NULL,
  `AuthorName` varchar(50) NOT NULL,
  PRIMARY KEY (`AuthorId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Book`
--

DROP TABLE IF EXISTS `Book`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Book` (
  `BookId` int NOT NULL,
  `Title` varchar(50) NOT NULL,
  `PublisherName` varchar(50) NOT NULL,
  `Author` int NOT NULL,
  PRIMARY KEY (`BookId`),
  KEY `PublisherName` (`PublisherName`),
  KEY `Author` (`Author`),
  CONSTRAINT `book_ibfk_1` FOREIGN KEY (`PublisherName`) REFERENCES `Publisher` (`Name`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `book_ibfk_2` FOREIGN KEY (`Author`) REFERENCES `Author` (`AuthorId`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Book_Copies`
--

DROP TABLE IF EXISTS `Book_Copies`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Book_Copies` (
  `BookId` int NOT NULL,
  `BranchId` int NOT NULL,
  `No_Of_Copies` int NOT NULL,
  KEY `BookId` (`BookId`),
  KEY `BranchId` (`BranchId`),
  CONSTRAINT `book_copies_ibfk_1` FOREIGN KEY (`BookId`) REFERENCES `Book` (`BookId`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `book_copies_ibfk_2` FOREIGN KEY (`BranchId`) REFERENCES `Library_Branch` (`BranchId`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Book_Loans`
--

DROP TABLE IF EXISTS `Book_Loans`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Book_Loans` (
  `BookId` int NOT NULL,
  `BranchId` int NOT NULL,
  `CardNo` int NOT NULL,
  `DateOut` date DEFAULT NULL,
  `DueDate` date DEFAULT NULL,
  `returned` tinyint(1) DEFAULT NULL,
  KEY `BookId` (`BookId`),
  KEY `BranchId` (`BranchId`),
  KEY `CardNo` (`CardNo`),
  CONSTRAINT `book_loans_ibfk_1` FOREIGN KEY (`BookId`) REFERENCES `Book` (`BookId`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `book_loans_ibfk_2` FOREIGN KEY (`BranchId`) REFERENCES `Library_Branch` (`BranchId`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `book_loans_ibfk_3` FOREIGN KEY (`CardNo`) REFERENCES `Borrower` (`CardNo`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Borrower`
--

DROP TABLE IF EXISTS `Borrower`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Borrower` (
  `CardNo` int NOT NULL,
  `Name` varchar(50) NOT NULL,
  `Address` varchar(50) DEFAULT NULL,
  `Phone` char(10) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  PRIMARY KEY (`CardNo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Library_Branch`
--

DROP TABLE IF EXISTS `Library_Branch`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Library_Branch` (
  `BranchId` int NOT NULL,
  `BranchName` varchar(50) NOT NULL,
  `Address` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`BranchId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Publisher`
--

DROP TABLE IF EXISTS `Publisher`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Publisher` (
  `Name` varchar(50) NOT NULL,
  `Address` varchar(50) DEFAULT NULL,
  `Phone` char(10) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  PRIMARY KEY (`Name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping routines for database 'Library'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2021-06-06 15:00:21
