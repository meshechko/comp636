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
-- Dumping data for table `Author`
--

LOCK TABLES `Author` WRITE;
/*!40000 ALTER TABLE `Author` DISABLE KEYS */;
INSERT INTO `Author` VALUES (1,'Mark Lee'),(2,'Margaret Mitchell'),(3,'Suzanne Collins'),(4,'Harper Lee'),(5,'Jane Austen'),(6,'Stephenie Meyer'),(7,'George Orwell'),(8,'Markus Zusak'),(9,'Shel Silverstein'),(10,'Douglas Adams'),(11,'John Green'),(12,'JRR Tolkien'),(14,'Emily Bronte'),(15,'Dan Brown'),(16,'Lewis Carroll'),(17,'Veronica Roth'),(18,'Oscar Wilde'),(19,'William Golding'),(20,'Orson Scott Card'),(21,'Paulo Coelho'),(22,'Audrey Niffenegger'),(23,'Fyodor Dostoyevsky'),(24,'Charlotte Bronte'),(25,'EB White'),(26,'Stephen King'),(27,'Casandra Clare');
/*!40000 ALTER TABLE `Author` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `Book`
--

LOCK TABLES `Book` WRITE;
/*!40000 ALTER TABLE `Book` DISABLE KEYS */;
INSERT INTO `Book` VALUES (1,'The Lost Tribe','Penguin',1),(2,'Gone With the Wind','Hachette',2),(3,'Hunger Games','Hachette',3),(4,'To Kill a Mockingbird','Penguin',4),(5,'The Book Thief','Penguin',8),(6,'The Giving Tree','Penguin',9),(7,'Hitchhiker\'s Guide','Harper',10),(8,'Fault in Our Stars','Harper',11),(9,'Hobbit','Harper',12),(10,'Lord of the Rings','Penguin',12),(11,'Wuthering Heights','Penguin',14),(12,'The da Vinci Code','Penguin',15),(13,'Alice in Wonderland','Penguin',16),(14,'Divergent','Harper',17),(15,'The Picture of Dorian Gray','Harper',18),(16,'Lord of the Flies','Harper',19),(17,'Ender\'s Game','Harper',20),(18,'The Alchemist','Penguin',21),(19,'Time Traveler\'s Wife','Penguin',22),(20,'Crime & Punishment','Harper',23),(21,'Jane Eyre','Hachette',24),(22,'Charlotte\'s Web','Penguin',25),(23,'The Stand','Hachette',26),(24,'City of Bones','Harper',27);
/*!40000 ALTER TABLE `Book` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `Book_Copies`
--

LOCK TABLES `Book_Copies` WRITE;
/*!40000 ALTER TABLE `Book_Copies` DISABLE KEYS */;
INSERT INTO `Book_Copies` VALUES (1,4,2),(1,3,1),(1,1,1),(2,2,2),(2,1,1),(2,3,1),(3,1,1),(3,2,1),(3,4,1),(4,1,1),(4,2,1),(5,4,1),(5,3,2),(6,1,1),(7,2,1),(8,4,1),(9,2,1),(9,4,1),(10,1,1),(11,4,1),(12,2,1),(13,1,1),(13,2,1),(13,4,1),(14,4,1),(15,1,1),(16,1,1),(17,2,2),(18,3,1),(19,4,1),(20,2,1),(20,3,1),(21,4,1),(21,2,1),(22,2,1),(23,3,1),(24,1,1),(24,3,2);
/*!40000 ALTER TABLE `Book_Copies` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `Book_Loans`
--

LOCK TABLES `Book_Loans` WRITE;
/*!40000 ALTER TABLE `Book_Loans` DISABLE KEYS */;
INSERT INTO `Book_Loans` VALUES (1,4,2,'2021-05-30','2021-06-27',1),(1,4,6,'2021-05-30','2021-06-27',1),(1,1,2,'2021-05-30','2021-06-27',1),(1,3,11,'2021-05-30','2021-06-27',1),(2,1,2,'2021-05-30','2021-06-27',1),(2,3,222,'2021-05-30','2021-06-27',1),(2,1,6,'2021-05-30','2021-06-27',1),(2,3,222,'2021-05-30','2021-06-27',1),(3,4,2,'2021-05-30','2021-06-27',1),(3,2,6,'2021-05-30','2021-06-27',1),(4,2,67,'2021-05-30','2021-06-27',1),(4,1,2,'2021-05-30','2021-06-27',1),(13,4,2,'2021-05-30','2021-06-27',1),(13,2,6,'2021-05-30','2021-06-27',1),(13,4,11,'2021-05-30','2021-06-27',1),(13,2,2,'2021-05-30','2021-06-27',1),(13,4,2,'2021-05-30','2021-06-27',1),(13,2,6,'2021-05-30','2021-06-27',1),(13,1,11,'2021-05-30','2021-06-27',1),(13,1,2,'2021-05-30','2021-06-27',1),(13,4,2,'2021-05-30','2021-06-27',1),(13,2,6,'2021-05-30','2021-06-27',1),(13,4,2,'2021-05-30','2021-06-27',1),(13,2,6,'2021-05-30','2021-06-27',1),(13,4,2,'2021-05-30','2021-06-27',1),(13,2,34,'2021-05-30','2021-06-27',1),(13,4,2,'2021-05-30','2021-06-27',1),(13,2,67,'2021-05-30','2021-06-27',1),(13,4,11,'2021-05-30','2021-06-27',1),(13,2,67,'2021-05-30','2021-06-27',1),(13,1,222,'2021-05-30','2021-06-27',1),(5,4,2,'2021-05-31','2021-06-28',1),(5,3,2,'2021-05-31','2021-06-28',1),(1,1,2,'2021-05-31','2021-06-28',1),(1,3,67,'2021-05-31','2021-06-28',1),(1,4,222,'2021-05-31','2021-06-28',1),(1,4,34,'2021-05-31','2021-06-28',1),(13,2,6,'2021-05-31','2021-06-28',1),(13,1,34,'2021-05-31','2021-06-28',1),(13,4,222,'2021-05-31','2021-06-28',1),(1,3,6,'2021-05-31','2021-06-28',1),(1,4,11,'2021-05-31','2021-06-28',1),(13,2,11,'2021-05-31','2021-06-28',1),(1,4,67,'2021-05-31','2021-06-28',1),(24,3,11,'2021-05-31','2021-06-28',1),(24,1,34,'2021-05-31','2021-06-28',1),(24,3,222,'2021-05-31','2021-06-28',1),(3,4,2,'2021-05-31','2021-06-28',1),(3,1,11,'2021-05-31','2021-06-28',1),(3,2,222,'2021-05-31','2021-06-28',1),(1,4,6,'2021-06-05','2021-07-03',1),(13,1,34,'2021-06-06','2021-07-04',1),(13,1,222,'2021-06-06','2021-07-04',1),(24,1,6,'2021-05-06','2021-06-04',0),(1,4,2,'2021-06-06','2021-07-04',1),(1,4,2,'2021-06-06','2021-07-04',1);
/*!40000 ALTER TABLE `Book_Loans` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `Borrower`
--

LOCK TABLES `Borrower` WRITE;
/*!40000 ALTER TABLE `Borrower` DISABLE KEYS */;
INSERT INTO `Borrower` VALUES (2,'Rudolph Valentino','893 SE Tonaka Rd.',NULL),(6,'Terry Dunn','08 SW River Pkwy',NULL),(11,'Steve McQueen','8349 NW Broadway Ave.',NULL),(34,'Timmy Kindle','43 N Smith Ave.',NULL),(67,'Imma Reader','2464 NE Division St',NULL),(222,'John Slate','492 SE Bonita Rd.',NULL),(332,'Betty Simmons','2523 NE Market St.',NULL),(454,'Dan Smith','2409 SW 45th Ave.',NULL),(469,'Gary Carter','408 NW Beaverton Rd.',NULL),(889,'John Dunn','9953 SW 24th Ave.',NULL),(1853,'Gary Gumbel','0459 SW Livery Rd.',NULL),(2749,'George Carlin','8984 NW Miller Rd.',NULL),(3356,'Marcus Lee','24 N Williams Ave.',NULL),(7250,'Marcus Aurelius','8842 NW Cornelius St.',NULL),(8355,'Felix Unger','23445 NE Betheny Ave.',NULL),(8835,'Minnie Mouse','3409 NW Tacoma St.',NULL),(9267,'Allison Reynolds','4089 SW Tanager Dr.',NULL),(19347,'Freddy Krueger','23049 NW Moonbeam Ln.',NULL),(22455,'Jane Austen','6543 NE Denton St.',NULL),(45545,'George Orton','2308 SE Greystone St.',NULL),(234346,'Candy Cane','493 SW Hood St.',NULL),(882543,'Betty Rubble','409 SE Stone Ln.',NULL),(3434342,'Stephenie Meyer','240 SE Swail Ave.',NULL),(5454543,'Martin Zell','953 SE Carlton Ave.',NULL),(67787887,'Sheila Wozniak','2021 SE Milwaukie Ave',NULL);
/*!40000 ALTER TABLE `Borrower` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `Library_Branch`
--

LOCK TABLES `Library_Branch` WRITE;
/*!40000 ALTER TABLE `Library_Branch` DISABLE KEYS */;
INSERT INTO `Library_Branch` VALUES (1,'Sharpstown','12300 Main St'),(2,'Westview','5584 West Ave.'),(3,'Central','24 1st St'),(4,'Northtown','935 North St.');
/*!40000 ALTER TABLE `Library_Branch` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `Publisher`
--

LOCK TABLES `Publisher` WRITE;
/*!40000 ALTER TABLE `Publisher` DISABLE KEYS */;
INSERT INTO `Publisher` VALUES ('Hachette','555 W 52nd St, New York',NULL),('Harper','235 E Broadway St, New York',NULL),('Penguin','24 E 5th Ave, New York',NULL);
/*!40000 ALTER TABLE `Publisher` ENABLE KEYS */;
UNLOCK TABLES;

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

-- Dump completed on 2021-06-06 15:03:52
