-- Create the new normalized database structure for MotorParts Inventory

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


-- Users table
CREATE TABLE `users` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `username` VARCHAR(50) NOT NULL UNIQUE,
  `password` VARCHAR(255) NOT NULL,
  `name` VARCHAR(100) NOT NULL,
  `email` VARCHAR(100) NOT NULL UNIQUE,
  `role` ENUM('Admin', 'Manager', 'Staff') NOT NULL,
  `profile_picture` VARCHAR(255) DEFAULT NULL,
  `last_login` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Suppliers table
CREATE TABLE `suppliers` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `name` VARCHAR(100) NOT NULL,
  `contact_name` VARCHAR(100) NOT NULL,
  `email` VARCHAR(100) NOT NULL,
  `phone` VARCHAR(20) NOT NULL,
  `address` TEXT NOT NULL,
  `category` VARCHAR(50) NOT NULL,
  `status` ENUM('Active', 'Inactive') NOT NULL,
  `rating` DECIMAL(3,2) NOT NULL,
  `payment_terms` VARCHAR(100) NOT NULL,
  `logo` VARCHAR(255) DEFAULT NULL
);

-- Products table
CREATE TABLE `products` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `name` VARCHAR(100) NOT NULL,
  `sku` VARCHAR(50) NOT NULL UNIQUE,
  `category` VARCHAR(50) NOT NULL,
  `quantity` INT NOT NULL,
  `unit` VARCHAR(20) NOT NULL,
  `purchase_price` DECIMAL(10,2) NOT NULL,
  `selling_price` DECIMAL(10,2) NOT NULL,
  `supplier_id` INT NOT NULL,
  `reorder_level` INT NOT NULL,
  `image` VARCHAR(255) DEFAULT NULL,
  `description` TEXT DEFAULT NULL,
  `brand` VARCHAR(50) NOT NULL,
  `date_added` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `last_updated` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (supplier_id) REFERENCES suppliers(id)
);

-- Inventory transactions table
CREATE TABLE `inventory_transactions` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `product_id` INT NOT NULL,
  `quantity_change` INT NOT NULL,
  `transaction_type` ENUM('Purchase', 'Sale', 'Adjustment') NOT NULL,
  `reference_id` INT DEFAULT NULL,
  `notes` TEXT DEFAULT NULL,
  `created_by` INT NOT NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (product_id) REFERENCES products(id),
  FOREIGN KEY (created_by) REFERENCES users(id)
);

-- Orders table
CREATE TABLE `orders` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `customer_name` VARCHAR(100) NOT NULL,
  `order_date` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `total_amount` DECIMAL(10,2) NOT NULL,
  `status` ENUM('Pending', 'Processing', 'Shipped', 'Delivered', 'Cancelled') NOT NULL
);

-- Order items table
CREATE TABLE `order_items` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `order_id` INT NOT NULL,
  `product_id` INT NOT NULL,
  `quantity` INT NOT NULL,
  `price` DECIMAL(10,2) NOT NULL,
  FOREIGN KEY (order_id) REFERENCES orders(id),
  FOREIGN KEY (product_id) REFERENCES products(id)
);

-- Reports table
CREATE TABLE `reports` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `report_name` VARCHAR(100) NOT NULL,
  `report_type` ENUM('Inventory', 'Sales', 'Orders', 'Custom') NOT NULL,
  `parameters` JSON DEFAULT NULL,
  `created_by` INT NOT NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (created_by) REFERENCES users(id)
);

-- Settings table
CREATE TABLE `settings` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `setting_key` VARCHAR(50) NOT NULL UNIQUE,
  `setting_value` TEXT DEFAULT NULL,
  `description` TEXT DEFAULT NULL
);

-- Logs table
CREATE TABLE `logs` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `user_id` INT NOT NULL,
  `action` VARCHAR(255) NOT NULL,
  `details` TEXT DEFAULT NULL,
  `timestamp` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id)
);

-- Views

-- View for inventory summary
CREATE VIEW `vw_inventory_summary` AS
SELECT 
  p.id,
  p.name,
  p.quantity AS in_stock,
  CASE WHEN p.quantity = 0 THEN 1 ELSE 0 END AS out_of_stock,
  p.reorder_level AS low_stock_threshold
FROM products p;

-- View for parts by type
CREATE VIEW `vw_parts_by_type` AS
SELECT 
  category AS type,
  COUNT(*) AS part_count,
  SUM(quantity) AS total_quantity
FROM products
GROUP BY category;

-- View for weekly order volume
CREATE VIEW `vw_weekly_order_volume` AS
SELECT 
  DATE(order_date) AS order_date,
  COUNT(*) AS order_count,
  SUM(total_amount) AS total_amount
FROM orders
WHERE order_date >= CURDATE() - INTERVAL 7 DAY
GROUP BY DATE(order_date)
ORDER BY DATE(order_date) ASC;

-- Insert sample data

-- Insert sample users
INSERT INTO users (username, password, name, email, role) VALUES
('admin', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Admin User', 'admin@example.com', 'Admin'),
('manager', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Manager User', 'manager@example.com', 'Manager'),
('staff', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Staff User', 'staff@example.com', 'Staff');

-- Insert sample suppliers
INSERT INTO suppliers (name, contact_name, email, phone, address, category, status, rating, payment_terms) VALUES
('AutoParts Inc.', 'John Doe', 'john@autoparts.com', '123-456-7890', '123 Main St, City, Country', 'Engine Parts', 'Active', 4.5, 'Net 30'),
('Brake Masters', 'Jane Smith', 'jane@brakemasters.com', '987-654-3210', '456 Elm St, Town, Country', 'Brake Systems', 'Active', 4.2, 'Net 15'),
('Electric Solutions', 'Bob Johnson', 'bob@electricsolutions.com', '555-123-4567', '789 Oak St, Village, Country', 'Electrical Components', 'Active', 4.0, 'Net 45');

-- Insert sample products
INSERT INTO products (name, sku, category, quantity, unit, purchase_price, selling_price, supplier_id, reorder_level, brand) VALUES
('Brake Pad Sets', 'BP-001', 'Brake Systems', 50, 'sets', 20.00, 40.00, 2, 10, 'BrakeMaster'),
('Alternator', 'ALT-001', 'Electrical', 30, 'piece', 80.00, 150.00, 3, 5, 'PowerGen'),
('Engine Oil Filter', 'EOF-001', 'Engine', 100, 'piece', 5.00, 15.00, 1, 20, 'FilterPro');

-- Insert sample orders
INSERT INTO orders (customer_name, total_amount, status) VALUES
('Alice Brown', 100.00, 'Delivered'),
('Charlie Davis', 200.00, 'Processing'),
('Eva Fisher', 75.00, 'Pending');

-- Insert sample order items
INSERT INTO order_items (order_id, product_id, quantity, price) VALUES
(1, 1, 2, 40.00),
(2, 2, 1, 150.00),
(3, 3, 5, 15.00);

-- Insert sample settings
INSERT INTO settings (setting_key, setting_value, description) VALUES
('company_name', 'MotorParts Inc.', 'Company name used in reports and invoices'),
('currency', 'USD', 'Default currency for pricing'),
('tax_rate', '10', 'Default tax rate in percentage'),
('low_stock_threshold', '5', 'Threshold for low stock alerts');

COMMIT;