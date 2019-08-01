DROP TABLE IF EXISTS `fuel_auto`;

CREATE TABLE `fuel_auto` (
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `price` decimal(5,2) NOT NULL,
  `station_id` varchar(32) NOT NULL,
  `station` varchar(50) NOT NULL,
  `type` varchar(12) NOT NULL DEFAULT '',
  PRIMARY KEY (`date`,`station_id`,`type`)
);


DROP TABLE IF EXISTS `prices_hour`;

CREATE ALGORITHM=UNDEFINED DEFINER=`bailey`@`%` SQL SECURITY DEFINER VIEW `prices_hour`
AS SELECT
   year(`fuel_auto`.`date`) AS `y`,month(`fuel_auto`.`date`) AS `m`,dayofmonth(`fuel_auto`.`date`) AS `d`,hour(`fuel_auto`.`date`) AS `h`,avg(`fuel_auto`.`price`) AS `a`,count(`fuel_auto`.`price`) AS `c`
FROM `fuel_auto` group by year(`fuel_auto`.`date`),month(`fuel_auto`.`date`),dayofmonth(`fuel_auto`.`date`),hour(`fuel_auto`.`date`);

-- CREATE TABLE `prices_hour` ();

DROP TABLE IF EXISTS `hour_freq`;

CREATE ALGORITHM=UNDEFINED DEFINER=`bailey`@`%` SQL SECURITY DEFINER VIEW `hour_freq`
AS SELECT
   ((hour(`fuel_auto`.`date`) + 10) % 24) AS `h`,count(`fuel_auto`.`date`) AS `c`
FROM `fuel_auto` group by ((hour(`fuel_auto`.`date`) + 10) % 24) order by ((hour(`fuel_auto`.`date`) + 10) % 24);

-- CREATE TABLE `hour-freq` ();

DROP TABLE IF EXISTS `prices`;

CREATE ALGORITHM=UNDEFINED DEFINER=`bailey`@`%` SQL SECURITY DEFINER VIEW `prices`
AS SELECT
   year(`fuel_auto`.`date`) AS `y`,month(`fuel_auto`.`date`) AS `m`,dayofmonth(`fuel_auto`.`date`) AS `d`,avg(`fuel_auto`.`price`) AS `a`,count(0) AS `n`
FROM `fuel_auto` group by year(`fuel_auto`.`date`),month(`fuel_auto`.`date`),dayofmonth(`fuel_auto`.`date`);

-- CREATE TABLE `prices` ();

DROP TABLE IF EXISTS `run_meta`;

CREATE TABLE `run_meta` (
  `id` int NOT NULL AUTO_INCREMENT,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `duration` int NOT NULL,
  `found` int NOT NULL,
  `inserted` int NOT NULL,
  `total_post_run` int NOT NULL,
  PRIMARY KEY (`id`)
);

INSERT INTO `run_meta` (`duration`, `found`, `inserted`, `total_post_run`) VALUES (0, 0, 0, (SELECT COUNT(*) FROM fuel_auto));