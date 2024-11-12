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

// Fetch users data
$usersQuery = "SELECT id, name, email, role FROM users ORDER BY id";
$usersResult = executeQuery($mysqli, $usersQuery);

$users = [];
while ($row = $usersResult->fetch_assoc()) {
    $users[] = $row;
}

// Prepare the response
$response = [
    'users' => $users
];

echo json_encode($response);

$mysqli->close();
?>