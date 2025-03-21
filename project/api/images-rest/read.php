<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json");
header("Access-Control-Allow-Methods: GET");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

require_once 'function.php';

// Create the images table if it doesn't exist
$tableCreated = createImagesTable();
if (!$tableCreated) {
    jsonResponse(500, 500, ['message' => 'Failed to create images table']);
    exit();
}

$requestMethod = $_SERVER["REQUEST_METHOD"];

if ($requestMethod == "GET") {
    
    if(isset($_GET['id'])) {
        // Get a specific image by ID
        $image = getImageWithComments($_GET['id']);
        
        if($image) {
            jsonResponse(200, 200, ['image' => $image]);
        } else {
            jsonResponse(404, 404, ['message' => 'Image not found']);
        }
    } else {
        // Get all images
        $images = getImagesWithComments();
        
        if($images) {
            jsonResponse(200, 200, ['images' => $images]);
        } else {
            jsonResponse(200, 200, ['images' => [], 'message' => 'No images found']);
        }
    }
} else {
    jsonResponse(405, 405, ['message' => 'Method Not Allowed']);
}
?>