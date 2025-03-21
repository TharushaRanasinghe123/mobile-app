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
4. Setup PHP backend
   
### Setup PHP backend  

1. **Install XAMPP (or WAMP/MAMP)**  
   - Download XAMPP from [here](https://www.apachefriends.org/index.html).  

2. **Start Apache and MySQL**  
   - Open XAMPP Control Panel and start both Apache and MySQL services.  

3. **Setup PHP files**  
   - Copy PHP files (`upload.php`, `fetch_images.php`) into the `htdocs` folder inside the XAMPP directory.  

4. **Create the database**  
   - Open [phpMyAdmin](http://localhost/phpmyadmin/).  
   - Create a new database named `ImageDB`.  
   - Run the provided SQL queries to create necessary tables.  

5. **Edit PHP files for DB connection**  
   - Open `upload.php` and `fetch_images.php` and configure the database connection:  

   ```php
   $servername = "localhost";
   $username = "root";
   $password = "";
   $dbname = "ImageDB";
