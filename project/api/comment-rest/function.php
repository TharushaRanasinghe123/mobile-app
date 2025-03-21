<?php
require_once '../../inc/dbcon.php';

function errorResponse($statusCode, $message) {
    $data = [
        'status' => $statusCode,
        'message' => $message
    ];
    header("HTTP/1.0 $statusCode");
    echo json_encode($data);
    exit();
}

function jsonResponse($statusCode, $data) {
    header("HTTP/1.0 $statusCode");
    header("Content-Type: application/json");
    echo json_encode($data);
    exit();
}


// ...existing code...
function getImageWithComments($image_id) {
    global $connection;

    $image_id = mysqli_real_escape_string($connection, $image_id);

    // Get image details
    $imageQuery = "SELECT * FROM images WHERE id = '$image_id'";
    $imageResult = mysqli_query($connection, $imageQuery);

    if (!$imageResult || mysqli_num_rows($imageResult) == 0) {
        errorResponse(404, 'Image not found');
    }

    $image = mysqli_fetch_assoc($imageResult);
    
    // Get comments for this image
    $commentsQuery = "SELECT id, comment, created_at FROM comments WHERE image_id = '$image_id'";
    $commentsResult = mysqli_query($connection, $commentsQuery);
    
    // REMOVED redundant image query here

    $comments = [];
    if ($commentsResult && mysqli_num_rows($commentsResult) > 0) {
        while ($row = mysqli_fetch_assoc($commentsResult)) {
            $comments[] = $row;
        }
    }
    
    // Prepare response
    $response = [
        'image_id' => $image['id'],
        'image_url' => $image['imageURL'] ?? '',
        'comments' => $comments
    ];
    
    jsonResponse(200, $response);
}


function deleteComment($comment_id) {
    global $connection;

    $comment_id = mysqli_real_escape_string($connection, $comment_id);

    // Check if comment exists
    $checkQuery = "SELECT id FROM comments WHERE id = '$comment_id'";
    $checkResult = mysqli_query($connection, $checkQuery);

    if (!$checkResult || mysqli_num_rows($checkResult) == 0) {
        errorResponse(404, 'Comment not found');
    }

    // Delete the comment
    $query = "DELETE FROM comments WHERE id = '$comment_id'";
    $result = mysqli_query($connection, $query);

    if ($result) {
        jsonResponse(200, ['message' => 'Comment deleted successfully']);
    } else {
        errorResponse(500, 'Failed to delete comment');
    }
}


function validateRequestMethod($expectedMethod) {
    $requestMethod = $_SERVER["REQUEST_METHOD"];
    if ($requestMethod !== $expectedMethod) {
        errorResponse(405, "$requestMethod Method Not Allowed");
    }
}

function getInputData() {
    $inputData = json_decode(file_get_contents("php://input"), true);
    return !empty($inputData) ? $inputData : $_POST;
}

function addComment($commentInput) {
    global $connection;

    $image_id = mysqli_real_escape_string($connection, $commentInput['image_id']);
    $comment_text = mysqli_real_escape_string($connection, $commentInput['comment']);

    if (empty($image_id)) {
        errorResponse(422, 'Image ID is required');
    } elseif (empty($comment_text)) {
        errorResponse(422, 'Comment text is required');
    }

    $checkImage = "SELECT id FROM images WHERE id = '$image_id'";
    $imageResult = mysqli_query($connection, $checkImage);

    if (mysqli_num_rows($imageResult) == 0) {
        errorResponse(404, 'Image not found');
    }

    $query = "INSERT INTO comments (image_id, comment, created_at) 
              VALUES ('$image_id', '$comment_text', NOW())";
    $result = mysqli_query($connection, $query);

    if ($result) {
        jsonResponse(201, ['message' => 'Comment Added Successfully']);
    } else {
        errorResponse(500, 'Internal Server Error');
    }
}

function getCommentsByImage($image_id) {
    global $connection;

    $image_id = mysqli_real_escape_string($connection, $image_id);

    $query = "SELECT * FROM comments WHERE image_id = '$image_id'";
    $result = mysqli_query($connection, $query);

    if ($result && mysqli_num_rows($result) > 0) {
        $comments = [];
        while ($row = mysqli_fetch_assoc($result)) {
            $comments[] = $row;
        }
        jsonResponse(200, $comments);
    } else {
        errorResponse(404, 'No comments found for the specified image');
    }
}

function updateComment($commentInput, $comment_id, $image_id = null) {
    global $connection;

    $comment_text = mysqli_real_escape_string($connection, $commentInput['comment']);

    if (empty($comment_text)) {
        errorResponse(422, 'Comment text is required');
    }

    if ($image_id) {
        $image_id = mysqli_real_escape_string($connection, $image_id);
        $query = "UPDATE comments 
                  SET comment='$comment_text'
                  WHERE id='$comment_id' AND image_id='$image_id'";
    } else {
        $query = "UPDATE comments 
                  SET comment='$comment_text'
                  WHERE id='$comment_id'";
    }

    $result = mysqli_query($connection, $query);

    if ($result && mysqli_affected_rows($connection) > 0) {
        jsonResponse(200, ['message' => 'Comment Updated Successfully']);
    } elseif ($result && mysqli_affected_rows($connection) == 0) {
        errorResponse(404, 'Comment not found or no changes made');
    } else {
        errorResponse(500, 'Internal Server Error');
    }
}

function deleteImage($id) {
    global $connection;

    $id = mysqli_real_escape_string($connection, $id);

    $image = getImage($id);
    if (!$image) {
        errorResponse(404, 'Image not found');
    }

    $query = "DELETE FROM images WHERE id = '$id'";
    $result = mysqli_query($connection, $query);

    if ($result) {
        jsonResponse(200, ['message' => 'Image and associated comments deleted successfully']);
    } else {
        errorResponse(500, 'Failed to delete image');
    }
}

function getImage($id) {
    global $connection;

    $query = "SELECT * FROM images WHERE id = '$id'";
    $result = mysqli_query($connection, $query);

    return mysqli_fetch_assoc($result);
}
?>