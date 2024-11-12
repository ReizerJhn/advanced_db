<?php
error_reporting(E_ALL);
ini_set('display_errors', 1); // Enable error display for debugging

header('Content-Type: application/json');

// Include database connection
require_once 'db_connect.php';
require_once './vendor/autoload.php';
use Cloudinary\Cloudinary;
use Cloudinary\Api\Upload\UploadApi;
use Cloudinary\Configuration\Configuration;

$mysqli = db_connect();

// Check if the request is a POST request
if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    // Check if the content type is JSON
    $contentType = $_SERVER['CONTENT_TYPE'] ?? '';
    if (strpos($contentType, 'application/json') !== false) {
        // Decode JSON input
        $input = json_decode(file_get_contents('php://input'), true);
        $action = $input['action'] ?? '';
    } else {
        // Fallback to form data
        $action = $_POST['action'] ?? '';
    }

    // Debugging: Log the action received
    error_log("Action received: " . $action);

    function sanitizeInput($input) {
        return htmlspecialchars(strip_tags($input));
    }

    try {
        switch ($action) {
            case 'add_user_with_picture':
                $name = sanitizeInput($_POST['name']);
                $email = sanitizeInput($_POST['email']);
                $role = sanitizeInput($_POST['role']);
                $username = sanitizeInput($_POST['username']);
                $password = password_hash('default_password', PASSWORD_DEFAULT); // Set a default password

                // Debugging: Log the input values
                error_log("Adding user with username: $username, email: $email");

                // Check if username or email already exists
                $stmt = $mysqli->prepare("SELECT COUNT(*) FROM users WHERE username = ? OR email = ?");
                $stmt->bind_param("ss", $username, $email);
                $stmt->execute();
                $stmt->bind_result($count);
                $stmt->fetch();
                $stmt->close();

                if ($count > 0) {
                    echo json_encode(['error' => 'Username or email already exists. Please use a different one.']);
                    exit;
                }

                // Initialize Cloudinary configuration
                Configuration::instance([
                    'cloud' => [
                        'cloud_name' => 'ddujkyfzj',
                        'api_key' => '897774582825532',
                        'api_secret' => 'DC5Y_PbDb6Dvv2hAgHvXGB1STnE',
                    ],
                    'url' => [
                        'secure' => true
                    ]
                ]);

                $imageUrl = null;
                if (isset($_FILES['profile_picture'])) {
                    $uploadedFile = $_FILES['profile_picture']['tmp_name'];

                    try {
                        $uploadResult = (new UploadApi())->upload($uploadedFile, [
                            'folder' => 'profile_pics',
                            'public_id' => 'user_' . uniqid(),
                        ]);

                        $imageUrl = $uploadResult['secure_url'];
                    } catch (Exception $e) {
                        echo json_encode(['error' => 'Upload failed: ' . $e->getMessage()]);
                        exit;
                    }
                }

                $stmt = $mysqli->prepare("INSERT INTO users (name, email, role, username, password, profile_picture) VALUES (?, ?, ?, ?, ?, ?)");
                $stmt->bind_param("ssssss", $name, $email, $role, $username, $password, $imageUrl);

                if ($stmt->execute()) {
                    echo json_encode(['success' => true, 'message' => 'User added successfully']);
                } else {
                    echo json_encode(['error' => 'Failed to add user: ' . $stmt->error]);
                }
                break;

            case 'upload_profile_picture':
                if (isset($_FILES['profile_picture'])) {
                    $userId = intval($_POST['id']);
                    
                    Configuration::instance([
                        'cloud' => [
                            'cloud_name' => 'ddujkyfzj',
                            'api_key' => '897774582825532',
                            'api_secret' => 'DC5Y_PbDb6Dvv2hAgHvXGB1STnE',
                        ],
                        'url' => [
                            'secure' => true
                        ]
                    ]);

                    $uploadedFile = $_FILES['profile_picture']['tmp_name'];

                    try {
                        $uploadResult = (new UploadApi())->upload($uploadedFile, [
                            'folder' => 'profile_pics',
                            'public_id' => 'user_' . uniqid(),
                        ]);

                        $imageUrl = $uploadResult['secure_url'];

                        $stmt = $mysqli->prepare("UPDATE users SET profile_picture = ? WHERE id = ?");
                        $stmt->bind_param("si", $imageUrl, $userId);

                        if ($stmt->execute()) {
                            echo json_encode(['success' => true, 'message' => 'Profile picture updated successfully']);
                        } else {
                            echo json_encode(['error' => 'Failed to update profile picture: ' . $stmt->error]);
                        }

                    } catch (Exception $e) {
                        echo json_encode(['error' => 'Upload failed: ' . $e->getMessage()]);
                    }
                } else {
                    echo json_encode(['error' => 'No file uploaded']);
                }
                break;

            case 'get_user':
                $id = intval($_GET['id'] ?? 0); // Ensure the ID is retrieved correctly
                if ($id > 0) {
                    $stmt = $mysqli->prepare("SELECT id, name, email, role FROM users WHERE id = ?");
                    $stmt->bind_param("i", $id);
                    $stmt->execute();
                    $result = $stmt->get_result();
                    $user = $result->fetch_assoc();

                    if ($user) {
                        echo json_encode($user);
                    } else {
                        echo json_encode(['error' => 'User not found']);
                    }
                } else {
                    echo json_encode(['error' => 'Invalid user ID']);
                }
                break;

            case 'update_user':
                $id = intval($input['id']);
                $name = sanitizeInput($input['name']);
                $email = sanitizeInput($input['email']);
                $role = sanitizeInput($input['role']);

                $stmt = $mysqli->prepare("UPDATE users SET name = ?, email = ?, role = ? WHERE id = ?");
                $stmt->bind_param("sssi", $name, $email, $role, $id);

                if ($stmt->execute()) {
                    echo json_encode(['success' => true, 'message' => 'User updated successfully']);
                } else {
                    echo json_encode(['error' => 'Failed to update user: ' . $stmt->error]);
                }
                break;

            case 'delete_user':
                $id = intval($input['id']);
                $stmt = $mysqli->prepare("DELETE FROM users WHERE id = ?");
                $stmt->bind_param("i", $id);

                if ($stmt->execute()) {
                    echo json_encode(['success' => true, 'message' => 'User deleted successfully']);
                } else {
                    echo json_encode(['error' => 'Failed to delete user: ' . $stmt->error]);
                }
                break;

            case 'reset_password':
                $id = intval($input['id']);
                $new_password = bin2hex(random_bytes(8)); // Generate a random password
                $hashed_password = password_hash($new_password, PASSWORD_DEFAULT);

                $stmt = $mysqli->prepare("UPDATE users SET password = ? WHERE id = ?");
                $stmt->bind_param("si", $hashed_password, $id);

                if ($stmt->execute()) {
                    echo json_encode(['success' => true, 'message' => 'Password reset successfully', 'new_password' => $new_password]);
                } else {
                    echo json_encode(['error' => 'Failed to reset password: ' . $stmt->error]);
                }
                break;

            default:
                echo json_encode(['error' => 'Invalid action']);
                // Debugging: Log invalid action
                error_log("Invalid action: " . $action);
        }
    } catch (Exception $e) {
        echo json_encode(['error' => 'An unexpected error occurred: ' . $e->getMessage()]);
    }
}

// Check if the request is a GET request for get_user
if ($_SERVER['REQUEST_METHOD'] == 'GET' && isset($_GET['action']) && $_GET['action'] == 'get_user') {
    $id = intval($_GET['id'] ?? 0); // Ensure the ID is retrieved correctly
    if ($id > 0) {
        $stmt = $mysqli->prepare("SELECT id, name, email, role FROM users WHERE id = ?");
        $stmt->bind_param("i", $id);
        $stmt->execute();
        $result = $stmt->get_result();
        $user = $result->fetch_assoc();

        if ($user) {
            echo json_encode($user);
        } else {
            echo json_encode(['error' => 'User not found']);
        }
    } else {
        echo json_encode(['error' => 'Invalid user ID']);
    }
    exit;
}

$mysqli->close();
?>
