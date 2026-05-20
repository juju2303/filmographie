/*M!999999\- enable the sandbox mode */ 
-- MariaDB dump 10.19-11.8.6-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: filmographie
-- ------------------------------------------------------
-- Server version	11.8.6-MariaDB-0+deb13u1 from Debian

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*M!100616 SET @OLD_NOTE_VERBOSITY=@@NOTE_VERBOSITY, NOTE_VERBOSITY=0 */;

--
-- Table structure for table `acteur`
--

DROP TABLE IF EXISTS `acteur`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `acteur` (
  `id_acteur` int(11) NOT NULL AUTO_INCREMENT,
  `nom` varchar(100) NOT NULL,
  `prenom` varchar(100) NOT NULL,
  `age` int(11) DEFAULT NULL,
  `photo` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id_acteur`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `acteur`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `acteur` WRITE;
/*!40000 ALTER TABLE `acteur` DISABLE KEYS */;
INSERT INTO `acteur` VALUES
(1,'DiCaprio','Leonardo',49,'dicaprio.jpg'),
(2,'Crowe','Russell',60,'crowe.jpg'),
(3,'McConaughey','Matthew',54,'mcconaughey.jpg'),
(4,'Bale','Christian',51,'bale.jpg'),
(5,'Phoenix','Joaquin',50,'phoenix.jpg'),
(6,'Downey Jr','Robert',60,'downey.jpg'),
(7,'Winslet','Kate',49,'winslet.jpg'),
(8,'Worthington','Sam',48,'worthington.jpg');
/*!40000 ALTER TABLE `acteur` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `categorie`
--

DROP TABLE IF EXISTS `categorie`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `categorie` (
  `id_categorie` int(11) NOT NULL AUTO_INCREMENT,
  `nom` varchar(100) NOT NULL,
  `descriptif` text DEFAULT NULL,
  PRIMARY KEY (`id_categorie`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `categorie`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `categorie` WRITE;
/*!40000 ALTER TABLE `categorie` DISABLE KEYS */;
INSERT INTO `categorie` VALUES
(1,'Action','Films avec combats et poursuites'),
(2,'Science-fiction','Films sur le futur, la technologie ou l espace'),
(3,'Drame','Films avec une histoire emotionnelle'),
(4,'Comedie','Films humoristiques et divertissants'),
(5,'Horreur','Films avec suspense et peur'),
(6,'Animation','Films d animation pour tous les ages'),
(7,'Thriller','Films avec tension et suspense'),
(8,'Aventure','Films bases sur les voyages et explorations');
/*!40000 ALTER TABLE `categorie` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `commentaire`
--

DROP TABLE IF EXISTS `commentaire`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `commentaire` (
  `id_commentaire` int(11) NOT NULL AUTO_INCREMENT,
  `id_film` int(11) NOT NULL,
  `id_personne` int(11) NOT NULL,
  `note` int(11) NOT NULL,
  `commentaire` text DEFAULT NULL,
  `date_commentaire` date NOT NULL,
  PRIMARY KEY (`id_commentaire`),
  KEY `id_film` (`id_film`),
  KEY `id_personne` (`id_personne`),
  CONSTRAINT `commentaire_ibfk_1` FOREIGN KEY (`id_film`) REFERENCES `film` (`id_film`) ON DELETE CASCADE,
  CONSTRAINT `commentaire_ibfk_2` FOREIGN KEY (`id_personne`) REFERENCES `personne` (`id_personne`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `commentaire`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `commentaire` WRITE;
/*!40000 ALTER TABLE `commentaire` DISABLE KEYS */;
INSERT INTO `commentaire` VALUES
(1,1,1,9,'Tres bon film avec un scenario complexe.','2026-05-01'),
(2,1,2,8,'Film interessant et bien realise.','2026-05-02'),
(3,2,2,7,'Bon film d action avec de bonnes scenes.','2026-05-03'),
(4,3,3,10,'Chef oeuvre de science fiction.','2026-05-04'),
(5,4,4,9,'Film impressionnant visuellement.','2026-05-05'),
(6,5,5,10,'Excellent film dramatique.','2026-05-06'),
(7,6,6,8,'Tres bon film de super heros.','2026-05-07'),
(8,7,7,7,'Film interessant mais un peu long.','2026-05-08');
/*!40000 ALTER TABLE `commentaire` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `film`
--

DROP TABLE IF EXISTS `film`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `film` (
  `id_film` int(11) NOT NULL AUTO_INCREMENT,
  `titre` varchar(150) NOT NULL,
  `annee_sortie` int(11) NOT NULL,
  `affiche` varchar(255) DEFAULT NULL,
  `realisateur` varchar(150) DEFAULT NULL,
  `id_categorie` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_film`),
  KEY `id_categorie` (`id_categorie`),
  CONSTRAINT `film_ibfk_1` FOREIGN KEY (`id_categorie`) REFERENCES `categorie` (`id_categorie`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `film`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `film` WRITE;
/*!40000 ALTER TABLE `film` DISABLE KEYS */;
INSERT INTO `film` VALUES
(1,'Inception',2010,'inception.jpg','Christopher Nolan',2),
(2,'Gladiator',2000,'gladiator.jpg','Ridley Scott',1),
(3,'Interstellar',2014,'interstellar.jpg','Christopher Nolan',2),
(4,'Avatar',2009,'avatar.jpg','James Cameron',2),
(5,'Titanic',1997,'titanic.jpg','James Cameron',3),
(6,'The Dark Knight',2008,'darkknight.jpg','Christopher Nolan',1),
(7,'Joker',2019,'joker.jpg','Todd Phillips',7),
(8,'Avengers Endgame',2019,'endgame.jpg','Anthony Russo',1),
(9,'Mad Max Fury Road',2015,'madmax.jpg','George Miller',1),
(10,'John Wick',2014,'johnwick.jpg','Chad Stahelski',1),
(11,'Matrix',1999,'matrix.jpg','Wachowski',2),
(12,'Blade Runner 2049',2017,'bladerunner.jpg','Denis Villeneuve',2),
(13,'The Green Mile',1999,'greenmile.jpg','Frank Darabont',3),
(14,'Forrest Gump',1994,'forrestgump.jpg','Robert Zemeckis',3),
(15,'Very Bad Trip',2009,'hangover.jpg','Todd Phillips',4),
(16,'Intouchables',2011,'intouchables.jpg','Olivier Nakache',4),
(17,'Conjuring',2013,'conjuring.jpg','James Wan',5),
(18,'Insidious',2010,'insidious.jpg','James Wan',5),
(19,'Toy Story',1995,'toystory.jpg','John Lasseter',6),
(20,'Le Roi Lion',1994,'lionking.jpg','Roger Allers',6),
(21,'Seven',1995,'seven.jpg','David Fincher',7),
(22,'Shutter Island',2010,'shutterisland.jpg','Martin Scorsese',7),
(23,'Indiana Jones',1981,'indiana.jpg','Steven Spielberg',8),
(24,'Pirates des Caraibes',2003,'pirates.jpg','Gore Verbinski',8);
/*!40000 ALTER TABLE `film` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `jouer`
--

DROP TABLE IF EXISTS `jouer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `jouer` (
  `id_film` int(11) NOT NULL,
  `id_acteur` int(11) NOT NULL,
  PRIMARY KEY (`id_film`,`id_acteur`),
  KEY `id_acteur` (`id_acteur`),
  CONSTRAINT `jouer_ibfk_1` FOREIGN KEY (`id_film`) REFERENCES `film` (`id_film`) ON DELETE CASCADE,
  CONSTRAINT `jouer_ibfk_2` FOREIGN KEY (`id_acteur`) REFERENCES `acteur` (`id_acteur`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `jouer`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `jouer` WRITE;
/*!40000 ALTER TABLE `jouer` DISABLE KEYS */;
INSERT INTO `jouer` VALUES
(1,1),
(2,2),
(3,3),
(6,4),
(7,5),
(8,6),
(5,7),
(4,8);
/*!40000 ALTER TABLE `jouer` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `personne`
--

DROP TABLE IF EXISTS `personne`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `personne` (
  `id_personne` int(11) NOT NULL AUTO_INCREMENT,
  `pseudo` varchar(100) NOT NULL,
  `nom_prenom` varchar(150) NOT NULL,
  `mail` varchar(150) NOT NULL,
  `mot_de_passe` varchar(255) NOT NULL,
  `type_personne` enum('professionnel','amateur') NOT NULL,
  PRIMARY KEY (`id_personne`),
  UNIQUE KEY `pseudo` (`pseudo`),
  UNIQUE KEY `mail` (`mail`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `personne`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `personne` WRITE;
/*!40000 ALTER TABLE `personne` DISABLE KEYS */;
INSERT INTO `personne` VALUES
(1,'cinepro','Jean Martin','jean.martin@mail.com','1234','professionnel'),
(2,'filmfan68','Lucas Bernard','lucas.bernard@mail.com','1234','amateur'),
(3,'movieaddict','Sarah Klein','sarah@mail.com','1234','amateur'),
(4,'critiquepro','Thomas Leroy','thomas@mail.com','1234','professionnel'),
(5,'cinema67','Emma Petit','emma@mail.com','1234','amateur'),
(6,'proreview','David Morel','david@mail.com','1234','professionnel'),
(7,'filmlover','Nina Garcia','nina@mail.com','1234','amateur');
/*!40000 ALTER TABLE `personne` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*M!100616 SET NOTE_VERBOSITY=@OLD_NOTE_VERBOSITY */;

-- Dump completed on 2026-05-20 14:01:08
