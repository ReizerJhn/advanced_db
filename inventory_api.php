<?php
// Disable error reporting to prevent HTML output
error_reporting(0);
ini_set('display_errors', 0);

// Set the content type to JSON
header('Content-Type: application/json');

// Custom error handler to output JSON
function jsonError($message) {
    echo json_encode(['error' => $message]);
    exit;
}

// Set custom error and exception handlers
set_error_handler('jsonError');
set_exception_handler('jsonError');

// Near the top of the file, replace the database connection code with:
require_once 'db_connect.php';
$mysqli = db_connect();

// Get input
$action = $_POST['action'] ?? $_GET['action'] ?? '';

function sanitizeInput($input) {
    return htmlspecialchars(strip_tags($input));
}

switch ($action) {
    case 'add_item':
        try {
            $name = sanitizeInput($_POST['name']);
            $sku = sanitizeInput($_POST['sku']);
            $category = sanitizeInput($_POST['category']);
            $quantity = intval($_POST['quantity']);
            $unit = sanitizeInput($_POST['unit']);
            $purchase_price = floatval($_POST['purchase_price']);
            $selling_price = floatval($_POST['selling_price']);
            $supplier_id = !empty($_POST['supplier_id']) ? intval($_POST['supplier_id']) : null;
            $reorder_level = intval($_POST['reorder_level']);
            $description = sanitizeInput($_POST['description']);
            $brand = sanitizeInput($_POST['brand']);

            // Handle image upload
            $image = '';
            if (isset($_FILES['image']) && $_FILES['image']['error'] == 0) {
                $upload_dir = 'uploads/';
                if (!file_exists($upload_dir)) {
                    mkdir($upload_dir, 0777, true);
                }
                $file_name = uniqid() . '_' . $_FILES['image']['name'];
                $upload_path = $upload_dir . $file_name;
                
                if (move_uploaded_file($_FILES['image']['tmp_name'], $upload_path)) {
                    $image = $upload_path;
                } else {
                    throw new Exception('Failed to upload image');
                }
            }

            $stmt = $mysqli->prepare("INSERT INTO products (name, sku, category, quantity, unit, purchase_price, selling_price, supplier_id, reorder_level, image, description, brand) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");
            if (!$stmt) {
                throw new Exception('Prepare failed: ' . $mysqli->error);
            }
            $stmt->bind_param("sssissdissss", $name, $sku, $category, $quantity, $unit, $purchase_price, $selling_price, $supplier_id, $reorder_level, $image, $description, $brand);

            if ($stmt->execute()) {
                echo json_encode(['success' => true, 'message' => 'Item added successfully']);
            } else {
                if ($mysqli->errno == 1452) { // This is the error number for foreign key constraint failure
                    throw new Exception('Supplier does not exist. Please select a valid supplier.');
                } else {
                    throw new Exception('Failed to add item: ' . $stmt->error);
                }
            }
        } catch (Exception $e) {
            echo json_encode(['error' => $e->getMessage()]);
        }
        break;

    case 'get_item':
        $id = intval($_GET['id']);
        $stmt = $mysqli->prepare("SELECT * FROM products WHERE id = ?");
        if (!$stmt) {
            jsonError('Prepare failed: ' . $mysqli->error);
        }
        $stmt->bind_param("i", $id);
        $stmt->execute();
        $result = $stmt->get_result();
        $item = $result->fetch_assoc();

        if ($item) {
            echo json_encode($item);
        } else {
            jsonError('Item not found');
        }
        break;

    case 'update_item':
        try {
            $id = intval($_POST['id']);
            $name = sanitizeInput($_POST['name']);
            $sku = sanitizeInput($_POST['sku']);
            $category = sanitizeInput($_POST['category']);
            $quantity = intval($_POST['quantity']);
            $unit = sanitizeInput($_POST['unit']);
            $purchase_price = floatval($_POST['purchase_price']);
            $selling_price = floatval($_POST['selling_price']);
            $supplier_id = !empty($_POST['supplier_id']) ? intval($_POST['supplier_id']) : null;
            $reorder_level = intval($_POST['reorder_level']);
            $description = sanitizeInput($_POST['description']);
            $brand = sanitizeInput($_POST['brand']);

            // Handle image upload
            $image = $_POST['image'] ?? ''; // Keep the existing image if not updated
            if (isset($_FILES['image']) && $_FILES['image']['error'] == 0) {
                $upload_dir = 'uploads/';
                if (!file_exists($upload_dir)) {
                    mkdir($upload_dir, 0777, true);
                }
                $file_name = uniqid() . '_' . $_FILES['image']['name'];
                $upload_path = $upload_dir . $file_name;
                
                if (move_uploaded_file($_FILES['image']['tmp_name'], $upload_path)) {
                    $image = $upload_path;
                } else {
                    throw new Exception('Failed to upload image');
                }
            }

            $stmt = $mysqli->prepare("UPDATE products SET name = ?, sku = ?, category = ?, quantity = ?, unit = ?, purchase_price = ?, selling_price = ?, supplier_id = ?, reorder_level = ?, image = ?, description = ?, brand = ?, last_updated = CURRENT_TIMESTAMP WHERE id = ?");
            if (!$stmt) {
                throw new Exception("Prepare failed: " . $mysqli->error);
            }
            $stmt->bind_param("sssissdsisssi", $name, $sku, $category, $quantity, $unit, $purchase_price, $selling_price, $supplier_id, $reorder_level, $image, $description, $brand, $id);

            if ($stmt->execute()) {
                echo json_encode(['success' => true, 'message' => 'Item updated successfully']);
            } else {
                if ($mysqli->errno == 1452) { // This is the error number for foreign key constraint failure
                    throw new Exception('Supplier does not exist. Please select a valid supplier.');
                } else {
                    throw new Exception('Failed to update item: ' . $stmt->error);
                }
            }
        } catch (Exception $e) {
            echo json_encode(['error' => $e->getMessage()]);
        }
        break;

    case 'delete_item':
        $id = intval($_POST['id']);
        $stmt = $mysqli->prepare("DELETE FROM products WHERE id = ?");
        $stmt->bind_param("i", $id);

        if ($stmt->execute()) {
            if ($stmt->affected_rows > 0) {
                echo json_encode(['success' => true, 'message' => 'Item deleted successfully']);
            } else {
                echo json_encode(['error' => 'No item found with the given ID']);
            }
        } else {
            echo json_encode(['error' => 'Failed to delete item: ' . $stmt->error]);
        }
        break;

    case 'get_suppliers':
        $stmt = $mysqli->prepare("SELECT id, name FROM suppliers");
        $stmt->execute();
        $result = $stmt->get_result();
        $suppliers = $result->fetch_all(MYSQLI_ASSOC);
        echo json_encode($suppliers);
        break;

    case 'get_inventory':
        try {
            $stmt = $mysqli->prepare("
                SELECT p.*, s.name as supplier_name 
                FROM products p 
                LEFT JOIN suppliers s ON p.supplier_id = s.id
            ");
            $stmt->execute();
            $result = $stmt->get_result();
            $products = $result->fetch_all(MYSQLI_ASSOC);

            // Calculate inventory status
            $totalItems = count($products);
            $lowStockCount = 0;
            $outOfStockCount = 0;
            $totalValue = 0;

            foreach ($products as &$product) {
                $totalValue += $product['quantity'] * $product['purchase_price'];
                if ($product['quantity'] == 0) {
                    $outOfStockCount++;
                } elseif ($product['quantity'] <= $product['reorder_level']) {
                    $lowStockCount++;
                }
                
                // Convert numeric strings to appropriate types
                $product['id'] = intval($product['id']);
                $product['quantity'] = intval($product['quantity']);
                $product['purchase_price'] = floatval($product['purchase_price']);
                $product['selling_price'] = floatval($product['selling_price']);
                $product['reorder_level'] = intval($product['reorder_level']);
                $product['supplier_id'] = intval($product['supplier_id']);
            }

            $inventoryStatus = [
                'totalItems' => $totalItems,
                'lowStockCount' => $lowStockCount,
                'outOfStockCount' => $outOfStockCount,
                'totalValue' => $totalValue
            ];

            echo json_encode([
                'products' => $products,
                'inventoryStatus' => $inventoryStatus
            ]);
        } catch (Exception $e) {
            echo json_encode(['error' => $e->getMessage()]);
        }
        break;

    case 'adjust_stock':
        try {
            // Start the session if it's not already started
            if (session_status() == PHP_SESSION_NONE) {
                session_start();
            }

            // Check if the user is logged in
            if (!isset($_SESSION['user_id'])) {
                throw new Exception('User not logged in');
            }

            $item_id = intval($_POST['item_id']);
            $quantity = intval($_POST['quantity']);
            $type = $_POST['type'];
            $user_id = $_SESSION['user_id'];

            // Start transaction
            $mysqli->begin_transaction();

            // Fetch current quantity and prices
            $stmt = $mysqli->prepare("SELECT quantity, purchase_price, selling_price FROM products WHERE id = ?");
            $stmt->bind_param("i", $item_id);
            $stmt->execute();
            $result = $stmt->get_result();
            $product = $result->fetch_assoc();

            if (!$product) {
                throw new Exception('Product not found');
            }

            $current_quantity = $product['quantity'];
            $purchase_price = $product['purchase_price'];
            $selling_price = $product['selling_price'];

            // Calculate new quantity
            $new_quantity = ($type === 'in') ? $current_quantity + $quantity : $current_quantity - $quantity;

            if ($new_quantity < 0) {
                throw new Exception('Cannot remove more items than available in stock.');
            }

            // Update product quantity
            $stmt = $mysqli->prepare("UPDATE products SET quantity = ?, last_updated = CURRENT_TIMESTAMP WHERE id = ?");
            $stmt->bind_param("ii", $new_quantity, $item_id);
            $stmt->execute();

            // Log the inventory transaction
            $quantity_change = ($type === 'in') ? $quantity : -$quantity;
            $transaction_type = ($type === 'in') ? 'Purchase' : 'Sale';
            $stmt = $mysqli->prepare("INSERT INTO inventory_transactions (product_id, quantity_change, transaction_type, created_by) VALUES (?, ?, ?, ?)");
            $stmt->bind_param("iisi", $item_id, $quantity_change, $transaction_type, $user_id);
            $stmt->execute();

            // Commit transaction
            $mysqli->commit();

            echo json_encode(['success' => true, 'message' => 'Stock adjusted successfully']);
        } catch (Exception $e) {
            // Rollback transaction on error
            $mysqli->rollback();
            echo json_encode(['error' => $e->getMessage()]);
        }
        break;

    default:
        echo json_encode(['error' => 'Invalid action']);
}

$mysqli->close();
?>
