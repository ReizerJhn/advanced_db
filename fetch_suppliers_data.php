<?php
// At the beginning of the file
error_log('Starting fetch_suppliers_data.php');

// Disable error reporting for production
error_reporting(E_ALL);
ini_set('display_errors', 1);

// Start output buffering
ob_start();

// Database connection settings
require_once 'db_connect.php';

try {
    $db = new Database();
    $conn = $db->connect();

    // After database connection
    error_log('Database connected successfully');

    $action = $_REQUEST['action'] ?? 'fetch_all';

    switch ($action) {
        case 'fetch_all':
            // Fetch all suppliers
            $stmt = $conn->query('SELECT id, name AS supplier_name, name AS company_name, contact_name AS contact_person, email, phone AS phone_number, address, category, logo FROM suppliers');
            $suppliers = $stmt->fetchAll(PDO::FETCH_ASSOC);
            echo json_encode(['success' => true, 'suppliers' => $suppliers]);
            break;

        case 'get_supplier':
            // Get a single supplier
            $id = $_GET['id'] ?? null;
            if (!$id) {
                throw new Exception('Supplier ID is required');
            }
            $stmt = $conn->prepare('SELECT id, name AS supplier_name, name AS company_name, contact_name AS contact_person, email, phone AS phone_number, address, category, logo FROM suppliers WHERE id = ?');
            $stmt->execute([$id]);
            $supplier = $stmt->fetch(PDO::FETCH_ASSOC);
            if (!$supplier) {
                throw new Exception('Supplier not found');
            }
            echo json_encode(['success' => true, 'supplier' => $supplier]);
            break;

        case 'update_supplier':
            // Update a supplier
            $id = $_POST['id'] ?? null;
            if (!$id) {
                throw new Exception('Supplier ID is required');
            }
            $companyName = $_POST['company_name'] ?? '';
            $contactPerson = $_POST['contact_person'] ?? '';
            $phoneNumber = $_POST['phone_number'] ?? '';
            $email = $_POST['email'] ?? '';
            $address = $_POST['address'] ?? '';
            $category = $_POST['category'] ?? '';

            $sql = 'UPDATE suppliers SET name = ?, contact_name = ?, phone = ?, email = ?, address = ?, category = ?';
            $params = [$companyName, $contactPerson, $phoneNumber, $email, $address, $category];

            $logoPath = null;
            if (isset($_FILES['logo']) && $_FILES['logo']['error'] === UPLOAD_ERR_OK) {
                $uploadDir = 'uploads/';
                $fileExtension = pathinfo($_FILES['logo']['name'], PATHINFO_EXTENSION);
                $fileName = uniqid() . '.' . $fileExtension;
                $uploadFile = $uploadDir . $fileName;

                if (move_uploaded_file($_FILES['logo']['tmp_name'], $uploadFile)) {
                    $logoPath = $uploadFile;
                    $sql .= ', logo = ?';
                    $params[] = $logoPath;
                } else {
                    throw new Exception('Failed to upload logo');
                }
            }

            $sql .= ' WHERE id = ?';
            $params[] = $id;

            $stmt = $conn->prepare($sql);
            $result = $stmt->execute($params);
            
            if ($result) {
                echo json_encode(['success' => true, 'message' => 'Supplier updated successfully']);
            } else {
                throw new Exception('Failed to update supplier');
            }
            break;

        case 'delete_supplier':
            // Delete a supplier
            $id = $_POST['id'] ?? null;
            if (!$id) {
                throw new Exception('Supplier ID is required');
            }
            $stmt = $conn->prepare('DELETE FROM suppliers WHERE id = ?');
            $result = $stmt->execute([$id]);
            
            if ($result) {
                echo json_encode(['success' => true, 'message' => 'Supplier deleted successfully']);
            } else {
                throw new Exception('Failed to delete supplier');
            }
            break;

        default:
            throw new Exception('Invalid action');
    }
} catch (PDOException $e) {
    error_log('Database error in fetch_suppliers_data.php: ' . $e->getMessage());
    echo json_encode(['success' => false, 'error' => 'Database error: ' . $e->getMessage()]);
} catch (Exception $e) {
    error_log('General error in fetch_suppliers_data.php: ' . $e->getMessage());
    echo json_encode(['success' => false, 'error' => 'General error: ' . $e->getMessage()]);
}

// End output buffering and flush
ob_end_flush();
?>
