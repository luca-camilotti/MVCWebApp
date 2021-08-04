-- Adminer 4.1.0 MySQL dump

SET NAMES utf8;
SET time_zone = '+00:00';
SET foreign_key_checks = 0;
SET sql_mode = 'NO_AUTO_VALUE_ON_ZERO';

DROP TABLE IF EXISTS `account`;
CREATE TABLE `account` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `surname` varchar(50) NOT NULL,
  `email` varchar(50) NOT NULL,
  `pwd` varchar(50) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `account` (`id`, `name`, `surname`, `email`, `pwd`) VALUES
(1,	'Pippo',	'De Pippis',	'pippo@supersballo.gov',	'0c88028bf3aa6a6a143ed846f2be1ea4'),
(2,	'Pluto',	'De Plutis',	'pluto@ultrafico.yes',	'c6009f08fc5fc6385f1ea1f5840e179f'),
(3,	'Paperino',	'De Paperis',	'paperino@supersballo.gov',	'b54b45b19ca1f1ddc424e6b878a53f2d');

DROP TABLE IF EXISTS `dipendente`;
CREATE TABLE `dipendente` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nome` varchar(40) NOT NULL,
  `cognome` varchar(40) NOT NULL,
  `stipendio` int(11) NOT NULL,
  `funzione` varchar(40) NOT NULL,
  `filiale` varchar(40) NOT NULL,
  `livello` tinyint(4) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `dipendente` (`id`, `nome`, `cognome`, `stipendio`, `funzione`, `filiale`, `livello`) VALUES
(1,	'mario',	'rossi',	1100,	'impiegato',	'pisa',	4),
(2,	'paolo',	'verdi',	1250,	'manager',	'roma',	3),
(3,	'giulio',	'leonardo',	1150,	'impiegato',	'viareggio',	0),
(4,	'leonardo',	'patrizio',	1150,	'impiegato',	'milano',	6),
(5,	'paolo',	'rossi',	2000,	'vicedirettore',	'roma',	14),
(6,	'mauro',	'viviani',	1343,	'manager',	'milano',	9),
(7,	'luigi',	'crasti',	3500,	'direttore',	'viareggio',	17),
(8,	'daniele',	'romani',	1950,	'manager',	'pisa',	1),
(9,	'patrizio',	'bertuccelli',	2100,	'manager',	'milano',	7),
(10,	'maurizio',	'landi',	1200,	'impiegato',	'pisa',	5),
(11,	'gino ',	'bersetti',	1505,	'impiegato',	'pisa',	6),
(12,	'gabriele',	'giannoni',	1800,	'manager',	'milano',	11),
(13,	'marco',	'bracco',	1000,	'impiegato',	'viareggio',	1),
(14,	'abramo',	'bundi',	1750,	'manager',	'viareggio',	8),
(15,	'michele',	'zaratu',	1050,	'impiegato',	'pisa',	2),
(24,	'Pluto',	'Verdi',	15000,	'Nessuna',	'Gotham',	10),
(25,	'Pippo',	'De Pippis',	1250,	'Bidello',	'New York',	3),
(26,	'Yoghi',	'Bear',	2500,	'Orso',	'Roma',	12),
(27,	'Chuck',	'Norris',	1280,	'fattorino',	'Miami',	15),
(28,	'John',	'Rambo',	1550,	'body guard',	'Miami',	9),
(32,	'Chuck',	'Norris',	100000,	'nulla',	'mahh',	3),
(33,	'Peter',	'Parker',	750,	'fotografo',	'New York',	2);

DROP TABLE IF EXISTS `upload`;
CREATE TABLE `upload` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `date` date NOT NULL,
  `file` longblob NOT NULL,
  `description` varchar(250) NOT NULL,
  `name` varchar(250) NOT NULL,
  `size` bigint(20) NOT NULL,
  `fkid` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- 2021-08-04 14:06:22
