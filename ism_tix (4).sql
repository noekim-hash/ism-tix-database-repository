-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Hôte : 127.0.0.1
-- Généré le : sam. 17 jan. 2026 à 12:30
-- Version du serveur : 10.4.32-MariaDB
-- Version de PHP : 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données : `ism_tix`
--

-- --------------------------------------------------------

--
-- Structure de la table `area`
--

CREATE TABLE `area` (
  `area_id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `area`
--

INSERT INTO `area` (`area_id`, `name`) VALUES
(1, 'Seating'),
(2, 'Standing');

-- --------------------------------------------------------

--
-- Structure de la table `artist`
--

CREATE TABLE `artist` (
  `artist_id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `artist`
--

INSERT INTO `artist` (`artist_id`, `name`) VALUES
(1, 'Kraftwerk'),
(2, 'Coldplay'),
(3, 'Adele'),
(4, 'Ed Sheeran'),
(5, 'Daft Punk');

-- --------------------------------------------------------

--
-- Structure de la table `customer`
--

CREATE TABLE `customer` (
  `customer_id` int(11) NOT NULL,
  `first_name` varchar(100) NOT NULL,
  `last_name` varchar(100) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `customer`
--

INSERT INTO `customer` (`customer_id`, `first_name`, `last_name`, `email`, `password`) VALUES
(1, 'Anna', 'Meyer', 'anna.meyer@test.com', 'pw123'),
(2, 'Jonas', 'Schmidt', 'jonas.schmidt@test.com', 'pw123'),
(3, 'Laura', 'Fischer', 'laura.fischer@test.com', 'pw123'),
(4, 'Max', 'Becker', 'max.becker@test.com', 'pw123');

-- --------------------------------------------------------

--
-- Structure de la table `event_details`
--

CREATE TABLE `event_details` (
  `event_id` int(11) NOT NULL,
  `event_date` date NOT NULL,
  `status` varchar(50) NOT NULL,
  `city` varchar(100) NOT NULL,
  `location_name` varchar(255) NOT NULL,
  `artist_id` int(11) NOT NULL,
  `tour_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `event_details`
--

INSERT INTO `event_details` (`event_id`, `event_date`, `status`, `city`, `location_name`, `artist_id`, `tour_id`) VALUES
(1, '2025-11-10', 'scheduled', 'Hamburg', 'Elbphilharmonie Hamburg', 1, NULL),
(2, '2025-11-11', 'scheduled', 'Hamburg', 'Elbphilharmonie Hamburg', 1, NULL),
(3, '2025-11-15', 'scheduled', 'Hamburg', 'Elbphilharmonie Hamburg', 2, NULL),
(4, '2025-11-20', 'scheduled', 'Hamburg', 'Elbphilharmonie Hamburg', 3, NULL),
(5, '2025-11-25', 'scheduled', 'Hamburg', 'Elbphilharmonie Hamburg', 4, NULL);

-- --------------------------------------------------------

--
-- Structure de la table `orders`
--

CREATE TABLE `orders` (
  `order_id` int(11) NOT NULL,
  `order_date` datetime NOT NULL,
  `total_price` decimal(10,2) NOT NULL,
  `customer_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `orders`
--

INSERT INTO `orders` (`order_id`, `order_date`, `total_price`, `customer_id`) VALUES
(1, '2026-01-17 13:25:41', 160.00, 1),
(2, '2026-01-17 13:25:41', 65.00, 2);

-- --------------------------------------------------------

--
-- Structure de la table `ticket`
--

CREATE TABLE `ticket` (
  `ticket_id` int(11) NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `event_id` int(11) NOT NULL,
  `order_id` int(11) NOT NULL,
  `area_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `ticket`
--

INSERT INTO `ticket` (`ticket_id`, `price`, `event_id`, `order_id`, `area_id`) VALUES
(1, 80.00, 1, 1, 1),
(2, 80.00, 1, 1, 1),
(3, 65.00, 2, 2, 2);

--
-- Déclencheurs `ticket`
--
DELIMITER $$
CREATE TRIGGER `trg_update_total_price` AFTER INSERT ON `ticket` FOR EACH ROW BEGIN
    UPDATE Orders
    SET total_price = total_price + NEW.price
    WHERE order_id = NEW.order_id;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `tour`
--

CREATE TABLE `tour` (
  `tour_id` int(11) NOT NULL,
  `tour_name` varchar(255) NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Index pour les tables déchargées
--

--
-- Index pour la table `area`
--
ALTER TABLE `area`
  ADD PRIMARY KEY (`area_id`);

--
-- Index pour la table `artist`
--
ALTER TABLE `artist`
  ADD PRIMARY KEY (`artist_id`);

--
-- Index pour la table `customer`
--
ALTER TABLE `customer`
  ADD PRIMARY KEY (`customer_id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Index pour la table `event_details`
--
ALTER TABLE `event_details`
  ADD PRIMARY KEY (`event_id`),
  ADD KEY `fk_event_artist` (`artist_id`),
  ADD KEY `fk_event_tour` (`tour_id`);

--
-- Index pour la table `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`order_id`),
  ADD KEY `fk_order_customer` (`customer_id`);

--
-- Index pour la table `ticket`
--
ALTER TABLE `ticket`
  ADD PRIMARY KEY (`ticket_id`),
  ADD KEY `fk_ticket_event` (`event_id`),
  ADD KEY `fk_ticket_order` (`order_id`),
  ADD KEY `fk_ticket_area` (`area_id`);

--
-- Index pour la table `tour`
--
ALTER TABLE `tour`
  ADD PRIMARY KEY (`tour_id`);

--
-- AUTO_INCREMENT pour les tables déchargées
--

--
-- AUTO_INCREMENT pour la table `area`
--
ALTER TABLE `area`
  MODIFY `area_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT pour la table `artist`
--
ALTER TABLE `artist`
  MODIFY `artist_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT pour la table `customer`
--
ALTER TABLE `customer`
  MODIFY `customer_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT pour la table `event_details`
--
ALTER TABLE `event_details`
  MODIFY `event_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT pour la table `orders`
--
ALTER TABLE `orders`
  MODIFY `order_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT pour la table `ticket`
--
ALTER TABLE `ticket`
  MODIFY `ticket_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT pour la table `tour`
--
ALTER TABLE `tour`
  MODIFY `tour_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- Contraintes pour les tables déchargées
--

--
-- Contraintes pour la table `event_details`
--
ALTER TABLE `event_details`
  ADD CONSTRAINT `fk_event_artist` FOREIGN KEY (`artist_id`) REFERENCES `artist` (`artist_id`),
  ADD CONSTRAINT `fk_event_tour` FOREIGN KEY (`tour_id`) REFERENCES `tour` (`tour_id`);

--
-- Contraintes pour la table `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `fk_order_customer` FOREIGN KEY (`customer_id`) REFERENCES `customer` (`customer_id`);

--
-- Contraintes pour la table `ticket`
--
ALTER TABLE `ticket`
  ADD CONSTRAINT `fk_ticket_area` FOREIGN KEY (`area_id`) REFERENCES `area` (`area_id`),
  ADD CONSTRAINT `fk_ticket_event` FOREIGN KEY (`event_id`) REFERENCES `event_details` (`event_id`),
  ADD CONSTRAINT `fk_ticket_order` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
