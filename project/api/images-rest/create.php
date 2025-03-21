<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

require_once 'function.php';

$tableCreated = createImagesTable();
if (!$tableCreated) {
    jsonResponse(500, 500, ['message' => 'Failed to create images table']);
    exit();
}

$requestMethod = $_SERVER["REQUEST_METHOD"];

if ($requestMethod == "POST") {
    $inputData = json_decode(file_get_contents("php://input"), true);

    if (empty($inputData['imageURL'])) {
        error422('Image URL is required');
    }

    $imageURL = mysqli_real_escape_string($connection, $inputData['imageURL']);
    $comment = isset($inputData['comment']) ? mysqli_real_escape_string($connection, $inputData['comment']) : '';

    $query = "INSERT INTO images (imageURL) VALUES ('$imageURL')";
    $result = mysqli_query($connection, $query);

    if ($result) {
        $lastId = mysqli_insert_id($connection);

        // Insert comment if provided
        if (!empty($comment)) {
            $commentQuery = "INSERT INTO comments (image_id, comment) VALUES ('$lastId', '$comment')";
            mysqli_query($connection, $commentQuery);
        }

        $image = getImageWithComments($lastId);
        
        jsonResponse(201, 201, [
            'message' => 'Image created successfully',
            'image' => $image
        ]);
    } else {
        jsonResponse(500, 500, [
            'message' => 'Failed to create image',
            'error' => mysqli_error($connection)
        ]);
    }
} else {
    jsonResponse(405, 405, ['message' => 'Method Not Allowed']);
}
?>