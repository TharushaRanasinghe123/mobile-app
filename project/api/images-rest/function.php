<?php
require_once '../../inc/dbcon.php';

// Helper function to execute a query and return the result
function executeQuery($query) {
    global $connection;
    $result = mysqli_query($connection, $query);
    if (!$result) {
        jsonResponse(500, 500, ['message' => 'Database query failed', 'error' => mysqli_error($connection)]);
        exit();
    }
    return $result;
}

// Helper function to fetch all rows from a query result
function fetchAll($result) {
    return mysqli_num_rows($result) > 0 ? mysqli_fetch_all($result, MYSQLI_ASSOC) : [];
}

// Helper function to fetch a single row from a query result
function fetchSingle($result) {
    return mysqli_num_rows($result) == 1 ? mysqli_fetch_assoc($result) : null;
}

// Error handling function for REST API
function error422($message) {
    jsonResponse(422, 422, ['message' => $message]);
    exit();
}

// Function to return JSON response
function jsonResponse($status, $status_code, $data) {
    header("Content-Type: application/json");
    echo json_encode([
        'status' => $status,
        'status_code' => $status_code,
        'data' => $data
    ]);
    exit();
}

// Function to get all images
function getImages() {
    $query = "SELECT * FROM images ORDER BY created_at DESC";
    $result = executeQuery($query);
    return fetchAll($result);
}

// Function to get a single image by ID
function getImage($id) {
    global $connection;
    $id = mysqli_real_escape_string($connection, $id);
    $query = "SELECT * FROM images WHERE id='$id' LIMIT 1";
    $result = executeQuery($query);
    return fetchSingle($result);
}

// Function to create the images and comments tables if they don't exist
function createImagesTable() {
    $imagesQuery = "CREATE TABLE IF NOT EXISTS images (
        id INT AUTO_INCREMENT PRIMARY KEY,
        imageURL VARCHAR(255) NOT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    )";
    $commentsQuery = "CREATE TABLE IF NOT EXISTS comments (
        id INT AUTO_INCREMENT PRIMARY KEY,
        image_id INT NOT NULL,
        comment TEXT NOT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (image_id) REFERENCES images(id) ON DELETE CASCADE
    )";
    executeQuery($imagesQuery);
    executeQuery($commentsQuery);
    return true;
}

// Function to get all images with their comments
function getImagesWithComments() {
    $images = getImages();
    foreach ($images as &$image) {
        $image['comments'] = getCommentsByImageId($image['id']);
    }
    return $images;
}

// Function to get a single image with its comments
function getImageWithComments($id) {
    $image = getImage($id);
    if ($image) {
        $image['comments'] = getCommentsByImageId($id);
    }
    return $image;
}

// Function to get comments for a specific image ID
function getCommentsByImageId($image_id) {
    global $connection;
    $image_id = mysqli_real_escape_string($connection, $image_id);
    $query = "SELECT * FROM comments WHERE image_id = '$image_id' ORDER BY created_at ASC";
    $result = executeQuery($query);
    return fetchAll($result);
}
?>