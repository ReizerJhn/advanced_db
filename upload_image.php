<?php

// Disable error reporting for production
error_reporting(0);
ini_set('display_errors', 0);

// Start output buffering
ob_start();

header('Content-Type: application/json');

// Database connection
require_once 'db_connect.php';

try {
    $db = new Database();
    $conn = $db->connect();

    // Check if the request method is POST
    if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
        throw new Exception('Invalid request method');
    }

    // Check if all required fields are present
    $requiredFields = ['company_name', 'contact_name', 'email', 'phone', 'address', 'category'];
    foreach ($requiredFields as $field) {
        if (!isset($_POST[$field]) || empty($_POST[$field])) {
            throw new Exception("Missing required field: $field");
        }
    }

    // Handle file upload
    $uploadDir = 'uploads/';
    $logoPath = null;

    if (isset($_FILES['logo']) && $_FILES['logo']['error'] === UPLOAD_ERR_OK) {
        $tempName = $_FILES['logo']['tmp_name'];
        $fileName = basename($_FILES['logo']['name']);
        $targetPath = $uploadDir . uniqid() . '_' . $fileName;

        if (move_uploaded_file($tempName, $targetPath)) {
            $logoPath = $targetPath;
        } else {
            throw new Exception('Failed to move uploaded file');
        }
    }

    // Insert new supplier into the database
    $stmt = $conn->prepare("INSERT INTO suppliers (name, contact_name, email, phone, address, category, logo) VALUES (?, ?, ?, ?, ?, ?, ?)");
    $stmt->execute([
        $_POST['company_name'],
        $_POST['contact_name'],
        $_POST['email'],
        $_POST['phone'],
        $_POST['address'],
        $_POST['category'],
        $logoPath
    ]);

    // Clear the output buffer and send success response
    ob_clean();
    echo json_encode(['success' => true, 'message' => 'Supplier added successfully']);

} catch (Exception $e) {
    // Clear the output buffer and send error response
    ob_clean();
    echo json_encode(['success' => false, 'error' => $e->getMessage()]);
}

// End output buffering and flush
ob_end_flush();
