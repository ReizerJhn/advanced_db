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

    $query = "SELECT id, name FROM products ORDER BY name";
    $result = $mysqli->query($query);
    $products = $result->fetch_all(MYSQLI_ASSOC);

    outputJSON(['success' => true, 'products' => $products]);

} catch(Exception $e) {
    outputJSON(['error' => 'Database error: ' . $e->getMessage()]);
}
?>
