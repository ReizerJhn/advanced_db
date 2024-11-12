-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Nov 12, 2024 at 09:21 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `motorparts_inventory1`
--

-- --------------------------------------------------------

--
-- Table structure for table `inventory_transactions`
--

CREATE TABLE `inventory_transactions` (
  `id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `quantity_change` int(11) NOT NULL,
  `transaction_type` enum('Purchase','Sale','Adjustment') NOT NULL,
  `reference_id` int(11) DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `created_by` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `inventory_transactions`
--

INSERT INTO `inventory_transactions` (`id`, `product_id`, `quantity_change`, `transaction_type`, `reference_id`, `notes`, `created_by`, `created_at`) VALUES
(1, 1, -2, 'Sale', NULL, NULL, 4, '2024-10-20 16:02:39'),
(3, 1, 1, 'Purchase', NULL, NULL, 4, '2024-10-20 16:04:41'),
(4, 1, 1, 'Purchase', NULL, NULL, 43, '2024-10-20 16:55:02'),
(5, 1, -1, 'Sale', NULL, NULL, 43, '2024-10-20 17:00:50'),
(6, 1, -1, 'Sale', NULL, NULL, 43, '2024-10-20 17:03:12'),
(7, 1, -1, 'Sale', NULL, NULL, 43, '2024-10-20 17:12:20'),
(8, 2, -1, 'Sale', NULL, NULL, 43, '2024-10-20 17:46:06'),
(9, 2, -1, 'Sale', NULL, NULL, 43, '2024-10-20 18:00:54'),
(10, 1, 2, 'Purchase', NULL, NULL, 4, '2024-10-20 18:56:39'),
(11, 2, 1, 'Purchase', NULL, NULL, 4, '2024-10-20 19:05:02'),
(12, 2, 1, 'Purchase', NULL, NULL, 43, '2024-10-20 19:07:21'),
(13, 2, 1, 'Purchase', NULL, NULL, 4, '2024-10-20 19:08:22'),
(14, 1, -1, 'Sale', NULL, NULL, 4, '2024-10-20 19:30:32'),
(15, 46, 4, 'Purchase', NULL, NULL, 4, '2024-10-20 23:34:05'),
(16, 46, 2, 'Purchase', NULL, NULL, 4, '2024-10-20 23:34:28'),
(17, 46, 2, 'Purchase', NULL, NULL, 4, '2024-10-20 23:34:38'),
(18, 46, 4, 'Purchase', NULL, NULL, 4, '2024-10-20 23:34:54'),
(19, 46, 5, 'Purchase', NULL, NULL, 4, '2024-10-20 23:35:01'),
(20, 46, 20, 'Purchase', NULL, NULL, 4, '2024-10-20 23:35:10'),
(21, 46, -40, 'Sale', NULL, NULL, 4, '2024-10-20 23:36:04'),
(22, 3, -20, 'Sale', NULL, NULL, 4, '2024-10-20 23:36:33'),
(23, 1, 20, 'Purchase', NULL, NULL, 4, '2024-10-20 23:36:56'),
(26, 3, 3, 'Purchase', NULL, NULL, 4, '2024-10-21 00:07:10'),
(27, 1, -1, 'Sale', NULL, NULL, 4, '2024-10-21 00:07:17'),
(28, 1, -1, 'Sale', NULL, NULL, 4, '2024-10-21 00:07:17'),
(29, 47, -39, 'Sale', NULL, NULL, 43, '2024-10-21 00:36:59'),
(30, 1, -1, 'Sale', NULL, NULL, 43, '2024-10-21 00:36:59');

-- --------------------------------------------------------

--
-- Table structure for table `logs`
--

CREATE TABLE `logs` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `action` varchar(255) NOT NULL,
  `details` text DEFAULT NULL,
  `timestamp` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

CREATE TABLE `orders` (
  `id` int(11) NOT NULL,
  `customer_name` varchar(100) NOT NULL,
  `order_date` timestamp NOT NULL DEFAULT current_timestamp(),
  `total_amount` decimal(10,2) NOT NULL,
  `status` enum('Pending','Processing','Shipped','Delivered','Cancelled') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `orders`
--

INSERT INTO `orders` (`id`, `customer_name`, `order_date`, `total_amount`, `status`) VALUES
(1, 'Alice Brown', '2024-10-04 17:18:08', 100.00, 'Delivered'),
(2, 'Charlie Davis', '2024-10-04 17:18:08', 200.00, 'Processing'),
(3, 'Eva Fisher', '2024-10-04 17:18:08', 75.00, 'Pending'),
(4, 'Rei', '2024-10-19 16:00:00', 12.00, 'Pending'),
(5, 'Rei', '2024-10-19 16:00:00', 1232.00, 'Pending'),
(6, 'Rei', '2024-10-19 16:00:00', 123.00, 'Pending'),
(7, 'Rei', '2024-10-19 16:00:00', 123.00, 'Pending'),
(8, 'asd', '2024-10-19 16:00:00', 600.00, 'Pending'),
(12, 'Ryzen', '2024-10-19 16:00:00', 8000.00, 'Pending'),
(13, 'Rei', '2024-10-19 16:00:00', 42.01, 'Pending'),
(14, 'Intel', '2024-10-19 16:00:00', 3600.00, 'Pending'),
(15, 'AMD', '2024-10-19 16:00:00', 42.01, 'Pending'),
(17, 'Intel Arc', '2024-10-19 16:00:00', 1200.00, 'Pending'),
(18, 'Ryzen', '2024-10-19 16:00:00', 84.02, 'Pending'),
(19, 'Intel', '2024-10-19 16:00:00', 42.01, 'Pending'),
(20, 'Rei', '2024-10-19 16:00:00', 42.01, 'Pending'),
(21, 'Ryzen', '2024-10-19 16:00:00', 42.01, 'Pending'),
(23, 'AMD', '2024-10-19 16:00:00', 150.00, 'Pending'),
(25, 'Ryzen', '2024-10-19 16:00:00', 150.00, 'Pending'),
(26, 'Intel', '2024-10-20 16:00:00', 42.01, 'Pending'),
(27, 'Intel', '2024-10-19 16:00:00', 48000.00, 'Pending'),
(28, 'Ryzen', '2024-10-19 16:00:00', 10000.00, 'Pending'),
(31, 'Ryzen', '2024-10-20 16:00:00', 84.02, 'Pending'),
(33, 'Ryzen', '2024-10-20 16:00:00', 19500.00, 'Pending');

-- --------------------------------------------------------

--
-- Table structure for table `order_items`
--

CREATE TABLE `order_items` (
  `id` int(11) NOT NULL,
  `order_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `quantity` int(11) NOT NULL,
  `price` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `order_items`
--

INSERT INTO `order_items` (`id`, `order_id`, `product_id`, `quantity`, `price`) VALUES
(1, 1, 1, 2, 40.00),
(2, 2, 2, 1, 150.00),
(3, 3, 3, 5, 15.00),
(4, 4, 1, 1, 42.01),
(5, 5, 2, 1, 150.00),
(6, 6, 1, 1, 42.01),
(7, 7, 1, 1, 42.01),
(8, 8, 1, 2, 42.01),
(9, 12, 43, 20, 400.00),
(10, 13, 1, 1, 42.01),
(11, 14, 46, 3, 1200.00),
(12, 15, 1, 1, 42.01),
(13, 17, 43, 3, 400.00),
(14, 18, 1, 2, 42.01),
(15, 19, 1, 1, 42.01),
(16, 20, 1, 1, 42.01),
(17, 21, 1, 1, 42.01),
(18, 23, 2, 1, 150.00),
(19, 25, 2, 1, 150.00),
(20, 26, 1, 1, 42.01),
(21, 27, 46, 40, 1200.00),
(22, 28, 3, 20, 500.00),
(25, 31, 1, 1, 42.01),
(26, 31, 1, 1, 42.01),
(27, 33, 47, 39, 500.00),
(28, 33, 1, 1, 42.01);

-- --------------------------------------------------------

--
-- Table structure for table `products`
--

CREATE TABLE `products` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `sku` varchar(50) NOT NULL,
  `category` varchar(50) NOT NULL,
  `quantity` int(11) NOT NULL,
  `unit` varchar(20) NOT NULL,
  `purchase_price` decimal(10,2) NOT NULL,
  `selling_price` decimal(10,2) NOT NULL,
  `supplier_id` int(11) NOT NULL,
  `reorder_level` int(11) NOT NULL,
  `image` varchar(255) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `brand` varchar(50) NOT NULL,
  `date_added` timestamp NOT NULL DEFAULT current_timestamp(),
  `last_updated` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `products`
--

INSERT INTO `products` (`id`, `name`, `sku`, `category`, `quantity`, `unit`, `purchase_price`, `selling_price`, `supplier_id`, `reorder_level`, `image`, `description`, `brand`, `date_added`, `last_updated`) VALUES
(1, 'Brake Pad Sets', 'BP-001', 'Brake Systems', 21, 'sets', 20.01, 42.01, 1, 10, '', '', 'BrakeMasters', '2024-10-04 17:18:08', '2024-10-21 00:36:59'),
(2, 'Alternator', 'ALT-001', 'Electrical', 3, 'piece', 80.00, 150.00, 3, 5, '', '', 'PowerGen', '2024-10-04 17:18:08', '2024-10-20 19:08:22'),
(3, 'Engine Oil Filter', 'EOF-001', 'Engine', 3, 'piece', 100.00, 500.00, 1, 20, '', '', 'FilterPro', '2024-10-04 17:18:08', '2024-10-21 00:07:10'),
(43, 'Honda Motor', 'Ll13', 'Pipe', 28, 'Piece', 100.00, 400.00, 1, 2, '', 'Llll', 'BrakeMaster', '2024-10-13 04:49:37', '2024-10-20 16:02:49'),
(46, 'Honda Suspension', '54120-12', 'Suspension', 0, 'Unit', 500.00, 1200.00, 2, 2, 'uploads/671678a6a2c68_as.jpg', 'Lolz', 'Honda', '2024-10-20 15:53:17', '2024-10-21 15:52:06'),
(47, 'Brake', '565462', 'Brake Systems', 1, 'piece', 300.00, 500.00, 2, 2, 'uploads/6715a136c9db5_Picture12.png', 'hbhbkbjbkj', 'PowerGen', '2024-10-21 00:32:54', '2024-10-21 00:36:59');

-- --------------------------------------------------------

--
-- Table structure for table `reports`
--

CREATE TABLE `reports` (
  `id` int(11) NOT NULL,
  `report_name` varchar(100) NOT NULL,
  `report_type` enum('Inventory','Sales','Orders','Custom') NOT NULL,
  `parameters` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`parameters`)),
  `created_by` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `settings`
--

CREATE TABLE `settings` (
  `id` int(11) NOT NULL,
  `setting_key` varchar(50) NOT NULL,
  `setting_value` text DEFAULT NULL,
  `description` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `settings`
--

INSERT INTO `settings` (`id`, `setting_key`, `setting_value`, `description`) VALUES
(1, 'company_name', 'MotorParts Inc.', 'Company name used in reports and invoices'),
(2, 'currency', 'USD', 'Default currency for pricing'),
(3, 'tax_rate', '10', 'Default tax rate in percentage'),
(4, 'low_stock_threshold', '5', 'Threshold for low stock alerts');

-- --------------------------------------------------------

--
-- Table structure for table `suppliers`
--

CREATE TABLE `suppliers` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `contact_name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `phone` varchar(20) NOT NULL,
  `address` text NOT NULL,
  `category` varchar(50) NOT NULL,
  `logo` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `suppliers`
--

INSERT INTO `suppliers` (`id`, `name`, `contact_name`, `email`, `phone`, `address`, `category`, `logo`) VALUES
(1, 'Honda ', 'Christian Paul', 'sampaul@gmail.com', '091-214-124-1241', 'Lapu-magelan st', 'Engine Parts', 'uploads/6715342057936.png'),
(2, 'Bajaj Motors', 'JamalAlbody', 'bobross@sample.com', '0912-124-21', 'UFO', 'Brake Systems', 'uploads/671534b58abf8.png'),
(3, 'Electric Solutions', 'Chris Brown', 'CHrisblack@electricsolutions.com', '555-123-4567', '789 Oak St, Village, Country', 'Electrical Components', 'uploads/671534e923257.jpg');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `role` enum('Admin','Manager','Staff') NOT NULL,
  `profile_picture` mediumblob DEFAULT NULL,
  `last_login` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `username`, `password`, `name`, `email`, `role`, `profile_picture`, `last_login`) VALUES
(4, '', '$2y$10$tXjBhPnHABMJSisc1Cx.uui.fJDHJAcM2TBHq/0UW5E.MzwG1p5/K', 'Rezier ', 'johnmagno332@gmail.com', 'Admin', NULL, '2024-10-20 19:18:32'),
(43, 'Chrisbrown', '$2y$10$uBP0t/g6m0H.i0oVVkJXOO5sV4usCAXIkOmVrDjmX6JiTUu6ZHP3K', 'Chrisbrown', 'Chrisbrown@gmail.com', 'Manager', 0x68747470733a2f2f7265732e636c6f7564696e6172792e636f6d2f6464756a6b79667a6a2f696d6167652f75706c6f61642f76313732393434333236352f70726f66696c655f706963732f757365725f363731353335626635306534392e6a7067, '2024-10-21 00:35:41');

-- --------------------------------------------------------

--
-- Stand-in structure for view `vw_inventory_summary`
-- (See below for the actual view)
--
CREATE TABLE `vw_inventory_summary` (
`id` int(11)
,`name` varchar(100)
,`in_stock` int(11)
,`out_of_stock` int(1)
,`low_stock_threshold` int(11)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `vw_parts_by_type`
-- (See below for the actual view)
--
CREATE TABLE `vw_parts_by_type` (
`type` varchar(50)
,`part_count` bigint(21)
,`total_quantity` decimal(32,0)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `vw_weekly_order_volume`
-- (See below for the actual view)
--
CREATE TABLE `vw_weekly_order_volume` (
`order_date` date
,`order_count` bigint(21)
,`total_amount` decimal(32,2)
);

-- --------------------------------------------------------

--
-- Structure for view `vw_inventory_summary`
--
DROP TABLE IF EXISTS `vw_inventory_summary`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_inventory_summary`  AS SELECT `p`.`id` AS `id`, `p`.`name` AS `name`, `p`.`quantity` AS `in_stock`, CASE WHEN `p`.`quantity` = 0 THEN 1 ELSE 0 END AS `out_of_stock`, `p`.`reorder_level` AS `low_stock_threshold` FROM `products` AS `p` ;

-- --------------------------------------------------------

--
-- Structure for view `vw_parts_by_type`
--
DROP TABLE IF EXISTS `vw_parts_by_type`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_parts_by_type`  AS SELECT `products`.`category` AS `type`, count(0) AS `part_count`, sum(`products`.`quantity`) AS `total_quantity` FROM `products` GROUP BY `products`.`category` ;

-- --------------------------------------------------------

--
-- Structure for view `vw_weekly_order_volume`
--
DROP TABLE IF EXISTS `vw_weekly_order_volume`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_weekly_order_volume`  AS SELECT cast(`orders`.`order_date` as date) AS `order_date`, count(0) AS `order_count`, sum(`orders`.`total_amount`) AS `total_amount` FROM `orders` WHERE `orders`.`order_date` >= curdate() - interval 7 day GROUP BY cast(`orders`.`order_date` as date) ORDER BY cast(`orders`.`order_date` as date) ASC ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `inventory_transactions`
--
ALTER TABLE `inventory_transactions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `product_id` (`product_id`),
  ADD KEY `created_by` (`created_by`);

--
-- Indexes for table `logs`
--
ALTER TABLE `logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `order_items`
--
ALTER TABLE `order_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `order_id` (`order_id`),
  ADD KEY `product_id` (`product_id`);

--
-- Indexes for table `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `sku` (`sku`),
  ADD KEY `supplier_id` (`supplier_id`);

--
-- Indexes for table `reports`
--
ALTER TABLE `reports`
  ADD PRIMARY KEY (`id`),
  ADD KEY `created_by` (`created_by`);

--
-- Indexes for table `settings`
--
ALTER TABLE `settings`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `setting_key` (`setting_key`);

--
-- Indexes for table `suppliers`
--
ALTER TABLE `suppliers`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `inventory_transactions`
--
ALTER TABLE `inventory_transactions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=31;

--
-- AUTO_INCREMENT for table `logs`
--
ALTER TABLE `logs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `orders`
--
ALTER TABLE `orders`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=34;

--
-- AUTO_INCREMENT for table `order_items`
--
ALTER TABLE `order_items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=29;

--
-- AUTO_INCREMENT for table `products`
--
ALTER TABLE `products`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=48;

--
-- AUTO_INCREMENT for table `reports`
--
ALTER TABLE `reports`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `settings`
--
ALTER TABLE `settings`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `suppliers`
--
ALTER TABLE `suppliers`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=44;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `inventory_transactions`
--
ALTER TABLE `inventory_transactions`
  ADD CONSTRAINT `inventory_transactions_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`),
  ADD CONSTRAINT `inventory_transactions_ibfk_2` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`);

--
-- Constraints for table `logs`
--
ALTER TABLE `logs`
  ADD CONSTRAINT `logs_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `order_items`
--
ALTER TABLE `order_items`
  ADD CONSTRAINT `order_items_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`),
  ADD CONSTRAINT `order_items_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`);

--
-- Constraints for table `products`
--
ALTER TABLE `products`
  ADD CONSTRAINT `products_ibfk_1` FOREIGN KEY (`supplier_id`) REFERENCES `suppliers` (`id`);

--
-- Constraints for table `reports`
--
ALTER TABLE `reports`
  ADD CONSTRAINT `reports_ibfk_1` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
