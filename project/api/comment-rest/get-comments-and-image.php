<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json");

include('function.php');

validateRequestMethod('GET');

$image_id = isset($_GET['image_id']) ? $_GET['image_id'] : null;

if (!$image_id) {
    errorResponse(422, 'Image ID is required');
}

getImageWithComments($image_id);
?>