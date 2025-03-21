<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json");
header("Access-Control-Allow-Methods: PUT");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

include('function.php');

validateRequestMethod('PUT');

$comment_id = isset($_GET['id']) ? $_GET['id'] : null;
$image_id = isset($_GET['image_id']) ? $_GET['image_id'] : null;

if (!$comment_id) {
    errorResponse(422, 'Comment ID is required');
}

$inputData = getInputData();
updateComment($inputData, $comment_id, $image_id);
?>