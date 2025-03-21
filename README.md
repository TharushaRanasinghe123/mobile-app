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
4. Setup backend in a server with PHP & MySQL.

