<?php
$connection = mysqli_connect("localhost", "root", "Chamar@12", "ImageDB");

if (!$connection) {
    die("Database connection failed: " . mysqli_connect_error());
}
?>