<?php
ob_start();
session_start();


// ============================================
// DATABASE CONFIGURATION
// ============================================
define('DB_HOST', 'localhost');
define('DB_USER', 'root');
define('DB_PASS', '');
define('DB_NAME', 'db_sekolah');

// Koneksi Database
try {
    $conn = new mysqli(DB_HOST, DB_USER, DB_PASS, DB_NAME);
    
    if ($conn->connect_error) {
        die("Koneksi gagal: " . $conn->connect_error);
    }
    
    $conn->set_charset("utf8mb4");
} catch (Exception $e) {
    die("Error: " . $e->getMessage());
}

// ============================================
// SITE CONFIGURATION
// ============================================
define('BASE_URL', 'http://localhost/sekolah/');
define('UPLOAD_DIR', 'uploads/');

// ===============================
// HELPER FUNCTIONS
// ===============================

// Mengecek apakah user sudah login
function isLoggedIn() {
    return isset($_SESSION['user_id']);
}

// Mengecek role user
function hasRole($role) {
    return isset($_SESSION['role']) && $_SESSION['role'] === $role;
}

// Redirect
function redirect($url) {
    header("Location: $url");
    exit();
}

// Paksa login
function requireLogin() {
    if (!isLoggedIn()) {
        redirect('login.php');
    }
}

// Paksa role tertentu
function requireRole($role) {
    requireLogin();
    if (!hasRole($role)) {
        redirect('index.php');
    }
}

// Upload file function (improved and fixed)
function uploadFile($file, $folder = '') {
    if (!isset($file)) {
        return false;
    }

    // Check upload error
    if ($file['error'] !== UPLOAD_ERR_OK) {
        // Return detailed error code for debugging (you can log this)
        return ['error' => true, 'code' => $file['error']];
    }

    // Use finfo to detect MIME type reliably
    $finfo = new finfo(FILEINFO_MIME_TYPE);
    $mime  = $finfo->file($file['tmp_name']);

    $allowed = [
        'image/jpeg' => 'jpg',
        'image/png'  => 'png',
        'image/gif'  => 'gif',
        'image/webp' => 'webp'
    ];

    if (!isset($allowed[$mime])) {
        return ['error' => true, 'message' => 'Tipe file tidak diperbolehkan'];
    }

    // Max 5MB
    $maxSize = 5 * 1024 * 1024;
    if ($file['size'] > $maxSize) {
        return ['error' => true, 'message' => 'Ukuran file melebihi batas'];
    }

    // Build directories using absolute path
    $baseUploadDir = __DIR__ . DIRECTORY_SEPARATOR . UPLOAD_DIR;
    $uploadDir = rtrim($baseUploadDir, DIRECTORY_SEPARATOR);
    if ($folder !== '') {
        // sanitize folder name
        $folder = trim($folder, "/\\ ");
        $uploadDir .= DIRECTORY_SEPARATOR . $folder;
    }

    if (!is_dir($uploadDir)) {
        if (!mkdir($uploadDir, 0777, true)) {
            return ['error' => true, 'message' => 'Gagal membuat direktori upload'];
        }
    }

    // Generate filename with correct extension from MIME map
    $extension = $allowed[$mime];
    $filename = uniqid('', true) . '_' . time() . '.' . $extension;
    $destination = $uploadDir . DIRECTORY_SEPARATOR . $filename;

    if (!move_uploaded_file($file['tmp_name'], $destination)) {
        return ['error' => true, 'message' => 'Gagal memindahkan file. Periksa permission direktori.'];
    }

    // Set permission (optional)
    @chmod($destination, 0644);

    // Return path relative to project root (no leading slash)
    $relativePath = rtrim(UPLOAD_DIR, "/\\");
    if ($folder !== '') {
        $relativePath .= '/' . $folder;
    }
    $relativePath .= '/' . $filename;

    // PERBAIKAN: Kembalikan path tanpa leading slash
    // Path akan menjadi: uploads/guru/xxxxx.jpg (BUKAN /uploads/guru/xxxxx.jpg)
    return ['error' => false, 'path' => $relativePath];
}

// Format tanggal ke Bahasa Indonesia
function formatTanggal($date) {
    $bulan = [
        1 => 'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
        'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    
    $timestamp = strtotime($date);
    $tanggal = date('d', $timestamp);
    $bulanNama = $bulan[date('n', $timestamp)];
    $tahun = date('Y', $timestamp);
    
    return $tanggal . ' ' . $bulanNama . ' ' . $tahun;
}

// Alert message function
function alert($message, $type = 'success') {
    $icon = $type === 'success' ? '✓' : '✕';
    $color = $type === 'success' ? '#10b981' : '#ef4444';
    echo "<script>alert('$icon $message');</script>";
}

// Sanitize input
function clean($string) {
    global $conn;
    return $conn->real_escape_string(trim($string));
}

// Get current user data
function getCurrentUser() {
    global $conn;
    if (!isLoggedIn()) {
        return null;
    }
    
    $user_id = $_SESSION['user_id'];
    $query = $conn->query("SELECT * FROM users WHERE id = $user_id");
    return $query->fetch_assoc();
}


?>