<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json");
header("Access-Control-Allow-Methods: DELETE");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

include('function.php');

validateRequestMethod('DELETE');

$comment_id = isset($_GET['id']) ? $_GET['id'] : null;

if (!$comment_id) {
    errorResponse(422, 'Comment ID is required');
}

deleteComment($comment_id);
?>