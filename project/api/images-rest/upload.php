<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST');
header('Access-Control-Allow-Headers: Content-Type');

// Create the uploads directory if it doesn't exist
$uploadDir = '../uploads/';
if (!file_exists($uploadDir)) {
    mkdir($uploadDir, 0777, true);
}

// Check if the request method is POST
if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405); // Method Not Allowed
    echo json_encode(['error' => 'Only POST method is allowed']);
    exit;
}

// Check if file was uploaded
if (!isset($_FILES['image']) || $_FILES['image']['error'] !== UPLOAD_ERR_OK) {
    http_response_code(400); // Bad Request
    echo json_encode(['error' => 'No file uploaded or upload error occurred']);
    exit;
}

// Get file information
$file = $_FILES['image'];
$fileName = $file['name'];
$fileTmpPath = $file['tmp_name'];
$fileSize = $file['size'];
$fileType = $file['type'];

// Validate file type
$allowedTypes = ['image/jpeg', 'image/png', 'image/gif', 'image/webp'];
if (!in_array($fileType, $allowedTypes)) {
    http_response_code(400);
    echo json_encode(['error' => 'Only image files (JPEG, PNG, GIF, WEBP) are allowed']);
    exit;
}

// Generate unique filename to prevent overwriting
$newFileName = uniqid() . '_' . $fileName;
$uploadPath = $uploadDir . $newFileName;

// Move the uploaded file to the destination
if (move_uploaded_file($fileTmpPath, $uploadPath)) {
    // Get the full server URL path
    $protocol = isset($_SERVER['HTTPS']) && $_SERVER['HTTPS'] === 'on' ? 'https://' : 'http://';
    $host = $_SERVER['HTTP_HOST'];
    $relativePath = '/project/uploads/' . $newFileName;
    $fullPath = $protocol . $host . $relativePath;
    
    // Return success response with file paths
    echo json_encode([
        'success' => true,
        'message' => 'File uploaded successfully',
        'file' => [
            'name' => $newFileName,
            'type' => $fileType,
            'size' => $fileSize,
            'path' => $relativePath,
            'full_url' => $fullPath
        ]
    ]);
} else {
    http_response_code(500); // Internal Server Error
    echo json_encode(['error' => 'Failed to save the uploaded file']);
}
?>