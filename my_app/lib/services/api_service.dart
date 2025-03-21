import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class ApiService {
  static const String _baseUrl =
      'http://localhost/project/api/images-rest/read.php';

  static Future<List<dynamic>> fetchImages() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['data']['images'] ?? [];
      } else {
        throw Exception('Failed to load images');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  static Future<String> deleteComment(int id) async {
    final url = 'http://localhost/project/api/comment-rest/delete.php?id=$id';
    try {
      final response = await http.delete(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['message'] ?? 'Comment deleted successfully';
      } else {
        throw Exception('Failed to delete comment');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  static Future<String> addComment(int imageId, String comment) async {
    const url = 'http://localhost/project/api/comment-rest/create.php';
    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode({'image_id': imageId, 'comment': comment}),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['message'] ?? 'Comment Added Successfully';
      } else {
        throw Exception('Failed to add comment');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  static Future<String> deleteImage(int imageId) async {
    final url =
        'http://localhost/project/api/images-rest/delete.php?id=$imageId';
    try {
      final response = await http.delete(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['data']['message'] ?? 'Image deleted successfully';
      } else {
        throw Exception('Failed to delete image');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  static Future<String> uploadImage(File imageFile) async {
    const url = 'http://localhost/project/api/images-rest/upload.php';
    try {
      final request = http.MultipartRequest('POST', Uri.parse(url));
      request.files.add(
        await http.MultipartFile.fromPath(
          'file',
          imageFile.path,
          contentType: MediaType('image', 'jpeg'),
        ),
      );

      final response = await request.send();
      if (response.statusCode == 200) {
        final responseData = await http.Response.fromStream(response);
        final data = json.decode(responseData.body);
        if (data['success'] == true) {
          return data['file']['full_url'];
        } else {
          throw Exception(data['message'] ?? 'Failed to upload image');
        }
      } else {
        throw Exception('Failed to upload image');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  static Future<String> createImageEntry(
    String imageURL,
    String comment,
  ) async {
    const url = 'http://localhost/project/api/images-rest/create.php';
    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode({'imageURL': imageURL, 'comment': comment}),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        return data['data']['message'] ?? 'Image created successfully';
      } else {
        throw Exception('Failed to create image entry');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
