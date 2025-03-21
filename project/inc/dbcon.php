<?php
$connection = mysqli_connect("localhost", "root", "123456", "ImageDB");

if (!$connection) {
    die("Database connection failed: " . mysqli_connect_error());
}
?>