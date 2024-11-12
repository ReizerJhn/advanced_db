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

    // Get the product_id filter if provided
    $product_id = isset($_GET['product_id']) ? intval($_GET['product_id']) : null;

    // Base query
    $query = "SELECT 
                  it.id, 
                  p.name AS product_name, 
                  it.quantity_change, 
                  it.transaction_type, 
                  it.created_at, 
                  COALESCE(u.name, 'System') AS created_by
              FROM inventory_transactions it
              JOIN products p ON it.product_id = p.id
              LEFT JOIN users u ON it.created_by = u.id";

    // Add product filter if provided
    if ($product_id) {
        $query .= " WHERE it.product_id = ?";
    }

    $query .= " ORDER BY it.created_at DESC LIMIT 100";

    $stmt = $mysqli->prepare($query);

    if ($product_id) {
        $stmt->bind_param("i", $product_id);
    }

    $stmt->execute();
    $result = $stmt->get_result();
    $logs = $result->fetch_all(MYSQLI_ASSOC);

    outputJSON(['success' => true, 'logs' => $logs]);

} catch(Exception $e) {
    outputJSON(['error' => 'Database error: ' . $e->getMessage()]);
}
?>
