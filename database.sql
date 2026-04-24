CREATE DATABASE  IF NOT EXISTS `inventory_db` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `inventory_db`;
-- MySQL dump 10.13  Distrib 8.0.44, for Win64 (x86_64)
--
-- Host: localhost    Database: inventory_db
-- ------------------------------------------------------
-- Server version	8.0.44

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
-- Table structure for table `categories`
--

DROP TABLE IF EXISTS `categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `categories` (
  `category_id` int NOT NULL AUTO_INCREMENT,
  `category_name` varchar(100) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`category_id`),
  UNIQUE KEY `category_name` (`category_name`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `categories`
--

LOCK TABLES `categories` WRITE;
/*!40000 ALTER TABLE `categories` DISABLE KEYS */;
INSERT INTO `categories` VALUES (1,'Electronics','Electronic gadgets and accessories'),(2,'Stationery','Office and school supplies'),(3,'Grocery','Daily use food and household items'),(4,'Furniture','Home and office furniture'),(5,'Sports','Sports and fitness equipment');
/*!40000 ALTER TABLE `categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customers`
--

DROP TABLE IF EXISTS `customers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `customers` (
  `customer_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `gender` enum('Male','Female','Other') DEFAULT NULL,
  `age` int DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `phone` varchar(15) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`customer_id`),
  UNIQUE KEY `email` (`email`),
  CONSTRAINT `customers_chk_1` CHECK (((`age` > 0) and (`age` < 120))),
  CONSTRAINT `customers_chk_2` CHECK ((`email` like _utf8mb4'%@gmail.com'))
) ENGINE=InnoDB AUTO_INCREMENT=33 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customers`
--

LOCK TABLES `customers` WRITE;
/*!40000 ALTER TABLE `customers` DISABLE KEYS */;
INSERT INTO `customers` VALUES (1,'Priya Sharma','Female',25,'priya.sharma@gmail.com','9988776655','Nashik, MH','2026-04-23 15:30:37'),(2,'Amit Patil','Male',32,'amit.patil@gmail.com','9876541230','Pune, MH','2026-04-23 15:30:37'),(3,'Sneha Kulkarni','Female',28,'sneha.kulkarni@gmail.com','9765432109','Mumbai, MH','2026-04-23 15:30:37'),(4,'Rohit Desai','Male',35,'rohit.desai@gmail.com','9654321098','Nagpur, MH','2026-04-23 15:30:37'),(5,'Kavya Nair','Female',22,'kavya.nair@gmail.com','9543210987','Kochi, KL','2026-04-23 15:30:37'),(6,'Arjun Mehta','Male',29,'arjun.mehta@gmail.com','9432109876','Ahmedabad, GJ','2026-04-23 15:30:37'),(7,'Divya Iyer','Female',31,'divya.iyer@gmail.com','9321098765','Chennai, TN','2026-04-23 15:30:37'),(8,'Suresh Pawar','Male',40,'suresh.pawar@gmail.com','9210987654','Kolhapur, MH','2026-04-23 15:30:37'),(9,'Meera Joshi','Female',27,'meera.joshi@gmail.com','9109876543','Indore, MP','2026-04-23 15:30:37'),(10,'Kiran Reddy','Male',33,'kiran.reddy@gmail.com','9098765432','Hyderabad, TS','2026-04-23 15:30:37'),(11,'Ankita Singh','Female',24,'ankita.singh@gmail.com','9087654321','Lucknow, UP','2026-04-23 15:30:37'),(12,'Vijay Kumar','Male',38,'vijay.kumar@gmail.com','9076543210','Delhi, NCR','2026-04-23 15:30:37'),(13,'Riya Tiwari','Female',21,'riya.tiwari@gmail.com','9065432109','Bhopal, MP','2026-04-23 15:30:37'),(14,'Nikhil Gupta','Male',26,'nikhil.gupta@gmail.com','9054321098','Jaipur, RJ','2026-04-23 15:30:37'),(15,'Pooja Pillai','Female',30,'pooja.pillai@gmail.com','9043210987','Trivandrum, KL','2026-04-23 15:30:37'),(16,'Rahul Yadav','Male',34,'rahul.yadav@gmail.com','9032109876','Varanasi, UP','2026-04-23 15:30:37'),(17,'Shruti Bhatt','Female',23,'shruti.bhatt@gmail.com','9021098765','Surat, GJ','2026-04-23 15:30:37'),(18,'Manish More','Male',37,'manish.more@gmail.com','9010987654','Aurangabad, MH','2026-04-23 15:30:37'),(19,'Neha Shinde','Female',29,'neha.shinde@gmail.com','8999876543','Solapur, MH','2026-04-23 15:30:37'),(20,'Aditya Patel','Male',31,'aditya.patel@gmail.com','8988765432','Vadodara, GJ','2026-04-23 15:30:37'),(21,'Rupali Chavan','Female',26,'rupali.chavan@gmail.com','8977654321','Satara, MH','2026-04-23 15:30:37'),(22,'Sameer Khan','Male',28,'sameer.khan@gmail.com','8966543210','Aurangabad, MH','2026-04-23 15:30:37'),(23,'Gauri Deshpande','Female',33,'gauri.deshpande@gmail.com','8955432109','Pune, MH','2026-04-23 15:30:37'),(24,'Tejas Naik','Male',22,'tejas.naik@gmail.com','8944321098','Goa','2026-04-23 15:30:37'),(25,'Pallavi Sawant','Female',36,'pallavi.sawant@gmail.com','8933210987','Ratnagiri, MH','2026-04-23 15:30:37'),(26,'Vishal Thakur','Male',41,'vishal.thakur@gmail.com','8922109876','Shimla, HP','2026-04-23 15:30:37'),(27,'Ashwini Gaikwad','Female',27,'ashwini.gaikwad@gmail.com','8911098765','Latur, MH','2026-04-23 15:30:37'),(28,'Prasad Kulkarni','Male',39,'prasad.kulkarni@gmail.com','8900987654','Nashik, MH','2026-04-23 15:30:37'),(29,'Sheya','Female',19,'shreya@gmail.com','9989672314','Pune MH','2026-04-24 13:45:18'),(30,'Darshan Walunj','Male',18,'darshan13@gmail.com','7766445523','Pune,MH','2026-04-24 13:51:43'),(31,'Riya Doke','Female',20,'riya03@gmail.com','7677238234','Mumbai,MH','2026-04-24 14:01:34'),(32,'Sakshi Walunj','Female',20,'Sak@gmail.com','984657869','Pune,MH','2026-04-24 14:17:03');
/*!40000 ALTER TABLE `customers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `products`
--

DROP TABLE IF EXISTS `products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `products` (
  `product_id` int NOT NULL AUTO_INCREMENT,
  `product_name` varchar(100) NOT NULL,
  `category_id` int DEFAULT NULL,
  `supplier_id` int DEFAULT NULL,
  `price` decimal(10,2) NOT NULL,
  `cost_price` decimal(10,2) NOT NULL,
  `unit` varchar(20) DEFAULT 'pcs',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`product_id`),
  KEY `fk_product_category` (`category_id`),
  KEY `fk_product_supplier` (`supplier_id`),
  CONSTRAINT `fk_product_category` FOREIGN KEY (`category_id`) REFERENCES `categories` (`category_id`) ON DELETE SET NULL,
  CONSTRAINT `fk_product_supplier` FOREIGN KEY (`supplier_id`) REFERENCES `suppliers` (`supplier_id`) ON DELETE SET NULL,
  CONSTRAINT `products_chk_1` CHECK ((`price` >= 0)),
  CONSTRAINT `products_chk_2` CHECK ((`cost_price` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=51 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `products`
--

LOCK TABLES `products` WRITE;
/*!40000 ALTER TABLE `products` DISABLE KEYS */;
INSERT INTO `products` VALUES (1,'USB Keyboard',1,1,799.00,550.00,'pcs','2026-04-23 15:29:08'),(2,'Wireless Mouse',1,1,499.00,320.00,'pcs','2026-04-23 15:29:08'),(3,'HDMI Cable 1.5m',1,6,249.00,140.00,'pcs','2026-04-23 15:29:08'),(4,'USB Hub 4 Port',1,6,399.00,220.00,'pcs','2026-04-23 15:29:08'),(5,'Laptop Stand',1,11,999.00,650.00,'pcs','2026-04-23 15:29:08'),(6,'Webcam 1080p',1,1,1499.00,950.00,'pcs','2026-04-23 15:29:08'),(7,'Bluetooth Speaker',1,6,1299.00,800.00,'pcs','2026-04-23 15:29:08'),(8,'Power Bank 10000mAh',1,11,1199.00,750.00,'pcs','2026-04-23 15:29:08'),(9,'Earphones Wired',1,6,349.00,200.00,'pcs','2026-04-23 15:29:08'),(10,'LED Desk Lamp',1,11,599.00,380.00,'pcs','2026-04-23 15:29:08'),(11,'A4 Notebook 200pg',2,2,85.00,50.00,'pcs','2026-04-23 15:29:08'),(12,'Ball Pen Blue (10pk)',2,7,50.00,28.00,'pack','2026-04-23 15:29:08'),(13,'Highlighter Set 6clr',2,7,99.00,58.00,'set','2026-04-23 15:29:08'),(14,'Stapler Medium',2,2,149.00,90.00,'pcs','2026-04-23 15:29:08'),(15,'Scissors 8 inch',2,12,59.00,35.00,'pcs','2026-04-23 15:29:08'),(16,'Glue Stick 40g',2,7,30.00,16.00,'pcs','2026-04-23 15:29:08'),(17,'Whiteboard Marker 4pk',2,12,75.00,42.00,'pack','2026-04-23 15:29:08'),(18,'Sticky Notes 100pg',2,2,40.00,22.00,'pcs','2026-04-23 15:29:08'),(19,'Ruler 30cm',2,12,25.00,12.00,'pcs','2026-04-23 15:29:08'),(20,'File Folder A4',2,7,35.00,18.00,'pcs','2026-04-23 15:29:08'),(21,'Basmati Rice 5kg',3,3,350.00,260.00,'bag','2026-04-23 15:29:08'),(22,'Toor Dal 1kg',3,8,120.00,88.00,'kg','2026-04-23 15:29:08'),(23,'Sunflower Oil 1L',3,13,140.00,105.00,'bottle','2026-04-23 15:29:08'),(24,'Wheat Flour 5kg',3,3,220.00,165.00,'bag','2026-04-23 15:29:08'),(25,'Sugar 1kg',3,8,55.00,42.00,'kg','2026-04-23 15:29:08'),(26,'Salt 1kg',3,13,20.00,12.00,'kg','2026-04-23 15:29:08'),(27,'Turmeric Powder 100g',3,8,45.00,30.00,'pcs','2026-04-23 15:29:08'),(28,'Chilli Powder 100g',3,3,50.00,33.00,'pcs','2026-04-23 15:29:08'),(29,'Tea Leaves 250g',3,13,110.00,78.00,'pcs','2026-04-23 15:29:08'),(30,'Biscuits Assorted 500g',3,8,80.00,55.00,'pcs','2026-04-23 15:29:08'),(31,'Office Chair',4,4,4500.00,3100.00,'pcs','2026-04-23 15:29:08'),(32,'Study Table',4,14,6500.00,4500.00,'pcs','2026-04-23 15:29:08'),(33,'Bookshelf 5 Tier',4,9,3800.00,2600.00,'pcs','2026-04-23 15:29:08'),(34,'Wooden Stool',4,4,1200.00,800.00,'pcs','2026-04-23 15:29:08'),(35,'Sofa 3 Seater',4,14,18000.00,12500.00,'pcs','2026-04-23 15:29:08'),(36,'Bed Side Table',4,9,2200.00,1500.00,'pcs','2026-04-23 15:29:08'),(37,'Filing Cabinet 3 Draw',4,4,5500.00,3800.00,'pcs','2026-04-23 15:29:08'),(38,'Computer Desk',4,14,7200.00,5000.00,'pcs','2026-04-23 15:29:08'),(39,'Folding Chair',4,9,1800.00,1200.00,'pcs','2026-04-23 15:29:08'),(40,'Wardrobe 2 Door',4,4,12000.00,8500.00,'pcs','2026-04-23 15:29:08'),(41,'Cricket Bat',5,5,1800.00,1200.00,'pcs','2026-04-23 15:29:08'),(42,'Football Size 5',5,10,750.00,480.00,'pcs','2026-04-23 15:29:08'),(43,'Badminton Racket Pair',5,15,1200.00,800.00,'pair','2026-04-23 15:29:08'),(44,'Skipping Rope',5,5,199.00,110.00,'pcs','2026-04-23 15:29:08'),(45,'Yoga Mat 6mm',5,10,599.00,380.00,'pcs','2026-04-23 15:29:08'),(46,'Dumbbell 5kg Pair',5,15,1499.00,950.00,'pair','2026-04-23 15:29:08'),(47,'Cycling Helmet',5,5,999.00,650.00,'pcs','2026-04-23 15:29:08'),(48,'Table Tennis Set',5,10,1100.00,720.00,'set','2026-04-23 15:29:08'),(49,'Resistance Band Set',5,15,449.00,270.00,'set','2026-04-23 15:29:08'),(50,'Sports Water Bottle',5,5,299.00,170.00,'pcs','2026-04-23 15:29:08');
/*!40000 ALTER TABLE `products` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `purchase_orders`
--

DROP TABLE IF EXISTS `purchase_orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `purchase_orders` (
  `po_id` int NOT NULL AUTO_INCREMENT,
  `supplier_id` int NOT NULL,
  `product_id` int NOT NULL,
  `user_id` int NOT NULL,
  `quantity` int NOT NULL,
  `unit_cost` decimal(10,2) DEFAULT NULL,
  `order_date` date NOT NULL,
  `received_date` date DEFAULT NULL,
  `status` enum('Pending','Received','Cancelled') DEFAULT 'Pending',
  PRIMARY KEY (`po_id`),
  KEY `fk_po_supplier` (`supplier_id`),
  KEY `fk_po_product` (`product_id`),
  KEY `fk_po_user` (`user_id`),
  CONSTRAINT `fk_po_product` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`),
  CONSTRAINT `fk_po_supplier` FOREIGN KEY (`supplier_id`) REFERENCES `suppliers` (`supplier_id`),
  CONSTRAINT `fk_po_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`),
  CONSTRAINT `purchase_orders_chk_1` CHECK ((`quantity` > 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `purchase_orders`
--

LOCK TABLES `purchase_orders` WRITE;
/*!40000 ALTER TABLE `purchase_orders` DISABLE KEYS */;
/*!40000 ALTER TABLE `purchase_orders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sale_items`
--

DROP TABLE IF EXISTS `sale_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sale_items` (
  `item_id` int NOT NULL AUTO_INCREMENT,
  `sale_id` int NOT NULL,
  `product_id` int NOT NULL,
  `quantity` int NOT NULL,
  `unit_price` decimal(10,2) NOT NULL,
  `line_total` decimal(10,2) NOT NULL,
  PRIMARY KEY (`item_id`),
  KEY `fk_si_sale` (`sale_id`),
  KEY `fk_si_product` (`product_id`),
  CONSTRAINT `fk_si_product` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`),
  CONSTRAINT `fk_si_sale` FOREIGN KEY (`sale_id`) REFERENCES `sales` (`sale_id`) ON DELETE CASCADE,
  CONSTRAINT `sale_items_chk_1` CHECK ((`quantity` > 0))
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sale_items`
--

LOCK TABLES `sale_items` WRITE;
/*!40000 ALTER TABLE `sale_items` DISABLE KEYS */;
INSERT INTO `sale_items` VALUES (1,10,36,1,2200.00,2200.00),(2,10,28,2,50.00,100.00),(3,11,32,1,6500.00,6500.00),(4,11,21,3,350.00,1050.00),(5,12,7,1,1299.00,1299.00),(6,12,8,1,1199.00,1199.00),(7,12,6,3,1499.00,4497.00),(8,13,11,4,85.00,340.00),(9,13,19,3,25.00,75.00),(10,13,14,1,149.00,149.00),(11,13,23,140,140.00,19600.00),(12,14,24,1,220.00,220.00),(13,14,25,12,55.00,660.00);
/*!40000 ALTER TABLE `sale_items` ENABLE KEYS */;
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_before_saleitem_check_stock` BEFORE INSERT ON `sale_items` FOR EACH ROW BEGIN
    DECLARE available_qty INT DEFAULT 0;
    SELECT quantity INTO available_qty
    FROM STOCK WHERE product_id = NEW.product_id;
    IF available_qty IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'ERROR: Product not found in stock.';
    END IF;
    IF NEW.quantity > available_qty THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'ERROR: Insufficient stock for one or more products.';
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_after_saleitem_deduct_stock` AFTER INSERT ON `sale_items` FOR EACH ROW BEGIN
    UPDATE STOCK
    SET quantity = quantity - NEW.quantity
    WHERE product_id = NEW.product_id;
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_after_saleitem_audit` AFTER INSERT ON `sale_items` FOR EACH ROW BEGIN
    DECLARE uid INT DEFAULT NULL;
    SELECT user_id INTO uid FROM SALES WHERE sale_id = NEW.sale_id LIMIT 1;
    INSERT INTO SALES_AUDIT(sale_id, action_type, new_qty, changed_by)
    VALUES (NEW.sale_id, 'INSERT', NEW.quantity, uid);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `sales`
--

DROP TABLE IF EXISTS `sales`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sales` (
  `sale_id` int NOT NULL AUTO_INCREMENT,
  `customer_id` int DEFAULT NULL,
  `user_id` int NOT NULL,
  `sale_date` date NOT NULL,
  `total_amount` decimal(10,2) NOT NULL,
  `discount` decimal(5,2) DEFAULT '0.00',
  `payment_mode` enum('Cash','Card','UPI','Credit') DEFAULT 'Cash',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`sale_id`),
  KEY `fk_sale_customer` (`customer_id`),
  KEY `fk_sale_user` (`user_id`),
  CONSTRAINT `fk_sale_customer` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`customer_id`) ON DELETE SET NULL,
  CONSTRAINT `fk_sale_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sales`
--

LOCK TABLES `sales` WRITE;
/*!40000 ALTER TABLE `sales` DISABLE KEYS */;
INSERT INTO `sales` VALUES (2,1,2,'2026-04-23',1598.00,0.00,'UPI','2026-04-23 15:54:12'),(8,20,3,'2026-04-24',18000.00,0.00,'Cash','2026-04-24 13:13:23'),(9,6,3,'2026-04-24',565.00,0.00,'Cash','2026-04-24 13:14:27'),(10,17,3,'2026-04-24',2300.00,0.00,'Cash','2026-04-24 13:40:03'),(11,29,3,'2026-04-24',7550.00,0.00,'Cash','2026-04-24 13:45:18'),(12,30,3,'2026-04-24',6995.00,0.00,'Cash','2026-04-24 13:51:43'),(13,31,3,'2026-04-24',20164.00,0.00,'Card','2026-04-24 14:01:34'),(14,32,3,'2026-04-24',880.00,0.00,'UPI','2026-04-24 14:17:03');
/*!40000 ALTER TABLE `sales` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sales_audit`
--

DROP TABLE IF EXISTS `sales_audit`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sales_audit` (
  `audit_id` int NOT NULL AUTO_INCREMENT,
  `sale_id` int DEFAULT NULL,
  `action_type` enum('INSERT','UPDATE','DELETE') NOT NULL,
  `action_time` datetime DEFAULT CURRENT_TIMESTAMP,
  `old_qty` int DEFAULT NULL,
  `new_qty` int DEFAULT NULL,
  `changed_by` int DEFAULT NULL,
  PRIMARY KEY (`audit_id`),
  KEY `fk_audit_sale` (`sale_id`),
  CONSTRAINT `fk_audit_sale` FOREIGN KEY (`sale_id`) REFERENCES `sales` (`sale_id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sales_audit`
--

LOCK TABLES `sales_audit` WRITE;
/*!40000 ALTER TABLE `sales_audit` DISABLE KEYS */;
INSERT INTO `sales_audit` VALUES (1,2,'INSERT','2026-04-23 15:54:12',NULL,2,2),(2,10,'INSERT','2026-04-24 13:40:03',NULL,1,3),(3,10,'INSERT','2026-04-24 13:40:03',NULL,2,3),(4,11,'INSERT','2026-04-24 13:45:18',NULL,1,3),(5,11,'INSERT','2026-04-24 13:45:18',NULL,3,3),(6,12,'INSERT','2026-04-24 13:51:43',NULL,1,3),(7,12,'INSERT','2026-04-24 13:51:43',NULL,1,3),(8,12,'INSERT','2026-04-24 13:51:43',NULL,3,3),(9,13,'INSERT','2026-04-24 14:01:34',NULL,4,3),(10,13,'INSERT','2026-04-24 14:01:34',NULL,3,3),(11,13,'INSERT','2026-04-24 14:01:34',NULL,1,3),(12,13,'INSERT','2026-04-24 14:01:34',NULL,140,3),(13,14,'INSERT','2026-04-24 14:17:03',NULL,1,3),(14,14,'INSERT','2026-04-24 14:17:03',NULL,12,3);
/*!40000 ALTER TABLE `sales_audit` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `stock`
--

DROP TABLE IF EXISTS `stock`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `stock` (
  `product_id` int NOT NULL,
  `quantity` int NOT NULL DEFAULT '0',
  `min_level` int NOT NULL DEFAULT '5',
  `max_level` int DEFAULT '500',
  `last_updated` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`product_id`),
  CONSTRAINT `fk_stock_product` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`) ON DELETE CASCADE,
  CONSTRAINT `stock_chk_1` CHECK ((`quantity` >= 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `stock`
--

LOCK TABLES `stock` WRITE;
/*!40000 ALTER TABLE `stock` DISABLE KEYS */;
INSERT INTO `stock` VALUES (1,148,20,500,'2026-04-23 15:54:12'),(2,120,20,400,'2026-04-23 15:46:57'),(3,200,20,600,'2026-04-23 15:46:57'),(4,180,20,500,'2026-04-23 15:46:57'),(5,140,20,400,'2026-04-23 15:46:57'),(6,122,20,300,'2026-04-24 13:51:43'),(7,134,20,350,'2026-04-24 13:51:43'),(8,159,20,500,'2026-04-24 13:51:43'),(9,190,20,600,'2026-04-23 15:46:57'),(10,145,20,400,'2026-04-23 15:46:57'),(11,296,20,1000,'2026-04-24 14:01:34'),(12,400,20,1200,'2026-04-23 15:46:57'),(13,250,20,800,'2026-04-23 15:46:57'),(14,179,20,600,'2026-04-24 14:01:34'),(15,220,20,700,'2026-04-23 15:46:57'),(16,350,20,1000,'2026-04-23 15:46:57'),(17,280,20,900,'2026-04-23 15:46:57'),(18,300,20,1000,'2026-04-23 15:46:57'),(19,397,20,1200,'2026-04-24 14:01:34'),(20,500,20,1500,'2026-04-23 15:46:57'),(21,197,20,600,'2026-04-24 13:45:18'),(22,180,20,500,'2026-04-23 15:46:57'),(23,20,20,500,'2026-04-24 14:01:34'),(24,189,20,550,'2026-04-24 14:17:03'),(25,208,20,700,'2026-04-24 14:17:03'),(26,250,20,800,'2026-04-23 15:46:57'),(27,200,20,600,'2026-04-23 15:46:57'),(28,198,20,600,'2026-04-24 13:40:03'),(29,175,20,500,'2026-04-23 15:46:57'),(30,190,20,550,'2026-04-23 15:46:57'),(31,60,20,200,'2026-04-23 15:46:57'),(32,49,20,150,'2026-04-24 13:45:18'),(33,55,20,180,'2026-04-23 15:46:57'),(34,70,20,250,'2026-04-23 15:46:57'),(35,40,20,120,'2026-04-23 15:46:57'),(36,64,20,220,'2026-04-24 13:40:03'),(37,45,20,150,'2026-04-23 15:46:57'),(38,50,20,160,'2026-04-23 15:46:57'),(39,75,20,250,'2026-04-23 15:46:57'),(40,42,20,130,'2026-04-23 15:46:57'),(41,120,20,400,'2026-04-23 15:46:57'),(42,140,20,450,'2026-04-23 15:46:57'),(43,125,20,380,'2026-04-23 15:46:57'),(44,180,20,550,'2026-04-23 15:46:57'),(45,150,20,450,'2026-04-23 15:46:57'),(46,110,20,350,'2026-04-23 15:46:57'),(47,135,20,400,'2026-04-23 15:46:57'),(48,122,20,360,'2026-04-23 15:46:57'),(49,160,20,500,'2026-04-23 15:46:57'),(50,170,20,520,'2026-04-23 15:46:57');
/*!40000 ALTER TABLE `stock` ENABLE KEYS */;
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_after_stock_update_alert` AFTER UPDATE ON `stock` FOR EACH ROW BEGIN
    IF NEW.quantity < NEW.min_level THEN
        INSERT INTO STOCK_ALERT_LOG(product_id, alert_msg)
        VALUES (NEW.product_id,
            CONCAT('Low Stock Alert: Only ', NEW.quantity,
                   ' units remaining. Minimum required: ', NEW.min_level));
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `stock_alert_log`
--

DROP TABLE IF EXISTS `stock_alert_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `stock_alert_log` (
  `alert_id` int NOT NULL AUTO_INCREMENT,
  `product_id` int DEFAULT NULL,
  `alert_msg` varchar(255) DEFAULT NULL,
  `alert_time` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`alert_id`),
  KEY `fk_alert_product` (`product_id`),
  CONSTRAINT `fk_alert_product` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `stock_alert_log`
--

LOCK TABLES `stock_alert_log` WRITE;
/*!40000 ALTER TABLE `stock_alert_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `stock_alert_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `suppliers`
--

DROP TABLE IF EXISTS `suppliers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `suppliers` (
  `supplier_id` int NOT NULL AUTO_INCREMENT,
  `supplier_name` varchar(100) NOT NULL,
  `contact_name` varchar(100) DEFAULT NULL,
  `phone` varchar(15) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`supplier_id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `suppliers`
--

LOCK TABLES `suppliers` WRITE;
/*!40000 ALTER TABLE `suppliers` DISABLE KEYS */;
INSERT INTO `suppliers` VALUES (1,'TechSource Pvt Ltd','Rahul Mehta','9876543210','rahul@techsource.com','Pune, Maharashtra'),(2,'PaperMart Traders','Sunita Joshi','9123456780','sunita@papermart.com','Nashik, Maharashtra'),(3,'FreshFarm Distributors','Mohan Yadav','9988001122','mohan@freshfarm.com','Nagpur, Maharashtra'),(4,'WoodWorks Suppliers','Anjali Desai','9871234560','anjali@woodworks.com','Mumbai, Maharashtra'),(5,'FitGear India','Ravi Kumar','9765432100','ravi@fitgear.com','Bangalore, Karnataka'),(6,'DigiWorld Pvt Ltd','Sneha Patil','9654321890','sneha@digiworld.com','Hyderabad, Telangana'),(7,'OfficePlus','Vikram Sharma','9543218760','vikram@officeplus.com','Delhi, NCR'),(8,'GreenGrocer Co.','Pooja Nair','9432187650','pooja@greengrocer.com','Chennai, Tamil Nadu'),(9,'ComfortHome Supplies','Arjun Iyer','9321876540','arjun@comforthome.com','Coimbatore, Tamil Nadu'),(10,'SportZone Traders','Meena Pillai','9210765430','meena@sportzone.com','Kochi, Kerala'),(11,'BrightElec Pvt Ltd','Suresh Gupta','9109654320','suresh@brightelec.com','Jaipur, Rajasthan'),(12,'StationeryHub','Kavita Singh','9098543210','kavita@stationeryhub.com','Lucknow, Uttar Pradesh'),(13,'DailyNeeds Wholesale','Nilesh Pawar','9087432100','nilesh@dailyneeds.com','Kolhapur, Maharashtra'),(14,'ModernFurnitures','Prerna Tiwari','9076321890','prerna@modernfurn.com','Indore, Madhya Pradesh'),(15,'ActiveLife Sports','Harish Reddy','9065210780','harish@activelife.com','Vizag, Andhra Pradesh');
/*!40000 ALTER TABLE `suppliers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `user_id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` enum('admin','staff') NOT NULL DEFAULT 'staff',
  `email` varchar(100) DEFAULT NULL,
  `phone` varchar(15) DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `is_active` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'admin1','admin@123','admin','admin@inventory.com',NULL,'2026-04-23 15:54:00',1),(2,'staff1','staff@123','staff','staff1@inventory.com',NULL,'2026-04-23 15:54:00',1),(3,'Sakshi','990099','staff','walunjsakshi277@gmail.com','7276310889','2026-04-24 08:31:52',1);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'inventory_db'
--

--
-- Dumping routines for database 'inventory_db'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-04-24 16:32:43
