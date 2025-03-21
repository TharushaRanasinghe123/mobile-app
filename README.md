# 📱 Flutter Image Upload App

## 🔹 Overview
A Flutter mobile app that allows users to:
- 📸 Select an image from the gallery or take a photo
- 📝 Add a comment
- 📤 Upload the image and comment to a backend server
- 📂 View a list of previously uploaded images with comments

## 🛠 Tech Stack
- **Frontend:** Flutter, Dart
- **Backend:** PHP, MySQL

## 🗄 Database Schema
```sql
CREATE TABLE IF NOT EXISTS images (
    id INT AUTO_INCREMENT PRIMARY KEY,
    imageURL VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE IF NOT EXISTS comments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    image_id INT NOT NULL,
    comment TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (image_id) REFERENCES images(id) ON DELETE CASCADE
);
```

## 🔗 API Endpoints
- **POST /upload.php** → Upload images
- **GET /fetch_images.php** → Fetch uploaded images
- more other

## 🚀 Setup
1. Clone the project:  
   ```sh
   git clone https://github.com/TharushaRanasinghe123/mobile-app.git
   ```
2. Install dependencies:  
   ```sh
   flutter pub get
   ```
3. Run the app:  
   ```sh
   flutter run
   ```
4. Setup PHP backend:
Install XAMPP (or any other local server like WAMP or MAMP) from here.

Start Apache and MySQL from the XAMPP control panel.

Place PHP files (e.g., upload.php, fetch_images.php) into the htdocs folder inside the XAMPP directory.

Create the database:

Go to phpMyAdmin and create a database (mobile_app_db).
Run the SQL queries to create the tables.
Edit database connection in the PHP files:

php
Copy
Edit
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "mobile_app_db";
Run the PHP files:

To upload: http://localhost/project-name/upload.php
To fetch images: http://localhost/project-name/fetch_images.php

