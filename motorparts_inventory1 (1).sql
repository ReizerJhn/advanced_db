-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Oct 14, 2024 at 05:15 PM
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
(1, 1, 2, 'Purchase', NULL, NULL, 4, '2024-10-14 15:13:59');

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
(3, 'Eva Fisher', '2024-10-04 17:18:08', 75.00, 'Pending');

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
(3, 3, 3, 5, 15.00);

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
(1, 'Brake Pad Sets', 'BP-001', 'Brake Systems', 20, 'sets', 20.00, 40.01, 1, 10, '', '', 'BrakeMasters', '2024-10-04 17:18:08', '2024-10-14 15:13:59'),
(2, 'Alternator', 'ALT-001', 'Electrical', 39, 'piece', 80.00, 150.00, 3, 5, NULL, NULL, 'PowerGen', '2024-10-04 17:18:08', '2024-10-14 14:44:12'),
(3, 'Engine Oil Filter', 'EOF-001', 'Engine', 101, 'piece', 5.00, 15.00, 1, 20, NULL, NULL, 'FilterPro', '2024-10-04 17:18:08', '2024-10-13 09:52:55'),
(39, 'Engine Oil', '5211213', 'Oil', 28, 'Piece', 300.00, 122.00, 1, 12, '', 'Downy', 'Zonrox', '2024-10-13 04:00:21', '2024-10-13 07:51:30'),
(43, 'Honda Motor', 'Ll13', 'Pipe', 3, 'Piece', 100.00, 400.00, 1, 2, 'uploads/670b883aca4f4_as.jpg', 'Llll', 'BrakeMaster', '2024-10-13 04:49:37', '2024-10-13 08:43:38');

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
  `status` enum('Active','Inactive') NOT NULL,
  `rating` decimal(3,2) NOT NULL,
  `payment_terms` varchar(100) NOT NULL,
  `logo` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `suppliers`
--

INSERT INTO `suppliers` (`id`, `name`, `contact_name`, `email`, `phone`, `address`, `category`, `status`, `rating`, `payment_terms`, `logo`) VALUES
(1, 'AutoParts Inc.', 'John Doe', 'john@autoparts.com', '123-456-7890', '123 Main St, City, Country', 'Engine Parts', 'Active', 4.50, 'Net 30', NULL),
(2, 'Brake Masters', 'Jane Smith', 'jane@brakemasters.com', '987-654-3210', '456 Elm St, Town, Country', 'Brake Systems', 'Active', 4.20, 'Net 15', NULL),
(3, 'Electric Solutions', 'Bob Johnson', 'bob@electricsolutions.com', '555-123-4567', '789 Oak St, Village, Country', 'Electrical Components', 'Active', 4.00, 'Net 45', NULL);

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
(4, '', '$2y$10$9sDhWBqZH/d7XnMoZEXjs.507kcJZXuqWRJKxayk6bRDLSEbwkAAi', 'Rezier ', 'johnmagno332@gmail.com', 'Admin', NULL, '2024-10-14 14:40:59'),
(27, 'Dragonssasd', '$2y$10$og5Ue3ODiXFsMISFK8Ngh.EtMCIFwl9JsQjvnFs8mgHA4naqGdcWK', 'Rezoersdasdasd', 'rezierjasdogasdn@gmail.com', 'Admin', 0x68747470733a2f2f7265732e636c6f7564696e6172792e636f6d2f6464756a6b79667a6a2f696d6167652f75706c6f61642f76313732383831313136342f70726f66696c655f706963732f757365725f363730623930396161623430642e6a7067, '2024-10-13 09:19:24'),
(31, '1512', '$2y$10$kQDK17SSKDYBkzRtGPWjCOiGq5MeJ2cqKrwxFjB.gJEb38qh6u8k6', '125125', 'joevinansoc870@gmail.com', 'Admin', 0x68747470733a2f2f7265732e636c6f7564696e6172792e636f6d2f6464756a6b79667a6a2f696d6167652f75706c6f61642f76313732383831313239352f70726f66696c655f706963732f757365725f363730623931316532356462342e6a7067, '2024-10-13 09:21:35'),
(33, 'Dragonsszcx', '$2y$10$6WwInB9l5XrJKnnWllgn.ef/sHWlhJVX/ET6Fl8X5NHiIrGwcBZeK', 'Cocoak', 'rezier@gmail.com', 'Manager', 0x68747470733a2f2f7265732e636c6f7564696e6172792e636f6d2f6464756a6b79667a6a2f696d6167652f75706c6f61642f76313732383831333134302f70726f66696c655f706963732f757365725f363730623938353263316164632e6a7067, '2024-10-13 09:52:20'),
(37, '23453', '$2y$10$EDLq13KEtBstqvjq7niLMe3oJg6ygp.8cF4NmaZJ8fQhI29eYKOpa', '345354gghjg', 'asdasdasdf@gmail.com', 'Manager', 0x68747470733a2f2f7265732e636c6f7564696e6172792e636f6d2f6464756a6b79667a6a2f696d6167652f75706c6f61642f76313732383931313132342f70726f66696c655f706963732f757365725f363730643136666262376336662e6a7067, '2024-10-14 13:05:23'),
(39, '12412421', '$2y$10$wknjEEYRMcXa/oDvirTpBunH/fe1syvpFHTyo78M8yveljY5.4rzS', '14214212', 'johnmagno32512@gmail.com', 'Admin', 0x68747470733a2f2f7265732e636c6f7564696e6172792e636f6d2f6464756a6b79667a6a2f696d6167652f75706c6f61642f76313732383931313137322f70726f66696c655f706963732f757365725f363730643137336162633163372e6a7067, '2024-10-14 13:06:13'),
(40, 'as12412', '$2y$10$Lx8RFgjl3HLR8gK5uuhGjukdCDsaVHT3imKdJN/RGq1F4JF3YVmYC', 'asdasd12', 'johnm1212agno332@gmail.com', 'Admin', 0x68747470733a2f2f7265732e636c6f7564696e6172792e636f6d2f6464756a6b79667a6a2f696d6167652f75706c6f61642f76313732383931323039352f70726f66696c655f706963732f757365725f363730643161646435343430632e6a7067, '2024-10-14 13:21:35'),
(42, 'Dragonss1', '$2y$10$2KZwAltbyFJwK5V/Jueahe5FmX7ngqTv1gFwuDw4Sh3Gz.eBwYQ2C', 'asd12231', 'joevinansoc87120@gmail.com', 'Manager', 0x68747470733a2f2f7265732e636c6f7564696e6172792e636f6d2f6464756a6b79667a6a2f696d6167652f75706c6f61642f76313732383931353037332f70726f66696c655f706963732f757365725f363730643236373830363463392e6a7067, '2024-10-14 14:11:13');

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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `logs`
--
ALTER TABLE `logs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `orders`
--
ALTER TABLE `orders`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `order_items`
--
ALTER TABLE `order_items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `products`
--
ALTER TABLE `products`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=46;

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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=43;

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
