<?php
require_once 'db_connect.php';
$mysqli = db_connect();

// Enable error reporting for debugging
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

header('Content-Type: application/json');

// Function to execute query and handle errors
function executeQuery($mysqli, $query) {
    $result = $mysqli->query($query);
    if (!$result) {
        die(json_encode(['error' => 'Query failed: ' . $mysqli->error . ' SQL: ' . $query]));
    }
    return $result;
}

// Fetch inventory data
$inventoryQuery = "SELECT * FROM products ORDER BY id";
$inventoryResult = executeQuery($mysqli, $inventoryQuery);

$inventoryData = [];
$lowStockCount = 0;
$outOfStockCount = 0;
$totalValue = 0;

while ($row = $inventoryResult->fetch_assoc()) {
    $inventoryData[] = $row;
    
    // Calculate inventory status
    if ($row['quantity'] == 0) {
        $outOfStockCount++;
    } elseif ($row['quantity'] <= $row['reorder_level']) {
        $lowStockCount++;
    }
    
    // Calculate total inventory value
    $totalValue += $row['quantity'] * $row['purchase_price'];
}

// Prepare the response
$response = [
    'products' => $inventoryData,
    'inventoryStatus' => [
        'totalItems' => count($inventoryData),
        'lowStockCount' => $lowStockCount,
        'outOfStockCount' => $outOfStockCount,
        'totalValue' => $totalValue
    ]
];

echo json_encode($response);

$mysqli->close();
?>