<?php
require_once 'db_connect.php';

try {
    $pdo = new PDO("mysql:host=$host;dbname=$dbname", $username, $password);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

    // Create inventory table
    $pdo->exec("CREATE TABLE IF NOT EXISTS inventory (
        id INT AUTO_INCREMENT PRIMARY KEY,
        item_name VARCHAR(255) NOT NULL,
        quantity INT NOT NULL,
        date DATE NOT NULL
    )");

    // Create sales table
    $pdo->exec("CREATE TABLE IF NOT EXISTS sales (
        id INT AUTO_INCREMENT PRIMARY KEY,
        total_amount DECIMAL(10, 2) NOT NULL,
        date DATE NOT NULL
    )");

    // Create orders table
    $pdo->exec("CREATE TABLE IF NOT EXISTS orders (
        id INT AUTO_INCREMENT PRIMARY KEY,
        status VARCHAR(50) NOT NULL,
        date DATE NOT NULL
    )");

    // Insert sample data into inventory
    $pdo->exec("INSERT INTO inventory (item_name, quantity, date) VALUES
        ('Engine Oil', 100, '2023-05-01'),
        ('Brake Pads', 50, '2023-05-02'),
        ('Air Filter', 75, '2023-05-03'),
        ('Spark Plugs', 200, '2023-05-04'),
        ('Transmission Fluid', 80, '2023-05-05')
    ");

    // Insert sample data into sales
    $pdo->exec("INSERT INTO sales (total_amount, date) VALUES
        (1500.00, '2023-05-01'),
        (2000.00, '2023-05-02'),
        (1800.00, '2023-05-03'),
        (2200.00, '2023-05-04'),
        (1900.00, '2023-05-05')
    ");

    // Insert sample data into orders
    $pdo->exec("INSERT INTO orders (status, date) VALUES
        ('Pending', '2023-05-01'),
        ('Shipped', '2023-05-02'),
        ('Delivered', '2023-05-03'),
        ('Pending', '2023-05-04'),
        ('Shipped', '2023-05-05')
    ");

    echo "Tables created and sample data inserted successfully.";
} catch(PDOException $e) {
    echo "Error: " . $e->getMessage();
}
?>