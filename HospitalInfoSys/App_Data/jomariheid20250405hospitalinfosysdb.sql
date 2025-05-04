-- --------------------------------------------------------
-- Host:                         localhost
-- Server version:               8.0.41 - MySQL Community Server - GPL
-- Server OS:                    Win64
-- HeidiSQL Version:             12.10.0.7000
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Dumping database structure for hospitalinfosysdb
CREATE DATABASE IF NOT EXISTS `hospitalinfosysdb` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `hospitalinfosysdb`;

-- Dumping structure for table hospitalinfosysdb.appointments
CREATE TABLE IF NOT EXISTS `appointments` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `Firstname` varchar(255) DEFAULT NULL,
  `Middlename` varchar(255) DEFAULT NULL,
  `Lastname` varchar(255) DEFAULT NULL,
  `Sex` enum('Male','Female') DEFAULT NULL,
  `BirthDate` date DEFAULT NULL,
  `Email` varchar(255) DEFAULT NULL,
  `ContactNo` varchar(15) DEFAULT NULL,
  `Address` text,
  `PreferredDoctorID` int DEFAULT '0',
  `AppointmentDateTime` datetime DEFAULT NULL,
  `Reason` text,
  `Status` enum('Pending','Approved','Rejected') DEFAULT 'Pending',
  `AppointmentDateApproved` datetime DEFAULT NULL,
  `AppointmentRemarks` varchar(255) DEFAULT NULL,
  `AppointmentNumber` varchar(45) DEFAULT NULL,
  `userid` int DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `AppointmentNumber_UNIQUE` (`AppointmentNumber`)
) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=latin1;

-- Dumping data for table hospitalinfosysdb.appointments: ~11 rows (approximately)
INSERT INTO `appointments` (`ID`, `Firstname`, `Middlename`, `Lastname`, `Sex`, `BirthDate`, `Email`, `ContactNo`, `Address`, `PreferredDoctorID`, `AppointmentDateTime`, `Reason`, `Status`, `AppointmentDateApproved`, `AppointmentRemarks`, `AppointmentNumber`, `userid`) VALUES
	(1, 'RONNIE', 'B', 'CADORNA', 'Male', '1994-10-02', 'cadzronz02@gmail.com', '091231313', 'STA. ISABEL, ROSRAY HEIGHTS VIII', 13, '2025-04-25 12:10:00', 'TEST REASON', 'Approved', '2025-04-17 12:11:00', 'asda', '250417-8655', NULL),
	(13, 'BABY GIRL', 'MA', 'SANTOS', 'Female', '2025-05-05', 'test@gmail.com', 'asdsad', 'asdsa', 13, '2025-05-22 16:49:00', 'asdsadad', 'Pending', NULL, NULL, '250502-9914', 17),
	(19, 'vv12222', 'vv2', 'vvv3', 'Female', '1991-05-08', 'vvv@gmail.com', 'vvv', 'vv', 1, '2025-05-30 17:01:00', 'vvv', 'Approved', '2025-05-02 21:50:00', 'ffsdf', '250502-8989', 17),
	(21, 'z22', 'zzz2222', 'zzz', 'Female', '1991-04-29', 'asd@gmail.com', '1231313', 'asdad', 9, '2025-05-03 05:06:00', 'test', 'Approved', '2025-05-02 21:43:00', 'sdad', '250502-7814', 17),
	(23, 'vv333333', 'vvvvv', '33', 'Male', '2025-05-07', 'sdsa@gmail.com', 'da', 'asdsad', 9, '2025-05-09 17:07:00', 'vvvvvvvvvvvvvvvv', 'Pending', NULL, NULL, '250502-5705', 17),
	(27, 'cccccc', 'cccc', 'ccccccccccccccc', 'Female', '1911-04-29', '1213@gmail.com', 'cccc', 'cccccccccccc', 13, '2025-05-15 17:20:00', 'ccccccccccccccc', 'Pending', NULL, NULL, '250502-1358', 17),
	(28, 'RONNIE JR', 'zz', 'CADORNA', 'Female', '2025-05-05', 'cadzronz02@gmail.com', '09213131', 'STA. ISABEL, ROSRAY HEIGHTS VIII', 13, '2025-05-24 21:40:00', 'test', 'Pending', NULL, NULL, '250502-9587', 17),
	(29, 'JOHN', 'M', 'DOE', 'Male', '1991-04-27', 'john@gmail.com', '1231313', '1231', 9, '2025-05-05 10:35:00', 'vomitting', 'Approved', '2025-05-04 10:37:00', 'asd', '250504-6706', 18),
	(31, 'SILENA', 'M', 'MERCADO', 'Female', '2019-02-02', 'selena@gmail.com', '09123131', 'STA. ISABEL, ROSRAY HEIGHTS VIII', 1, '2025-05-06 11:03:00', 'headache', 'Pending', NULL, NULL, '250504-7164', 18),
	(32, 'xx', 'xx', 'xxx', 'Male', '2015-04-27', 'xx@gmail.com', 'x', 'xxx', 9, '2025-05-05 11:14:00', 'asdsad', 'Pending', NULL, NULL, '250504-6855', 18),
	(33, 'MARIES MAE', 'BB', 'DALISAY', 'Female', '2022-01-03', 'asda22@gmail.com', '123131', '3131', 9, '2025-05-05 11:19:00', 'XXXXXXXXXX', 'Approved', '2025-05-04 11:20:00', 'ASD', '250504-2313', 18);

-- Dumping structure for table hospitalinfosysdb.chargeitemslibrary
CREATE TABLE IF NOT EXISTS `chargeitemslibrary` (
  `ChargeID` int NOT NULL AUTO_INCREMENT,
  `ItemType` enum('Medicine','Medical Supply','Examination','Miscellaneous','Room') NOT NULL,
  `Name` varchar(255) NOT NULL,
  `Price` decimal(10,2) NOT NULL,
  `Brand` varchar(100) DEFAULT NULL,
  `Unit` varchar(50) DEFAULT NULL,
  `Description` text,
  `Category` varchar(100) DEFAULT NULL,
  `RoomType` varchar(100) DEFAULT NULL,
  `IsActive` tinyint DEFAULT '0',
  PRIMARY KEY (`ChargeID`),
  UNIQUE KEY `unique_itemtype_name` (`ItemType`,`Name`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Dumping data for table hospitalinfosysdb.chargeitemslibrary: ~6 rows (approximately)
INSERT INTO `chargeitemslibrary` (`ChargeID`, `ItemType`, `Name`, `Price`, `Brand`, `Unit`, `Description`, `Category`, `RoomType`, `IsActive`) VALUES
	(2, 'Medical Supply', 'Dextrose', 232.51, '', '', '100ml', '', '', 0),
	(3, 'Medicine', 'Paracetamol 5mg', 6.25, 'atest', 'tablet', 'asdadadadad', '', '', 1),
	(4, 'Examination', 'Urinalysis', 320.00, '', '', '', 'Laboratory', '', 1),
	(5, 'Medical Supply', 'Surgical Gloves', 10.22, '', '', '2pcs XL', '', '', 1),
	(6, 'Miscellaneous', 'Nebulization fee', 150.00, '', '', '', '', '', 1),
	(7, 'Room', 'Private Room Class A', 2500.00, '', '', '', '', 'Private', 1);

-- Dumping structure for table hospitalinfosysdb.contact_messages
CREATE TABLE IF NOT EXISTS `contact_messages` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `Name` varchar(100) DEFAULT NULL,
  `Email` varchar(100) DEFAULT NULL,
  `Message` text,
  `DateSubmitted` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Dumping data for table hospitalinfosysdb.contact_messages: ~0 rows (approximately)

-- Dumping structure for table hospitalinfosysdb.doctor_achievements
CREATE TABLE IF NOT EXISTS `doctor_achievements` (
  `id` int NOT NULL AUTO_INCREMENT,
  `doctor_id` int NOT NULL,
  `specialty` varchar(100) NOT NULL,
  `photo_url` varchar(255) DEFAULT NULL,
  `descriptions` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Dumping data for table hospitalinfosysdb.doctor_achievements: ~2 rows (approximately)
INSERT INTO `doctor_achievements` (`id`, `doctor_id`, `specialty`, `photo_url`, `descriptions`, `created_at`, `updated_at`) VALUES
	(1, 9, 'ADAD', '~/images/doctor/doh12logo.png', 'ASDADACCCC', '2025-05-04 04:06:46', '2025-05-04 04:07:00'),
	(2, 1, 'asdsada', '~/images/doctor/csharlify.JPG', 'xasdasdasd\r\nasdasda ssda\r\nrow  3adsa dasda\r\nrow 4 asdad', '2025-05-04 04:12:20', '2025-05-04 04:12:20');

-- Dumping structure for function hospitalinfosysdb.GenerateInvoiceNo
DELIMITER //
CREATE FUNCTION `GenerateInvoiceNo`() RETURNS varchar(20) CHARSET utf8mb4
    DETERMINISTIC
BEGIN
    DECLARE prefix VARCHAR(10);
    DECLARE nextNum INT;
    DECLARE fullInvoice VARCHAR(20);

    -- Example: '202505'
    SET prefix = DATE_FORMAT(NOW(), '%Y%m');

    -- Get next number (look for invoice numbers starting with '202505-')
    SELECT IFNULL(MAX(CAST(SUBSTRING(InvoiceNo, 8) AS UNSIGNED)), 0) + 1
    INTO nextNum
    FROM patientinvoices
    WHERE InvoiceNo LIKE CONCAT(prefix, '-%');

    -- Final format: '202505-0002'
    SET fullInvoice = CONCAT(prefix, '-', LPAD(nextNum, 4, '0'));

    RETURN fullInvoice;
END//
DELIMITER ;

-- Dumping structure for table hospitalinfosysdb.migrations
CREATE TABLE IF NOT EXISTS `migrations` (
  `Id` int NOT NULL AUTO_INCREMENT,
  `Version` int NOT NULL,
  `MigrationName` varchar(255) NOT NULL,
  `AppliedAt` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Dumping data for table hospitalinfosysdb.migrations: ~0 rows (approximately)
INSERT INTO `migrations` (`Id`, `Version`, `MigrationName`, `AppliedAt`) VALUES
	(1, 5, 'Create_Users_Table', '2025-04-01 13:12:54');

-- Dumping structure for table hospitalinfosysdb.patientinvoiceitems
CREATE TABLE IF NOT EXISTS `patientinvoiceitems` (
  `ItemID` int NOT NULL AUTO_INCREMENT,
  `InvoiceID` int NOT NULL,
  `ItemType` enum('Medicine','Medical Supply','Examination','Miscellaneous','Room') NOT NULL,
  `ItemRefID` int NOT NULL,
  `Descriptions` varchar(255) NOT NULL,
  `Quantity` int DEFAULT '1',
  `UnitPrice` decimal(10,2) NOT NULL,
  `TotalPrice` decimal(10,2) GENERATED ALWAYS AS ((`Quantity` * `UnitPrice`)) STORED,
  PRIMARY KEY (`ItemID`),
  KEY `InvoiceID` (`InvoiceID`),
  KEY `ItemType` (`ItemType`),
  KEY `ItemRefID` (`ItemRefID`),
  CONSTRAINT `patientinvoiceitems_ibfk_1` FOREIGN KEY (`InvoiceID`) REFERENCES `patientinvoices` (`InvoiceID`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Dumping data for table hospitalinfosysdb.patientinvoiceitems: ~11 rows (approximately)
INSERT INTO `patientinvoiceitems` (`ItemID`, `InvoiceID`, `ItemType`, `ItemRefID`, `Descriptions`, `Quantity`, `UnitPrice`) VALUES
	(7, 5, 'Medicine', 3, 'Paracetamol 5mgBrand: atest, Unit: tablet', 1, 6.25),
	(10, 7, 'Medicine', 3, 'Paracetamol 5mgBrand: atest, Unit: tablet', 5, 6.25),
	(11, 8, 'Room', 7, 'Private Room Class APrivate', 2, 2500.00),
	(12, 8, 'Medical Supply', 5, 'Surgical Gloves2pcs XL', 2, 10.22),
	(13, 5, 'Examination', 4, 'Urinalysis - Laboratory', 1, 320.00),
	(15, 8, 'Medical Supply', 2, 'Dextrose - 100ml', 1, 232.51),
	(16, 11, 'Medical Supply', 5, 'Surgical Gloves - 2pcs XL', 1, 10.22),
	(17, 11, 'Examination', 4, 'Urinalysis - Laboratory', 1, 320.00),
	(18, 12, 'Examination', 4, 'Urinalysis - Laboratory', 1, 320.00),
	(19, 12, 'Medical Supply', 5, 'Surgical Gloves - 2pcs XL', 1, 10.22),
	(20, 12, 'Medicine', 3, 'Paracetamol 5mg - Brand: atest, Unit: tablet', 1, 6.25);

-- Dumping structure for table hospitalinfosysdb.patientinvoices
CREATE TABLE IF NOT EXISTS `patientinvoices` (
  `InvoiceID` int NOT NULL AUTO_INCREMENT,
  `PatientRecID` int NOT NULL,
  `InvoiceDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `IsPaid` tinyint(1) DEFAULT '0',
  `PaymentDate` datetime DEFAULT NULL,
  `CashTendered` decimal(10,2) DEFAULT NULL,
  `Remarks` text,
  `InvoiceNo` varchar(20) DEFAULT NULL,
  `Discount` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`InvoiceID`),
  UNIQUE KEY `InvoiceNo_UNIQUE` (`InvoiceNo`),
  KEY `PatientRecID` (`PatientRecID`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Dumping data for table hospitalinfosysdb.patientinvoices: ~6 rows (approximately)
INSERT INTO `patientinvoices` (`InvoiceID`, `PatientRecID`, `InvoiceDate`, `IsPaid`, `PaymentDate`, `CashTendered`, `Remarks`, `InvoiceNo`, `Discount`) VALUES
	(5, 1, '2025-05-03 00:00:00', 0, '2025-05-03 00:00:00', 10.00, '', '202505-0001', 0.00),
	(7, 2, '2025-05-03 00:00:00', 0, NULL, 0.00, '', '202505-0003', 0.00),
	(8, 4, '2025-05-03 00:00:00', 0, '2025-05-03 00:00:00', 1000.00, '', '202505-0004', 0.00),
	(10, 3, '2025-05-04 08:39:45', 0, NULL, 0.00, '', '202505-0005', 0.00),
	(11, 5, '2025-05-04 00:00:00', 0, '2025-05-04 00:00:00', 500.00, '', '202505-0006', 0.00),
	(12, 6, '2025-05-04 00:00:00', 0, '2025-05-04 00:00:00', 300.00, '', '202505-0007', 100.00);

-- Dumping structure for table hospitalinfosysdb.patientlist
CREATE TABLE IF NOT EXISTS `patientlist` (
  `PID` int NOT NULL AUTO_INCREMENT,
  `HEALTHNO` varchar(45) NOT NULL,
  `FIRSTNAME` varchar(45) NOT NULL,
  `LASTNAME` varchar(45) NOT NULL,
  `MIDDLENAME` varchar(45) DEFAULT NULL,
  `ADDRESS` varchar(155) DEFAULT NULL,
  `CONTACTNO` varchar(45) DEFAULT NULL,
  `EMAIL` varchar(50) DEFAULT NULL,
  `SEX` varchar(8) DEFAULT NULL,
  `BIRTHDATE` date DEFAULT NULL,
  `OCCUPATION` varchar(80) DEFAULT NULL,
  `CPNAME` varchar(45) DEFAULT NULL,
  `CPCONTACTNO` varchar(45) DEFAULT NULL,
  `DATEREGISTERED` date NOT NULL,
  `userid` int DEFAULT '0',
  PRIMARY KEY (`PID`),
  UNIQUE KEY `HEALTHNO_UNIQUE` (`HEALTHNO`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Dumping data for table hospitalinfosysdb.patientlist: ~7 rows (approximately)
INSERT INTO `patientlist` (`PID`, `HEALTHNO`, `FIRSTNAME`, `LASTNAME`, `MIDDLENAME`, `ADDRESS`, `CONTACTNO`, `EMAIL`, `SEX`, `BIRTHDATE`, `OCCUPATION`, `CPNAME`, `CPCONTACTNO`, `DATEREGISTERED`, `userid`) VALUES
	(1, '250417-00001', 'RONNIE', 'CADORNA', 'B', 'STA. ISABEL, ROSRAY HEIGHTS VIII', '091231313', 'cadzronz02@gmail.com', 'Male', '1994-10-02', NULL, NULL, NULL, '2025-04-17', 0),
	(2, '250502-00001', 'z22', 'zzz', 'zzz2222', 'asdad', '1231313', 'asd@gmail.com', 'Female', '1991-04-29', '', '', '', '2025-05-02', 1),
	(3, '250502-00003', 'vv12222', 'vvv3', 'vv2', 'vv', 'vvv', 'vvv@gmail.com', 'Female', '1991-05-08', '', '', '', '2025-05-02', 17),
	(4, '250502-00004', 'cccccc', 'ccccccccccccccc', 'cccc', 'cccccccccccc', 'cccc', '1213@gmail.com', 'Female', '1911-04-29', NULL, NULL, NULL, '2025-05-02', 17),
	(5, '250504-00001', 'vv333333', '33', 'vvvvv', 'asdsad', 'da', 'sdsa@gmail.com', 'Male', '2025-05-07', NULL, NULL, NULL, '2025-05-04', 17),
	(6, '250504-00006', 'JOHN', 'DOE', 'M', '1231', '1231313', 'john@gmail.com', 'Male', '1991-04-27', NULL, NULL, NULL, '2025-05-04', 18),
	(7, '250504-00007', 'MARIES MAE', 'DALISAY', 'BB', '3131', '123131', 'asda22@gmail.com', 'Female', '2022-01-03', NULL, NULL, NULL, '2025-05-04', 18);

-- Dumping structure for table hospitalinfosysdb.patientrecord
CREATE TABLE IF NOT EXISTS `patientrecord` (
  `PRID` int NOT NULL AUTO_INCREMENT,
  `PATID` int NOT NULL,
  `PATLOGDATE` datetime NOT NULL,
  `TYPECONSULTATION` enum('Admission','Outpatient','Emergency') NOT NULL,
  `CHIEFCOMPLAINT` varchar(255) NOT NULL DEFAULT 'Checkup',
  `MEDICALHISTORY` text,
  `ALLERGIES` varchar(255) DEFAULT NULL,
  `RoomID` int DEFAULT NULL,
  `DoctorID` int NOT NULL,
  `DIAGNOSIS` varchar(255) DEFAULT NULL,
  `PATDISCHARGE` datetime DEFAULT NULL,
  `PATDISPOSITION` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`PRID`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1;

-- Dumping data for table hospitalinfosysdb.patientrecord: ~6 rows (approximately)
INSERT INTO `patientrecord` (`PRID`, `PATID`, `PATLOGDATE`, `TYPECONSULTATION`, `CHIEFCOMPLAINT`, `MEDICALHISTORY`, `ALLERGIES`, `RoomID`, `DoctorID`, `DIAGNOSIS`, `PATDISCHARGE`, `PATDISPOSITION`) VALUES
	(1, 1, '2025-04-17 12:21:00', 'Outpatient', 'TES', 'ASD', 'ASD', 0, 9, 'ADADADA', '2025-04-17 12:21:00', ''),
	(2, 2, '2025-04-30 21:43:00', 'Emergency', 'asda', 'dda', 'dadada', 0, 9, 'ada', '2025-05-02 21:43:00', 'asdsadsadsadadsasd'),
	(3, 3, '2025-05-03 21:53:00', 'Outpatient', 'asdsa', 'dsaad', 'dada', 0, 1, 'adadda', '2025-05-03 21:53:00', 'asdsada'),
	(4, 4, '2025-05-16 22:21:00', 'Outpatient', 'asdsa', 'dd', 'ada', 0, 9, 'dadadad', '2025-05-10 22:21:00', 'asdadadad'),
	(5, 6, '2025-05-04 10:38:00', 'Outpatient', 'asdasda', 'ad', 'asdsad', 0, 1, 'adsa', NULL, ''),
	(6, 7, '2025-05-05 11:20:00', 'Admission', 'HEAD ACHE', 'ASDA', 'ADSSA', 4, 9, 'DADSA', '2025-05-04 11:20:00', 'ASDADA');

-- Dumping structure for table hospitalinfosysdb.rooms
CREATE TABLE IF NOT EXISTS `rooms` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `RoomName` varchar(255) DEFAULT NULL,
  `RoomNumber` int DEFAULT NULL,
  `Type` enum('Single','Double') DEFAULT NULL,
  `BedOccupancy` int DEFAULT '1',
  `IsVacant` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`ID`),
  UNIQUE KEY `RoomNumber` (`RoomNumber`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1;

-- Dumping data for table hospitalinfosysdb.rooms: ~5 rows (approximately)
INSERT INTO `rooms` (`ID`, `RoomName`, `RoomNumber`, `Type`, `BedOccupancy`, `IsVacant`) VALUES
	(2, 'rrr', 1234, 'Double', 222, 1),
	(3, '123', 12, 'Double', 2, 1),
	(4, 'ROOM MELA WARD', 1, 'Double', 2, 1),
	(5, '1', 12312313, 'Single', 1, 1),
	(6, 'adasd', 123, 'Single', 1, 1);

-- Dumping structure for table hospitalinfosysdb.services
CREATE TABLE IF NOT EXISTS `services` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `ServiceName` varchar(255) NOT NULL,
  `Description` varchar(255) DEFAULT NULL,
  `Price` double DEFAULT NULL,
  `IsActive` int DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;

-- Dumping data for table hospitalinfosysdb.services: ~4 rows (approximately)
INSERT INTO `services` (`ID`, `ServiceName`, `Description`, `Price`, `IsActive`) VALUES
	(2, 'Medical Checkups', 'Regular health screenings and diagnostics.', 350, 1),
	(3, 'Emergency Care', '24/7 emergency services with highly trained staff.', 900, 1),
	(4, 'Surgery & Treatment', 'Advanced surgical procedures with expert surgeons.', 2500, 1),
	(5, 'asdadada dasdsa das', 'sada dasdadadsa dasa dssad adsads asdas dasdsa dsada da a sdad asdsad', 400000, 1);

-- Dumping structure for table hospitalinfosysdb.users
CREATE TABLE IF NOT EXISTS `users` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `Firstname` varchar(255) DEFAULT NULL,
  `Lastname` varchar(255) DEFAULT NULL,
  `Middlename` varchar(255) DEFAULT NULL,
  `UserPosition` varchar(255) DEFAULT NULL,
  `Username` varchar(100) DEFAULT NULL,
  `PasswordHash` varchar(255) DEFAULT NULL,
  `Address` text,
  `ContactNo` varchar(15) DEFAULT NULL,
  `Email` varchar(255) DEFAULT NULL,
  `Role` enum('Doctor','Nurse','Patient') DEFAULT 'Patient',
  `IsApproved` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`ID`),
  UNIQUE KEY `Username` (`Username`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=latin1;

-- Dumping data for table hospitalinfosysdb.users: ~9 rows (approximately)
INSERT INTO `users` (`ID`, `Firstname`, `Lastname`, `Middlename`, `UserPosition`, `Username`, `PasswordHash`, `Address`, `ContactNo`, `Email`, `Role`, `IsApproved`) VALUES
	(1, 'AdminFirst', 'AdminLast', 'AdminMI', 'Administrator', 'admin', '$2a$11$3JheymopodEaqdRM77YVKOhv7KcDe//xRk8/oEa/8xVi3RhRFRSP6', '', '09123213', 'admin@example.com', 'Doctor', 1),
	(9, 'RONNIE', 'CADORNA', 'B.', 'Doctor', '123', '$2a$11$QoN4xQwXp/yVXXXx4HfGRun2QD5Ov3DgLO2cDp0UNZopQVlgbxgM2', 'STA. ISABEL, ROSRAY HEIGHTS VIII', '12313', 'cadzronz202@gmail.com', 'Doctor', 1),
	(10, 'test 1', 'test', 'tes', 'Nurse', 'test', '$2a$11$KdTg.MGjn5Uysh8Q9I7CNOiYnbnaNKvSorD1UMlxELz01BMEDCBYa', '12313', '12313213', 'test1@gmail.com', 'Nurse', 0),
	(13, 'MARIA2', 'ORTUSTE', 'MANANA', 'PEDIATRICIAN', 'm1', '$2a$11$7oLOR9Qtwl0AezD5mSqF1.FIUzr5JY2irclPMbYVtVpa1j6LoF9he', 'asdada', '0123131', 'maria02@gmail.com', 'Doctor', 0),
	(14, 'RONNIE', 'CADORNA', 'B.', 'asdaad', '12333', '$2a$11$n8.yibegx4f9NU/ufxkg1.QYI7ppXuxWxJwzAbOjv5OgUMpdla/J.', 'STA. ISABEL, ROSRAY HEIGHTS VIII', 'adasd1231', 'cadzronz022@gmail.com', 'Nurse', 0),
	(15, 'MARIA', 'SANTOS', 'M', 'NURSE 1', 'nurse1', '$2a$11$53ozi864g2z3iFdmCCbjfejhVi001nLX1N1uDR6Xvlc4WWT4MG6ui', 'ASDSAD', '0912313', 'MARIA@GMAIL.COM', 'Nurse', 1),
	(16, 'asd', 'adad', 'adada', 'dada', '12345', '$2a$11$roRRex57Zk.ragHo8utS.OJUMljBMO5cg4bu7p9kzfPx.ChIqqOdu', '', 'aadsadad', 'dada@gmail.com', 'Nurse', 1),
	(17, 'patient1', 'patient1', 'ad', 'n/a', '1234', '$2a$11$YRwgllCT0ud2Ep8Z8XLtOOagyK9lVHnIEHnpg7xoSJmV6ckJniGUG', 'asdada', '0912313', 'asdsad2@gmail.com', 'Patient', 1),
	(18, 'JOHN', 'DOE', 'M', '', 'john', '$2a$11$cFLH/F.GjU36hoyhfJbKNOdy3jU2d8dzZ/XwM9yg7X15xK8GDfz9q', 'adsadad', '09123131', 'john@gmail.com', 'Patient', 1);

-- Dumping structure for view hospitalinfosysdb.vw_appointments
-- Creating temporary table to overcome VIEW dependency errors
CREATE TABLE `vw_appointments` (
	`ID` INT NOT NULL,
	`Firstname` VARCHAR(1) NULL COLLATE 'latin1_swedish_ci',
	`Middlename` VARCHAR(1) NULL COLLATE 'latin1_swedish_ci',
	`Lastname` VARCHAR(1) NULL COLLATE 'latin1_swedish_ci',
	`Sex` ENUM('Male','Female') NULL COLLATE 'latin1_swedish_ci',
	`BirthDate` DATE NULL,
	`Email` VARCHAR(1) NULL COLLATE 'latin1_swedish_ci',
	`ContactNo` VARCHAR(1) NULL COLLATE 'latin1_swedish_ci',
	`Address` TEXT NULL COLLATE 'latin1_swedish_ci',
	`PreferredDoctorID` INT NULL,
	`AppointmentDateTime` DATETIME NULL,
	`Reason` TEXT NULL COLLATE 'latin1_swedish_ci',
	`Status` ENUM('Pending','Approved','Rejected') NULL COLLATE 'latin1_swedish_ci',
	`AppointmentDateApproved` DATETIME NULL,
	`AppointmentRemarks` VARCHAR(1) NULL COLLATE 'latin1_swedish_ci',
	`AppointmentNumber` VARCHAR(1) NULL COLLATE 'latin1_swedish_ci',
	`Fullname` TEXT NULL COLLATE 'latin1_swedish_ci',
	`Age` BIGINT NULL,
	`PreferedDoctorName` TEXT NULL COLLATE 'latin1_swedish_ci',
	`remainingdays` VARCHAR(1) NULL COLLATE 'latin1_swedish_ci',
	`dayscount` INT NULL,
	`userid` INT NULL
) ENGINE=MyISAM;

-- Dumping structure for view hospitalinfosysdb.vw_billing
-- Creating temporary table to overcome VIEW dependency errors
CREATE TABLE `vw_billing` (
	`InvoiceID` INT NULL,
	`PatientRecID` INT NULL,
	`InvoiceDate` DATETIME NULL,
	`IsPaid` TINYINT(1) NULL,
	`PaymentDate` DATETIME NULL,
	`CashTendered` DECIMAL(10,2) NULL,
	`Remarks` TEXT NULL COLLATE 'utf8mb4_0900_ai_ci',
	`InvoiceNo` VARCHAR(1) NULL COLLATE 'utf8mb4_0900_ai_ci',
	`FULLNAME` VARCHAR(1) NULL COLLATE 'utf8mb4_0900_ai_ci',
	`AGE` BIGINT NULL,
	`SEX` VARCHAR(1) NULL COLLATE 'utf8mb4_0900_ai_ci',
	`HEALTHNO` VARCHAR(1) NULL COLLATE 'utf8mb4_0900_ai_ci',
	`TYPECONSULTATION` ENUM('Admission','Outpatient','Emergency') NULL COLLATE 'latin1_swedish_ci',
	`PATLOGDATE` DATETIME NULL,
	`DIAGNOSIS` VARCHAR(1) NULL COLLATE 'latin1_swedish_ci',
	`DoctorFullName` TEXT NULL COLLATE 'latin1_swedish_ci',
	`userid` INT NULL,
	`totalamount` DECIMAL(32,2) NULL,
	`Status` VARCHAR(1) NOT NULL COLLATE 'utf8mb4_0900_ai_ci',
	`Discount` DECIMAL(10,2) NULL,
	`NetTotal` DECIMAL(33,2) NULL,
	`IsPaid2` INT NULL,
	`Status2` VARCHAR(1) NOT NULL COLLATE 'utf8mb4_0900_ai_ci'
) ENGINE=MyISAM;

-- Dumping structure for view hospitalinfosysdb.vw_chargeitemlibraries
-- Creating temporary table to overcome VIEW dependency errors
CREATE TABLE `vw_chargeitemlibraries` (
	`ChargeID` INT NOT NULL,
	`Name` VARCHAR(1) NOT NULL COLLATE 'utf8mb4_0900_ai_ci',
	`ItemType` ENUM('Medicine','Medical Supply','Examination','Miscellaneous','Room') NOT NULL COLLATE 'utf8mb4_0900_ai_ci',
	`Price` DECIMAL(10,2) NOT NULL,
	`IsActive` TINYINT NULL,
	`fulldetails` MEDIUMTEXT NULL COLLATE 'utf8mb4_0900_ai_ci',
	`Status` VARCHAR(1) NOT NULL COLLATE 'utf8mb4_0900_ai_ci'
) ENGINE=MyISAM;

-- Dumping structure for view hospitalinfosysdb.vw_doctorachievement
-- Creating temporary table to overcome VIEW dependency errors
CREATE TABLE `vw_doctorachievement` (
	`id` INT NOT NULL,
	`doctor_id` INT NOT NULL,
	`specialty` VARCHAR(1) NOT NULL COLLATE 'utf8mb4_0900_ai_ci',
	`photo_url` VARCHAR(1) NULL COLLATE 'utf8mb4_0900_ai_ci',
	`descriptions` TEXT NULL COLLATE 'utf8mb4_0900_ai_ci',
	`created_at` TIMESTAMP NULL,
	`updated_at` TIMESTAMP NULL,
	`Fullname` TEXT NULL COLLATE 'latin1_swedish_ci',
	`Address` TEXT NULL COLLATE 'latin1_swedish_ci',
	`UserPosition` VARCHAR(1) NULL COLLATE 'latin1_swedish_ci',
	`ContactNo` VARCHAR(1) NULL COLLATE 'latin1_swedish_ci',
	`Email` VARCHAR(1) NULL COLLATE 'latin1_swedish_ci',
	`Role` ENUM('Doctor','Nurse','Patient') NULL COLLATE 'latin1_swedish_ci'
) ENGINE=MyISAM;

-- Dumping structure for view hospitalinfosysdb.vw_patientrecord
-- Creating temporary table to overcome VIEW dependency errors
CREATE TABLE `vw_patientrecord` (
	`PRID` INT NOT NULL,
	`PATID` INT NOT NULL,
	`PATLOGDATE` DATETIME NOT NULL,
	`TYPECONSULTATION` ENUM('Admission','Outpatient','Emergency') NOT NULL COLLATE 'latin1_swedish_ci',
	`CHIEFCOMPLAINT` VARCHAR(1) NOT NULL COLLATE 'latin1_swedish_ci',
	`MEDICALHISTORY` TEXT NULL COLLATE 'latin1_swedish_ci',
	`ALLERGIES` VARCHAR(1) NULL COLLATE 'latin1_swedish_ci',
	`RoomID` INT NULL,
	`DoctorID` INT NOT NULL,
	`DIAGNOSIS` VARCHAR(1) NULL COLLATE 'latin1_swedish_ci',
	`PATDISCHARGE` DATETIME NULL,
	`PATDISPOSITION` VARCHAR(1) NULL COLLATE 'latin1_swedish_ci',
	`PID` INT NULL,
	`HEALTHNO` VARCHAR(1) NULL COLLATE 'utf8mb4_0900_ai_ci',
	`FIRSTNAME` VARCHAR(1) NULL COLLATE 'utf8mb4_0900_ai_ci',
	`LASTNAME` VARCHAR(1) NULL COLLATE 'utf8mb4_0900_ai_ci',
	`MIDDLENAME` VARCHAR(1) NULL COLLATE 'utf8mb4_0900_ai_ci',
	`ADDRESS` VARCHAR(1) NULL COLLATE 'utf8mb4_0900_ai_ci',
	`CONTACTNO` VARCHAR(1) NULL COLLATE 'utf8mb4_0900_ai_ci',
	`EMAIL` VARCHAR(1) NULL COLLATE 'utf8mb4_0900_ai_ci',
	`SEX` VARCHAR(1) NULL COLLATE 'utf8mb4_0900_ai_ci',
	`BIRTHDATE` DATE NULL,
	`OCCUPATION` VARCHAR(1) NULL COLLATE 'utf8mb4_0900_ai_ci',
	`CPNAME` VARCHAR(1) NULL COLLATE 'utf8mb4_0900_ai_ci',
	`CPCONTACTNO` VARCHAR(1) NULL COLLATE 'utf8mb4_0900_ai_ci',
	`DATEREGISTERED` DATE NULL,
	`FULLNAME` VARCHAR(1) NULL COLLATE 'utf8mb4_0900_ai_ci',
	`AGE` BIGINT NULL,
	`RoomName` VARCHAR(1) NULL COLLATE 'latin1_swedish_ci',
	`RoomNumber` INT NULL,
	`DoctorFullName` TEXT NULL COLLATE 'latin1_swedish_ci',
	`userid` INT NULL,
	`InvoiceID` BIGINT NOT NULL
) ENGINE=MyISAM;

-- Dumping structure for view hospitalinfosysdb.vw_patientsprofile
-- Creating temporary table to overcome VIEW dependency errors
CREATE TABLE `vw_patientsprofile` (
	`PID` INT NOT NULL,
	`HEALTHNO` VARCHAR(1) NOT NULL COLLATE 'utf8mb4_0900_ai_ci',
	`FIRSTNAME` VARCHAR(1) NOT NULL COLLATE 'utf8mb4_0900_ai_ci',
	`LASTNAME` VARCHAR(1) NOT NULL COLLATE 'utf8mb4_0900_ai_ci',
	`MIDDLENAME` VARCHAR(1) NULL COLLATE 'utf8mb4_0900_ai_ci',
	`ADDRESS` VARCHAR(1) NULL COLLATE 'utf8mb4_0900_ai_ci',
	`CONTACTNO` VARCHAR(1) NULL COLLATE 'utf8mb4_0900_ai_ci',
	`EMAIL` VARCHAR(1) NULL COLLATE 'utf8mb4_0900_ai_ci',
	`SEX` VARCHAR(1) NULL COLLATE 'utf8mb4_0900_ai_ci',
	`BIRTHDATE` DATE NULL,
	`OCCUPATION` VARCHAR(1) NULL COLLATE 'utf8mb4_0900_ai_ci',
	`CPNAME` VARCHAR(1) NULL COLLATE 'utf8mb4_0900_ai_ci',
	`CPCONTACTNO` VARCHAR(1) NULL COLLATE 'utf8mb4_0900_ai_ci',
	`DATEREGISTERED` DATE NOT NULL,
	`FULLNAME` VARCHAR(1) NULL COLLATE 'utf8mb4_0900_ai_ci',
	`AGE` BIGINT NULL,
	`userid` INT NULL
) ENGINE=MyISAM;

-- Removing temporary table and create final VIEW structure
DROP TABLE IF EXISTS `vw_appointments`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `vw_appointments` AS select `b`.`ID` AS `ID`,`b`.`Firstname` AS `Firstname`,`b`.`Middlename` AS `Middlename`,`b`.`Lastname` AS `Lastname`,`b`.`Sex` AS `Sex`,`b`.`BirthDate` AS `BirthDate`,`b`.`Email` AS `Email`,`b`.`ContactNo` AS `ContactNo`,`b`.`Address` AS `Address`,`b`.`PreferredDoctorID` AS `PreferredDoctorID`,`b`.`AppointmentDateTime` AS `AppointmentDateTime`,`b`.`Reason` AS `Reason`,`b`.`Status` AS `Status`,`b`.`AppointmentDateApproved` AS `AppointmentDateApproved`,`b`.`AppointmentRemarks` AS `AppointmentRemarks`,`b`.`AppointmentNumber` AS `AppointmentNumber`,concat(`b`.`Firstname`,' ',left(`b`.`Middlename`,1),'. ',`b`.`Lastname`) AS `Fullname`,timestampdiff(YEAR,`b`.`BirthDate`,curdate()) AS `Age`,concat(`a`.`Firstname`,' ',left(`a`.`Middlename`,1),'. ',`a`.`Lastname`) AS `PreferedDoctorName`,(case when (`b`.`Status` = 'Pending') then (case when ((to_days(curdate()) - to_days(cast(`b`.`AppointmentDateTime` as date))) < 0) then concat(`b`.`Status`,' - ',abs((to_days(curdate()) - to_days(cast(`b`.`AppointmentDateTime` as date)))),' day(s) remaining') else concat(`b`.`Status`,' - ',(to_days(curdate()) - to_days(cast(`b`.`AppointmentDateTime` as date))),' day(s) overdue') end) else `b`.`Status` end) AS `remainingdays`,(to_days(curdate()) - to_days(cast(`b`.`AppointmentDateTime` as date))) AS `dayscount`,`b`.`userid` AS `userid` from (`appointments` `b` left join `users` `a` on((`a`.`ID` = `b`.`PreferredDoctorID`)))
;

-- Removing temporary table and create final VIEW structure
DROP TABLE IF EXISTS `vw_billing`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `vw_billing` AS select `a`.`InvoiceID` AS `InvoiceID`,`a`.`PatientRecID` AS `PatientRecID`,`a`.`InvoiceDate` AS `InvoiceDate`,`a`.`IsPaid` AS `IsPaid`,`a`.`PaymentDate` AS `PaymentDate`,`a`.`CashTendered` AS `CashTendered`,`a`.`Remarks` AS `Remarks`,`a`.`InvoiceNo` AS `InvoiceNo`,`b`.`FULLNAME` AS `FULLNAME`,`b`.`AGE` AS `AGE`,`b`.`SEX` AS `SEX`,`b`.`HEALTHNO` AS `HEALTHNO`,`b`.`TYPECONSULTATION` AS `TYPECONSULTATION`,`b`.`PATLOGDATE` AS `PATLOGDATE`,`b`.`DIAGNOSIS` AS `DIAGNOSIS`,`b`.`DoctorFullName` AS `DoctorFullName`,`b`.`userid` AS `userid`,(select sum(`z`.`TotalPrice`) AS `totprice` from `patientinvoiceitems` `z` where (`z`.`InvoiceID` = `a`.`InvoiceID`)) AS `totalamount`,(case when (`a`.`IsPaid` = 1) then 'Paid' else 'Unpaid' end) AS `Status`,`a`.`Discount` AS `Discount`,((select sum(`z`.`TotalPrice`) from `patientinvoiceitems` `z` where (`z`.`InvoiceID` = `a`.`InvoiceID`)) - `a`.`Discount`) AS `NetTotal`,(case when (`a`.`CashTendered` = 0) then 0 when (`a`.`CashTendered` >= ((select sum(`z`.`TotalPrice`) from `patientinvoiceitems` `z` where (`z`.`InvoiceID` = `a`.`InvoiceID`)) - `a`.`Discount`)) then 1 when ((`a`.`CashTendered` < ((select sum(`z`.`TotalPrice`) from `patientinvoiceitems` `z` where (`z`.`InvoiceID` = `a`.`InvoiceID`)) - `a`.`Discount`)) and (`a`.`CashTendered` > 0)) then 2 else NULL end) AS `IsPaid2`,(case when (`a`.`CashTendered` = 0) then 'Unpaid' when (`a`.`CashTendered` >= ((select sum(`z`.`TotalPrice`) from `patientinvoiceitems` `z` where (`z`.`InvoiceID` = `a`.`InvoiceID`)) - `a`.`Discount`)) then 'Fully Paid' when ((`a`.`CashTendered` < ((select sum(`z`.`TotalPrice`) from `patientinvoiceitems` `z` where (`z`.`InvoiceID` = `a`.`InvoiceID`)) - `a`.`Discount`)) and (`a`.`CashTendered` > 0)) then 'Partial Payment' else 'Unknown' end) AS `Status2` from (`patientinvoices` `a` left join `vw_patientrecord` `b` on((`b`.`PRID` = `a`.`PatientRecID`)))
;

-- Removing temporary table and create final VIEW structure
DROP TABLE IF EXISTS `vw_chargeitemlibraries`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `vw_chargeitemlibraries` AS select `chargeitemslibrary`.`ChargeID` AS `ChargeID`,`chargeitemslibrary`.`Name` AS `Name`,`chargeitemslibrary`.`ItemType` AS `ItemType`,`chargeitemslibrary`.`Price` AS `Price`,`chargeitemslibrary`.`IsActive` AS `IsActive`,(case when (`chargeitemslibrary`.`ItemType` = 'Medicine') then concat('Brand: ',coalesce(`chargeitemslibrary`.`Brand`,''),', Unit: ',coalesce(`chargeitemslibrary`.`Unit`,'')) when (`chargeitemslibrary`.`ItemType` = 'Medical Supply') then concat('',coalesce(`chargeitemslibrary`.`Description`,'')) when (`chargeitemslibrary`.`ItemType` = 'Examination') then concat('',coalesce(`chargeitemslibrary`.`Category`,'')) when (`chargeitemslibrary`.`ItemType` = 'Room') then concat('',coalesce(`chargeitemslibrary`.`RoomType`,'')) else '' end) AS `fulldetails`,(case when (`chargeitemslibrary`.`IsActive` = 1) then 'Active' else 'Inactive' end) AS `Status` from `chargeitemslibrary`
;

-- Removing temporary table and create final VIEW structure
DROP TABLE IF EXISTS `vw_doctorachievement`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `vw_doctorachievement` AS select `a`.`id` AS `id`,`a`.`doctor_id` AS `doctor_id`,`a`.`specialty` AS `specialty`,`a`.`photo_url` AS `photo_url`,`a`.`descriptions` AS `descriptions`,`a`.`created_at` AS `created_at`,`a`.`updated_at` AS `updated_at`,concat(`b`.`Firstname`,' ',left(`b`.`Middlename`,1),'. ',`b`.`Lastname`) AS `Fullname`,`b`.`Address` AS `Address`,`b`.`UserPosition` AS `UserPosition`,`b`.`ContactNo` AS `ContactNo`,`b`.`Email` AS `Email`,`b`.`Role` AS `Role` from (`doctor_achievements` `a` left join `users` `b` on((`b`.`ID` = `a`.`doctor_id`)))
;

-- Removing temporary table and create final VIEW structure
DROP TABLE IF EXISTS `vw_patientrecord`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `vw_patientrecord` AS select `a`.`PRID` AS `PRID`,`a`.`PATID` AS `PATID`,`a`.`PATLOGDATE` AS `PATLOGDATE`,`a`.`TYPECONSULTATION` AS `TYPECONSULTATION`,`a`.`CHIEFCOMPLAINT` AS `CHIEFCOMPLAINT`,`a`.`MEDICALHISTORY` AS `MEDICALHISTORY`,`a`.`ALLERGIES` AS `ALLERGIES`,`a`.`RoomID` AS `RoomID`,`a`.`DoctorID` AS `DoctorID`,`a`.`DIAGNOSIS` AS `DIAGNOSIS`,`a`.`PATDISCHARGE` AS `PATDISCHARGE`,`a`.`PATDISPOSITION` AS `PATDISPOSITION`,`p`.`PID` AS `PID`,`p`.`HEALTHNO` AS `HEALTHNO`,`p`.`FIRSTNAME` AS `FIRSTNAME`,`p`.`LASTNAME` AS `LASTNAME`,`p`.`MIDDLENAME` AS `MIDDLENAME`,`p`.`ADDRESS` AS `ADDRESS`,`p`.`CONTACTNO` AS `CONTACTNO`,`p`.`EMAIL` AS `EMAIL`,`p`.`SEX` AS `SEX`,`p`.`BIRTHDATE` AS `BIRTHDATE`,`p`.`OCCUPATION` AS `OCCUPATION`,`p`.`CPNAME` AS `CPNAME`,`p`.`CPCONTACTNO` AS `CPCONTACTNO`,`p`.`DATEREGISTERED` AS `DATEREGISTERED`,`p`.`FULLNAME` AS `FULLNAME`,`p`.`AGE` AS `AGE`,`r`.`RoomName` AS `RoomName`,`r`.`RoomNumber` AS `RoomNumber`,concat(`d`.`Firstname`,' ',left(`d`.`Middlename`,1),'. ',`d`.`Lastname`,' (',`d`.`UserPosition`,')') AS `DoctorFullName`,`p`.`userid` AS `userid`,ifnull(`v`.`InvoiceID`,0) AS `InvoiceID` from ((((`patientrecord` `a` left join `vw_patientsprofile` `p` on((`a`.`PATID` = `p`.`PID`))) left join `rooms` `r` on((`r`.`ID` = `a`.`RoomID`))) left join `users` `d` on((`d`.`ID` = `a`.`DoctorID`))) left join `patientinvoices` `v` on((`v`.`PatientRecID` = `a`.`PRID`)))
;

-- Removing temporary table and create final VIEW structure
DROP TABLE IF EXISTS `vw_patientsprofile`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `vw_patientsprofile` AS select `patientlist`.`PID` AS `PID`,`patientlist`.`HEALTHNO` AS `HEALTHNO`,`patientlist`.`FIRSTNAME` AS `FIRSTNAME`,`patientlist`.`LASTNAME` AS `LASTNAME`,`patientlist`.`MIDDLENAME` AS `MIDDLENAME`,`patientlist`.`ADDRESS` AS `ADDRESS`,`patientlist`.`CONTACTNO` AS `CONTACTNO`,`patientlist`.`EMAIL` AS `EMAIL`,`patientlist`.`SEX` AS `SEX`,`patientlist`.`BIRTHDATE` AS `BIRTHDATE`,`patientlist`.`OCCUPATION` AS `OCCUPATION`,`patientlist`.`CPNAME` AS `CPNAME`,`patientlist`.`CPCONTACTNO` AS `CPCONTACTNO`,`patientlist`.`DATEREGISTERED` AS `DATEREGISTERED`,concat(`patientlist`.`LASTNAME`,', ',`patientlist`.`FIRSTNAME`,' ',`patientlist`.`MIDDLENAME`) AS `FULLNAME`,timestampdiff(YEAR,`patientlist`.`BIRTHDATE`,curdate()) AS `AGE`,`patientlist`.`userid` AS `userid` from `patientlist`
;

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
