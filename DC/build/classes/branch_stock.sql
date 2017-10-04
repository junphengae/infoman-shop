# Host: localhost  (Version: 5.5.27)
# Date: 2014-01-16 12:52:38
# Generator: MySQL-Front 5.3  (Build 4.81)

/*!40101 SET NAMES utf8 */;

#
# Structure for table "branch_stock"
#

DROP TABLE IF EXISTS `branch_stock`;
CREATE TABLE `branch_stock` (
  `pn` varchar(20) NOT NULL,
  `branch_id` varchar(10) NOT NULL,
  `stock` varchar(50) NOT NULL,
  `update_date` timestamp NULL DEFAULT NULL,
  `update_by` varchar(20) DEFAULT NULL,
  `create_by` varchar(20) DEFAULT NULL,
  `create_date` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`pn`,`branch_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

#
# Data for table "branch_stock"
#

