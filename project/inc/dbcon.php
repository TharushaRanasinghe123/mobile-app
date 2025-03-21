<?php
// Include config file
require_once 'config.php';

// Connect using configuration constants
$connection = mysqli_connect(DB_HOST, DB_USERNAME, DB_PASSWORD, DB_DATABASE);

if (!$connection) {
    die("Database connection failed: " . mysqli_connect_error());
}
?>