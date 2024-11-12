-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Oct 04, 2024 at 06:52 PM
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
-- Database: `motorparts_inventory`
--

-- --------------------------------------------------------

--
-- Table structure for table `inventory`
--

CREATE TABLE `inventory` (
  `id` int(11) NOT NULL,
  `item_name` varchar(255) NOT NULL,
  `quantity` int(11) NOT NULL,
  `date` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `inventory`
--

INSERT INTO `inventory` (`id`, `item_name`, `quantity`, `date`) VALUES
(1, 'Engine Oil', 100, '2023-05-01'),
(2, 'Brake Pads', 50, '2023-05-02'),
(3, 'Air Filter', 75, '2023-05-03'),
(4, 'Spark Plugs', 200, '2023-05-04'),
(5, 'Transmission Fluid', 80, '2023-05-05'),
(6, 'Engine Oil', 100, '2023-05-01'),
(7, 'Brake Pads', 50, '2023-05-02'),
(8, 'Air Filter', 75, '2023-05-03'),
(9, 'Spark Plugs', 200, '2023-05-04'),
(10, 'Transmission Fluid', 80, '2023-05-05');

-- --------------------------------------------------------

--
-- Table structure for table `inventory_summary`
--

CREATE TABLE `inventory_summary` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `in_stock` int(11) NOT NULL,
  `out_of_stock` int(11) NOT NULL,
  `low_stock_threshold` int(11) NOT NULL DEFAULT 10
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `inventory_summary`
--

INSERT INTO `inventory_summary` (`id`, `name`, `in_stock`, `out_of_stock`, `low_stock_threshold`) VALUES
(1, 'Engine Parts', 150, 20, 10),
(2, 'Brake Systems', 200, 15, 10),
(3, 'Suspension', 100, 10, 10),
(4, 'Electrical', 180, 25, 10),
(5, 'Body Parts', 120, 30, 10),
(6, 'Brake Pads', 5, 0, 10),
(7, 'Oil Filters', 0, 10, 10),
(8, 'Spark Plugs', 15, 0, 10),
(9, 'Alternators', 3, 0, 10),
(10, 'Batteries', 8, 2, 10),
(11, 'Brake Pads', 5, 0, 10),
(12, 'Oil Filters', 0, 10, 10),
(13, 'Spark Plugs', 15, 0, 10),
(14, 'Alternators', 3, 0, 10),
(15, 'Batteries', 8, 2, 10);

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
(2, 2, -1, 'Sale', 1, 'Sale of 1 brake pad set', 3, '2024-09-16 04:40:38'),
(3, 3, -1, 'Sale', 2, 'Sale of 1 alternator', 3, '2024-09-16 04:40:38');

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

--
-- Dumping data for table `logs`
--

INSERT INTO `logs` (`id`, `user_id`, `action`, `details`, `timestamp`) VALUES
(1, 1, 'User Login', 'Admin user logged in', '2024-09-16 04:40:38'),
(2, 2, 'Product Added', 'Added new product: Spark Plug (SKU: SP-001)', '2024-09-16 04:40:38'),
(3, 3, 'Order Updated', 'Updated order status for Order #2 to Processing', '2024-09-16 04:40:38');

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
(1, 'Alice Brown', '2024-09-16 04:40:38', 100.00, 'Delivered'),
(2, 'Charlie Davis', '2024-09-16 04:40:38', 200.00, 'Processing'),
(3, 'Eva Fisher', '2024-09-16 04:40:38', 75.00, 'Pending'),
(4, 'John Doe', '2024-09-18 16:00:00', 150.00, 'Delivered'),
(5, 'Jane Smith', '2024-09-19 16:00:00', 89.99, 'Shipped'),
(6, 'Bob Johnson', '2024-09-20 16:00:00', 45.99, 'Processing'),
(7, 'Alice Brown', '2024-09-21 16:00:00', 129.99, 'Pending'),
(8, 'Charlie Davis', '2024-09-22 16:00:00', 75.98, 'Processing'),
(9, 'Eva Fisher', '2024-09-23 16:00:00', 199.98, 'Pending'),
(10, 'George Harris', '2024-09-24 16:00:00', 59.97, 'Pending'),
(11, 'John Doe', '2024-09-18 16:00:00', 150.00, 'Delivered'),
(12, 'Jane Smith', '2024-09-19 16:00:00', 89.99, 'Shipped'),
(13, 'Bob Johnson', '2024-09-20 16:00:00', 45.99, 'Processing'),
(14, 'Alice Brown', '2024-09-21 16:00:00', 129.99, 'Pending'),
(15, 'Charlie Davis', '2024-09-22 16:00:00', 75.98, 'Processing'),
(16, 'Eva Fisher', '2024-09-23 16:00:00', 199.98, 'Pending'),
(17, 'George Harris', '2024-09-24 16:00:00', 59.97, 'Pending');

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
(2, 1, 2, 1, 40.00),
(3, 2, 3, 1, 150.00),
(5, 3, 2, 1, 40.00);

-- --------------------------------------------------------

--
-- Table structure for table `parts`
--

CREATE TABLE `parts` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `type` varchar(100) NOT NULL,
  `quantity` int(11) NOT NULL,
  `price` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `parts`
--

INSERT INTO `parts` (`id`, `name`, `type`, `quantity`, `price`) VALUES
(1, 'Spark Plug', 'Engine', 100, 15.99),
(2, 'Brake Pad', 'Brake', 80, 45.50),
(3, 'Shock Absorber', 'Suspension', 50, 89.99),
(4, 'Alternator', 'Electrical', 30, 120.00),
(5, 'Headlight', 'Body', 60, 75.00),
(6, 'Oil Filter', 'Engine', 120, 9.99),
(7, 'Brake Rotor', 'Brake', 40, 65.00),
(8, 'Coil Spring', 'Suspension', 35, 55.00),
(9, 'Battery', 'Electrical', 45, 99.99),
(10, 'Side Mirror', 'Body', 25, 40.00),
(11, 'Front Brake Pad', 'Brake System', 20, 45.99),
(12, 'Rear Brake Pad', 'Brake System', 15, 39.99),
(13, 'Oil Filter A', 'Engine', 30, 12.99),
(14, 'Oil Filter B', 'Engine', 25, 14.99),
(15, 'Spark Plug Standard', 'Ignition', 50, 5.99),
(16, 'Spark Plug Premium', 'Ignition', 40, 8.99),
(17, 'Alternator 90A', 'Electrical', 10, 129.99),
(18, 'Alternator 120A', 'Electrical', 8, 159.99),
(19, 'Battery 60Ah', 'Electrical', 12, 89.99),
(20, 'Battery 75Ah', 'Electrical', 10, 109.99),
(21, 'Front Brake Pad', 'Brake System', 20, 45.99),
(22, 'Rear Brake Pad', 'Brake System', 15, 39.99),
(23, 'Oil Filter A', 'Engine', 30, 12.99),
(24, 'Oil Filter B', 'Engine', 25, 14.99),
(25, 'Spark Plug Standard', 'Ignition', 50, 5.99),
(26, 'Spark Plug Premium', 'Ignition', 40, 8.99),
(27, 'Alternator 90A', 'Electrical', 10, 129.99),
(28, 'Alternator 120A', 'Electrical', 8, 159.99),
(29, 'Battery 60Ah', 'Electrical', 12, 89.99),
(30, 'Battery 75Ah', 'Electrical', 10, 109.99);

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
(2, 'Brake Pad Sets', 'BP-001', 'Brake Systems', 3, 'sets', 20.00, 40.00, 2, 10, 'brake_pads.jpg', 'Durable brake pad set for improved stopping power', 'BrakeMaster', '2024-09-16 04:40:38', '2024-09-27 04:31:12'),
(3, 'Alternator', 'ALT-001', 'Electrical', 30, 'piece', 80.00, 150.00, 3, 5, 'alternator.jpg', 'Reliable alternator for consistent electrical power', 'PowerGen', '2024-09-16 04:40:38', '2024-09-16 04:40:38');

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

--
-- Dumping data for table `reports`
--

INSERT INTO `reports` (`id`, `report_name`, `report_type`, `parameters`, `created_by`, `created_at`) VALUES
(2, 'Low Stock Items', 'Inventory', '{\"threshold\": 10}', 2, '2024-09-16 04:40:38'),
(3, 'Top Selling Products', 'Custom', '{\"time_period\": \"last_30_days\", \"limit\": 10}', 1, '2024-09-16 04:40:38'),
(1002, 'Monthly Sales Report', 'Sales', '{\"start_date\": \"2023-05-01\", \"end_date\": \"2023-05-31\"}', 1, '2024-09-16 04:40:38');

-- --------------------------------------------------------

--
-- Table structure for table `sales`
--

CREATE TABLE `sales` (
  `id` int(11) NOT NULL,
  `total_amount` decimal(10,2) NOT NULL,
  `date` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `sales`
--

INSERT INTO `sales` (`id`, `total_amount`, `date`) VALUES
(1, 1500.00, '2023-05-01'),
(2, 2000.00, '2023-05-02'),
(3, 1800.00, '2023-05-03'),
(4, 2200.00, '2023-05-04'),
(5, 1900.00, '2023-05-05'),
(6, 1500.00, '2023-05-01'),
(7, 2000.00, '2023-05-02'),
(8, 1800.00, '2023-05-03'),
(9, 2200.00, '2023-05-04'),
(10, 1900.00, '2023-05-05');

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
  `profile_picture` varchar(255) DEFAULT NULL,
  `last_login` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `username`, `password`, `name`, `email`, `role`, `profile_picture`, `last_login`) VALUES
(1, 'admin', '$2y$10$ae7n0sgkhl03PCyEx/N/DOUDvQ5qDPUR5COnsX2uW0HloX9iNa.Ki', 'Admin User', 'admin@example.com', 'Manager', NULL, '2024-09-27 01:29:54'),
(2, 'manager', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Manager User', 'manager@example.com', 'Manager', NULL, '2024-09-16 04:40:38'),
(3, 'staff', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Staff User', 'staff@example.com', 'Staff', NULL, '2024-09-16 04:40:38');

-- --------------------------------------------------------

--
-- Stand-in structure for view `vw_parts_by_type`
-- (See below for the actual view)
--
CREATE TABLE `vw_parts_by_type` (
`type` varchar(100)
,`part_count` bigint(21)
,`total_quantity` decimal(32,0)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `vw_stock_alerts`
-- (See below for the actual view)
--
CREATE TABLE `vw_stock_alerts` (
`name` varchar(255)
,`in_stock` int(11)
,`low_stock_threshold` int(11)
,`stock_status` varchar(12)
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
-- Structure for view `vw_parts_by_type`
--
DROP TABLE IF EXISTS `vw_parts_by_type`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_parts_by_type`  AS SELECT `parts`.`type` AS `type`, count(0) AS `part_count`, sum(`parts`.`quantity`) AS `total_quantity` FROM `parts` GROUP BY `parts`.`type` ;

-- --------------------------------------------------------

--
-- Structure for view `vw_stock_alerts`
--
DROP TABLE IF EXISTS `vw_stock_alerts`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_stock_alerts`  AS SELECT `inventory_summary`.`name` AS `name`, `inventory_summary`.`in_stock` AS `in_stock`, `inventory_summary`.`low_stock_threshold` AS `low_stock_threshold`, CASE WHEN `inventory_summary`.`in_stock` = 0 THEN 'Out of Stock' WHEN `inventory_summary`.`in_stock` < `inventory_summary`.`low_stock_threshold` THEN 'Low Stock' ELSE 'Normal' END AS `stock_status` FROM `inventory_summary` WHERE `inventory_summary`.`in_stock` = 0 OR `inventory_summary`.`in_stock` < `inventory_summary`.`low_stock_threshold` ;

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
-- Indexes for table `inventory`
--
ALTER TABLE `inventory`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `inventory_summary`
--
ALTER TABLE `inventory_summary`
  ADD PRIMARY KEY (`id`);

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
-- Indexes for table `parts`
--
ALTER TABLE `parts`
  ADD PRIMARY KEY (`id`);

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
-- Indexes for table `sales`
--
ALTER TABLE `sales`
  ADD PRIMARY KEY (`id`);

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
-- AUTO_INCREMENT for table `inventory`
--
ALTER TABLE `inventory`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `inventory_summary`
--
ALTER TABLE `inventory_summary`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `inventory_transactions`
--
ALTER TABLE `inventory_transactions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `logs`
--
ALTER TABLE `logs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `orders`
--
ALTER TABLE `orders`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT for table `order_items`
--
ALTER TABLE `order_items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=28;

--
-- AUTO_INCREMENT for table `parts`
--
ALTER TABLE `parts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=31;

--
-- AUTO_INCREMENT for table `products`
--
ALTER TABLE `products`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `reports`
--
ALTER TABLE `reports`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1004;

--
-- AUTO_INCREMENT for table `sales`
--
ALTER TABLE `sales`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

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
