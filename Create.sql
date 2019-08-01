# ************************************************************
# Sequel Pro SQL dump
# Version 4541
#
# http://www.sequelpro.com/
# https://github.com/sequelpro/sequelpro
#
# Host: ##.##.##.## (MySQL 5.7.26-0ubuntu0.18.04.1)
# Database: ######
# Generation Time: 2019-07-30 13:06:33 +0000
# ************************************************************


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;



# Dump of table fuel_auto
# ------------------------------------------------------------

DROP TABLE IF EXISTS `fuel_auto`;

CREATE TABLE `fuel_auto` (
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `price` decimal(5,2) NOT NULL,
  `station_id` varchar(32) NOT NULL,
  `station` varchar(50) NOT NULL,
  `type` varchar(12) NOT NULL DEFAULT '',
  PRIMARY KEY (`date`,`station_id`,`type`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;




# Replace placeholder table for prices_hour with correct view syntax
# ------------------------------------------------------------

DROP TABLE IF EXISTS `prices_hour`;

CREATE ALGORITHM=UNDEFINED DEFINER=`bailey`@`%` SQL SECURITY DEFINER VIEW `prices_hour`
AS SELECT
   year(`fuel_auto`.`date`) AS `y`,month(`fuel_auto`.`date`) AS `m`,dayofmonth(`fuel_auto`.`date`) AS `d`,hour(`fuel_auto`.`date`) AS `h`,avg(`fuel_auto`.`price`) AS `a`,count(`fuel_auto`.`price`) AS `c`
FROM `fuel_auto` group by year(`fuel_auto`.`date`),month(`fuel_auto`.`date`),dayofmonth(`fuel_auto`.`date`),hour(`fuel_auto`.`date`);


# Replace placeholder table for hour_freq with correct view syntax
# ------------------------------------------------------------

DROP TABLE IF EXISTS `hour_freq`;

CREATE ALGORITHM=UNDEFINED DEFINER=`bailey`@`%` SQL SECURITY DEFINER VIEW `hour_freq`
AS SELECT
   ((hour(`fuel_auto`.`date`) + 10) % 24) AS `h`,count(`fuel_auto`.`date`) AS `c`
FROM `fuel_auto` group by ((hour(`fuel_auto`.`date`) + 10) % 24) order by ((hour(`fuel_auto`.`date`) + 10) % 24);


# Replace placeholder table for prices with correct view syntax
# ------------------------------------------------------------

DROP TABLE IF EXISTS `prices`;

CREATE ALGORITHM=UNDEFINED DEFINER=`bailey`@`%` SQL SECURITY DEFINER VIEW `prices`
AS SELECT
   year(`fuel_auto`.`date`) AS `y`,month(`fuel_auto`.`date`) AS `m`,dayofmonth(`fuel_auto`.`date`) AS `d`,avg(`fuel_auto`.`price`) AS `a`,count(0) AS `n`
FROM `fuel_auto` group by year(`fuel_auto`.`date`),month(`fuel_auto`.`date`),dayofmonth(`fuel_auto`.`date`);

/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
