<?php
// Enable error reporting for debugging
error_reporting(E_ALL);
ini_set('display_errors', 1);

// Set the content type to JSON
header('Content-Type: application/json');

function outputJSON($data) {
    echo json_encode($data);
    exit;
}

require_once 'db_connect.php';

try {
    $mysqli = db_connect();

    // Fetch inventory data
    $inventoryQuery = "SELECT 
                           category as month, 
                           SUM(quantity) as in_stock,
                           COUNT(CASE WHEN quantity = 0 THEN 1 END) as out_of_stock
                       FROM products
                       GROUP BY category
                       ORDER BY category
                       LIMIT 12";
    $inventoryResult = $mysqli->query($inventoryQuery);
    $inventoryData = $inventoryResult->fetch_all(MYSQLI_ASSOC);

    // Fetch sales data (using orders as a proxy for sales)
    $salesQuery = "SELECT 
                       DATE_FORMAT(order_date, '%Y-%m') as month, 
                       SUM(total_amount) as revenue
                   FROM orders
                   GROUP BY DATE_FORMAT(order_date, '%Y-%m')
                   ORDER BY month DESC
                   LIMIT 12";
    $salesResult = $mysqli->query($salesQuery);
    $salesData = $salesResult->fetch_all(MYSQLI_ASSOC);

    // Fetch order data
    $orderQuery = "SELECT status, COUNT(*) as count
                   FROM orders
                   GROUP BY status";
    $orderResult = $mysqli->query($orderQuery);
    $orderData = $orderResult->fetch_all(MYSQLI_ASSOC);

    // Update the top selling products query
    $topSellingQuery = "SELECT p.name, SUM(oi.quantity) as total_sold
                        FROM order_items oi
                        JOIN products p ON oi.product_id = p.id
                        JOIN orders o ON oi.order_id = o.id
                        WHERE o.order_date >= DATE_SUB(CURRENT_DATE, INTERVAL 30 DAY)
                        GROUP BY oi.product_id
                        ORDER BY total_sold DESC
                        LIMIT 5";
    $topSellingResult = $mysqli->query($topSellingQuery);
    $topSellingData = $topSellingResult->fetch_all(MYSQLI_ASSOC);

    // Fetch low stock items
    $lowStockQuery = "SELECT name, quantity, reorder_level
                      FROM products
                      WHERE quantity <= reorder_level
                      ORDER BY quantity ASC
                      LIMIT 10";
    $lowStockResult = $mysqli->query($lowStockQuery);
    $lowStockData = $lowStockResult->fetch_all(MYSQLI_ASSOC);

    $result = [
        'inventoryData' => $inventoryData,
        'salesData' => $salesData,
        'orderData' => $orderData,
        'topSellingProducts' => $topSellingData,
        'lowStockItems' => $lowStockData
    ];

    outputJSON(['success' => true, 'data' => $result]);

} catch(Exception $e) {
    outputJSON(['error' => 'Database error: ' . $e->getMessage()]);
}
?>
