<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json");
header("Access-Control-Allow-Methods: DELETE");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

require_once 'function.php';

$requestMethod = $_SERVER["REQUEST_METHOD"];

if ($requestMethod == "DELETE") {
    // Get the 'id' from the query string
    if (!isset($_GET['id']) || empty($_GET['id'])) {
        error422('Image ID is required');
    }

    $id = mysqli_real_escape_string($connection, $_GET['id']);

    // Check if the image exists
    $image = getImage($id);
    if (!$image) {
        jsonResponse(404, 404, ['message' => 'Image not found']);
        exit();
    }

    // Extract the file path from the image URL
    $imageURL = $image['imageURL'];
    
    // Check if it's a local file path or a full URL
    if (strpos($imageURL, 'http') === 0) {
        // Extract filename from URL
        $filename = basename($imageURL);
        $filePath = '../uploads/' . $filename;
    } else {
        // Assuming it's a relative path
        $filePath = '../uploads/' . basename($imageURL);
    }

    // Delete the image record from the database
    $query = "DELETE FROM images WHERE id = '$id'";
    $result = mysqli_query($connection, $query);

    if ($result) {
        // Attempt to delete the file from the filesystem if it exists
        if (file_exists($filePath)) {
            unlink($filePath); // Deletes the file
        }

        jsonResponse(200, 200, ['message' => 'Image deleted successfully']);
    } else {
        jsonResponse(500, 500, [
            'message' => 'Failed to delete image',
            'error' => mysqli_error($connection)
        ]);
    }
} else {
    jsonResponse(405, 405, ['message' => 'Method Not Allowed']);
}
?>