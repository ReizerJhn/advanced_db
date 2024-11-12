<?php
session_start();
require_once 'db_connect.php';

$error = '';
$email_error = '';
$password_error = '';

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $email = filter_input(INPUT_POST, 'email', FILTER_SANITIZE_EMAIL);
    $password = $_POST['password'];

    if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
        $email_error = "Invalid email format";
    }

    if (empty($password)) {
        $password_error = "Password is required";
    }

    if (empty($email_error) && empty($password_error)) {
        try {
            $stmt = $pdo->prepare("SELECT id, email, password, role FROM users WHERE email = :email");
            $stmt->bindParam(':email', $email, PDO::PARAM_STR);
            $stmt->execute();

            if ($user = $stmt->fetch(PDO::FETCH_ASSOC)) {
                if (password_verify($password, $user['password'])) {
                    $_SESSION['user_id'] = $user['id'];
                    $_SESSION['email'] = $user['email'];
                    $_SESSION['role'] = $user['role'];
                    
                    // Set user role in session storage
                    echo "<script>
                        sessionStorage.setItem('userRole', '{$user['role']}');
                        window.location.href = 'dashboard.html';
                    </script>";
                    exit();
                } else {
                    $error = "Wrong credentials";
                }
            } else {
                $error = "Wrong credentials";
            }
        } catch (PDOException $e) {
            error_log("Login error: " . $e->getMessage());
            $error = "An error occurred. Please try again later.";
        }
    }
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ERM Motors Login</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
</head>
<body class="h-screen">
    <div class="flex h-full">
        <div class="w-full md:w-1/2 flex flex-col bg-white">
            <div class="flex-grow flex items-center justify-center px-8 pb-8">
                <div class="w-full max-w-md">
                    <div class="text-center mb-8">
                        <img src="logo.png" alt="ERM Motors Logo" class="w-60 h-auto mx-auto">
                    </div>
                    <form id="loginForm" method="POST" action="<?php echo htmlspecialchars($_SERVER["PHP_SELF"]); ?>" class="space-y-6" autocomplete="on">
                        <div>
                            <label for="email" class="block text-sm font-medium text-gray-700">Email</label>
                            <input
                                id="email"
                                name="email"
                                type="email"
                                placeholder="Enter your email"
                                value="<?php echo htmlspecialchars($email ?? ''); ?>"
                                class="mt-1 w-full px-3 py-2 border border-gray-300 rounded-md text-sm shadow-sm placeholder-gray-400
                                       focus:outline-none focus:border-pink-500 focus:ring-1 focus:ring-pink-500
                                       <?php echo !empty($email_error) ? 'border-red-500' : ''; ?>"
                                required
                                autocomplete="username"
                            >
                            <?php if (!empty($email_error)): ?>
                                <p class="mt-1 text-sm text-red-500"><?php echo $email_error; ?></p>
                            <?php endif; ?>
                        </div>
                        <div>
                            <label for="password" class="block text-sm font-medium text-gray-700">Password</label>
                            <input
                                id="password"
                                name="password"
                                type="password"
                                placeholder="Enter your password"
                                class="mt-1 w-full px-3 py-2 border border-gray-300 rounded-md text-sm shadow-sm placeholder-gray-400
                                       focus:outline-none focus:border-pink-500 focus:ring-1 focus:ring-pink-500
                                       <?php echo !empty($password_error) ? 'border-red-500' : ''; ?>"
                                required
                                autocomplete="current-password"
                            >
                            <?php if (!empty($password_error)): ?>
                                <p class="mt-1 text-sm text-red-500"><?php echo $password_error; ?></p>
                            <?php endif; ?>
                        </div>
                        <?php if (!empty($error)): ?>
                            <div class="text-red-500 text-sm"><?php echo $error; ?></div>
                        <?php endif; ?>
                        <div>
                            <button
                                type="submit"
                                class="w-full px-4 py-2 text-sm font-medium text-white bg-pink-500 hover:bg-pink-600 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-pink-500 rounded-md"
                            >
                                LOGIN
                            </button>
                        </div>
                    </form>
                    <div class="mt-4 flex items-center justify-between">
                        <div class="flex items-center">
                            <input id="remember-me" name="remember-me" type="checkbox" class="h-4 w-4 text-pink-600 focus:ring-pink-500 border-gray-300 rounded">
                            <label for="remember-me" class="ml-2 block text-sm text-gray-700">
                                Remember me
                            </label>
                        </div>
                        <div class="text-sm">
                            <a href="#" class="font-medium text-pink-500 hover:text-pink-600">
                                Forgot your password?
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="hidden md:flex md:w-1/2 bg-cover bg-center" style="background-image: url('https://hebbkx1anhila5yf.public.blob.vercel-storage.com/image-dCMsYYPPIVqstA1cH17M3fIAYj1osY.png')">
            <div class="w-full h-full flex items-center justify-center bg-black bg-opacity-50">
                <div class="text-center text-white p-8">
                    <h2 class="text-4xl font-bold mb-4">Welcome to ERM Motorparts and Accessories Inventory System.</h2>
                    <p class="text-xl">Sign in to continue to your account.</p>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
