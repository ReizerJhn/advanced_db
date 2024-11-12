<?php
// Disable error reporting for production
error_reporting(0);
ini_set('display_errors', 0);

// Set the content type to JSON
header('Content-Type: application/json');

// Function to handle errors and output JSON
function outputError($message) {
    echo json_encode(['error' => $message]);
    exit;
}

// Database connection
require_once 'db_connect.php';
$mysqli = db_connect();

// Function to execute query and handle errors
function executeQuery($mysqli, $query) {
    $result = $mysqli->query($query);
    if (!$result) {
        outputError('Query failed: ' . $mysqli->error . ' SQL: ' . $query);
    }
    return $result;
}

try {
    // Fetch inventory data
    $inventoryQuery = "SELECT * FROM vw_inventory_summary ORDER BY id";
    $inventoryResult = executeQuery($mysqli, $inventoryQuery);

    $inventoryData = [];
    $lowStockCount = 0;
    $outOfStockCount = 0;
    $totalValue = 0;

    while ($row = $inventoryResult->fetch_assoc()) {
        $inventoryData[] = $row;
        
        // Calculate inventory status
        if ($row['in_stock'] == 0) {
            $outOfStockCount++;
        } elseif ($row['in_stock'] <= $row['low_stock_threshold']) {
            $lowStockCount++;
        }
    }

    // Calculate total inventory value
    $totalValueQuery = "SELECT SUM(quantity * purchase_price) AS total_value FROM products";
    $totalValueResult = executeQuery($mysqli, $totalValueQuery);
    $totalValueRow = $totalValueResult->fetch_assoc();
    $totalValue = $totalValueRow['total_value'] ?? 0;

    // Fetch part type data
    $partTypeQuery = "SELECT * FROM vw_parts_by_type";
    $partTypeResult = executeQuery($mysqli, $partTypeQuery);

    $partTypeData = [];
    while ($row = $partTypeResult->fetch_assoc()) {
        $partTypeData[] = $row;
    }

    // Fetch weekly order volume data
    $weeklyOrderVolume = [];
    $orderVolumeQuery = "
        SELECT 
            DATE(order_date) as order_date,
            COUNT(*) as order_count,
            SUM(total_amount) as total_amount
        FROM orders
        WHERE order_date >= DATE_SUB(CURDATE(), INTERVAL 7 DAY)
        GROUP BY DATE(order_date)
        ORDER BY order_date ASC
    ";

    $orderVolumeResult = executeQuery($mysqli, $orderVolumeQuery);

    if ($orderVolumeResult) {
        while ($row = $orderVolumeResult->fetch_assoc()) {
            $weeklyOrderVolume[] = [
                'order_date' => $row['order_date'],
                'order_count' => $row['order_count'],
                'total_amount' => $row['total_amount']
            ];
        }
    } else {
        $weeklyOrderVolume['debug_info'] = $mysqli->error;
    }

    // Fetch recent orders
    $recentOrdersQuery = "SELECT id, customer_name AS customer, total_amount AS total FROM orders ORDER BY order_date DESC LIMIT 5";
    $recentOrdersResult = executeQuery($mysqli, $recentOrdersQuery);

    $recentOrders = [];
    while ($row = $recentOrdersResult->fetch_assoc()) {
        $recentOrders[] = $row;
    }

    // Prepare the response
    $response = [
        'inventoryData' => $inventoryData,
        'partTypeData' => $partTypeData,
        'weeklyOrderVolume' => $weeklyOrderVolume,
        'recentOrders' => $recentOrders,
        'inventoryStatus' => [
            'totalItems' => count($inventoryData),
            'lowStockCount' => $lowStockCount,
            'outOfStockCount' => $outOfStockCount,
            'totalValue' => floatval($totalValue)
        ]
    ];

    echo json_encode($response);
} catch (Exception $e) {
    outputError('An unexpected error occurred: ' . $e->getMessage());
} finally {
    $mysqli->close();
}
?>
