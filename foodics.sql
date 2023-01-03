-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jan 04, 2023 at 12:46 AM
-- Server version: 10.4.25-MariaDB
-- PHP Version: 8.1.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `foodics`
--

-- --------------------------------------------------------

--
-- Table structure for table `ingredient`
--

CREATE TABLE `ingredient` (
  `ingredient_id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `quantity` float NOT NULL,
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `ingredient`
--

INSERT INTO `ingredient` (`ingredient_id`, `name`, `quantity`, `updated_at`) VALUES
(1, 'Beef', 19500, '2023-01-03 21:29:21'),
(2, 'Cheese', 4860, '2023-01-03 21:29:57'),
(3, 'Onion', 910, '2023-01-03 21:30:19');

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

CREATE TABLE `orders` (
  `order_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `quantity` int(11) NOT NULL,
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `orders`
--

INSERT INTO `orders` (`order_id`, `user_id`, `quantity`, `updated_at`) VALUES
(1, 1, 3, '2023-01-03 23:40:59');

-- --------------------------------------------------------

--
-- Table structure for table `order_products`
--

CREATE TABLE `order_products` (
  `id` int(11) NOT NULL,
  `order_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `order_products`
--

INSERT INTO `order_products` (`id`, `order_id`, `product_id`, `updated_at`) VALUES
(1, 1, 1, '2023-01-03 23:40:59'),
(2, 1, 2, '2023-01-03 23:40:59');

-- --------------------------------------------------------

--
-- Table structure for table `products`
--

CREATE TABLE `products` (
  `product_id` mediumint(8) UNSIGNED NOT NULL,
  `product_code` varchar(64) NOT NULL DEFAULT '',
  `status` char(1) NOT NULL DEFAULT 'A',
  `amount` mediumint(9) NOT NULL DEFAULT 0,
  `timestamp` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `updated_timestamp` int(10) UNSIGNED NOT NULL DEFAULT 0
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Dumping data for table `products`
--

INSERT INTO `products` (`product_id`, `product_code`, `status`, `amount`, `timestamp`, `updated_timestamp`) VALUES
(1, 'PRODUCT_1', 'A', 1, 1658299187, 1658299187),
(2, 'PRODUCT_14', 'A', 1, 1662721543, 1662721543),
(3, 'PRODUCT_5', 'A', 1, 1662466511, 1662466511),
(4, 'PRODUCT_9', 'A', 1, 1662544000, 1662544000),
(5, 'PRODUCT_7', 'A', 1, 1662544196, 1662544196);

-- --------------------------------------------------------

--
-- Table structure for table `product_ingredient`
--

CREATE TABLE `product_ingredient` (
  `id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `ingredient_id` int(11) NOT NULL,
  `quantity` float NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `product_ingredient`
--

INSERT INTO `product_ingredient` (`id`, `product_id`, `ingredient_id`, `quantity`) VALUES
(1, 1, 1, 150),
(2, 1, 2, 30),
(3, 1, 3, 20),
(4, 2, 1, 200),
(5, 2, 2, 80),
(6, 2, 3, 50);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `ingredient`
--
ALTER TABLE `ingredient`
  ADD PRIMARY KEY (`ingredient_id`);

--
-- Indexes for table `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`order_id`);

--
-- Indexes for table `order_products`
--
ALTER TABLE `order_products`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`product_id`),
  ADD KEY `status` (`status`);

--
-- Indexes for table `product_ingredient`
--
ALTER TABLE `product_ingredient`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `quantity` (`product_id`,`ingredient_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `ingredient`
--
ALTER TABLE `ingredient`
  MODIFY `ingredient_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `orders`
--
ALTER TABLE `orders`
  MODIFY `order_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `order_products`
--
ALTER TABLE `order_products`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `products`
--
ALTER TABLE `products`
  MODIFY `product_id` mediumint(8) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=64;

--
-- AUTO_INCREMENT for table `product_ingredient`
--
ALTER TABLE `product_ingredient`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
