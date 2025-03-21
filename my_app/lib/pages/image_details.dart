import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/api_service.dart';
import '../components/input_field.dart';
import '../components/button.dart';
import '../components/custom_card.dart';
import '../components/image_container.dart';
import '../constant/color.dart';

class ImageDetailsPage extends StatefulWidget {
  const ImageDetailsPage({super.key});

  @override
  State<ImageDetailsPage> createState() => _ImageDetailsPageState();
}

class _ImageDetailsPageState extends State<ImageDetailsPage> {
  final TextEditingController _commentController = TextEditingController();
  bool _isSubmitting = false;

  Future<void> _addComment(int imageId) async {
    final comment = _commentController.text.trim();
    if (comment.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter a comment',
        backgroundColor: AppColors.error.withOpacity(0.1),
        colorText: AppColors.error,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final message = await ApiService.addComment(imageId, comment);
      _commentController.clear();

      // Refresh the page to show the new comment
      final updatedImages = await ApiService.fetchImages();
      final updatedImage = updatedImages.firstWhere(
        (img) => int.parse(img['id']) == imageId,
        orElse: () => Get.arguments,
      );

      Get.offAndToNamed('/image-details', arguments: updatedImage);

      Get.snackbar(
        'Success',
        message,
        backgroundColor: Colors.green.withOpacity(0.1),
        colorText: Colors.green,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: AppColors.error.withOpacity(0.1),
        colorText: AppColors.error,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  Future<void> deleteComment(int commentId) async {
    try {
      // Show confirmation dialog
      final confirm = await Get.dialog<bool>(
        AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure you want to delete this comment?'),
          actions: [
            TextButton(
              onPressed: () => Get.back(result: false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Get.back(result: true),
              child: Text('Delete', style: TextStyle(color: AppColors.error)),
            ),
          ],
        ),
      );

      if (confirm != true) return;

      final message = await ApiService.deleteComment(commentId);

      // Refresh the page to update comments list
      final updatedImages = await ApiService.fetchImages();
      final image = Get.arguments;
      final updatedImage = updatedImages.firstWhere(
        (img) => img['id'] == image['id'],
        orElse: () => image,
      );

      Get.offAndToNamed('/image-details', arguments: updatedImage);

      Get.snackbar(
        'Success',
        message,
        backgroundColor: Colors.green.withOpacity(0.1),
        colorText: Colors.green,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: AppColors.error.withOpacity(0.1),
        colorText: AppColors.error,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final image = Get.arguments; // Retrieve image data passed via arguments

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.background, Colors.white],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth > 600 ? 100 : 16,
            vertical: 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image container with enhanced styling
              ImageContainer(
                imageUrl: image['imageURL'] ,
                    
                height: screenWidth > 600 ? 400 : 300,
                width: double.infinity,
                borderRadius: BorderRadius.circular(16),
              ),

              const SizedBox(height: 24),

              // Caption display if available
              if (image['caption'] != null && image['caption'].isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: CustomCard(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Caption:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          image['caption'],
                          style: const TextStyle(
                            fontSize: 16,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              // Comments section header with badge count
              Row(
                children: [
                  Text(
                    'Comments',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.secondary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${image['comments'].length}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Comments list
              Expanded(
                child:
                    image['comments'].isEmpty
                        ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.chat_bubble_outline,
                                size: 48,
                                color: AppColors.secondary.withOpacity(0.5),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No comments yet. Be the first to comment!',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        )
                        : ListView.builder(
                          itemCount: image['comments'].length,
                          itemBuilder: (context, index) {
                            final comment = image['comments'][index];
                            return CustomCard(
                              elevation: 1,
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Comment #${index + 1}',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          Icons.delete_outline,
                                          color: AppColors.error.withOpacity(
                                            0.7,
                                          ),
                                          size: 20,
                                        ),
                                        onPressed:
                                            () => deleteComment(
                                              int.parse(comment['id']),
                                            ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    comment['comment'],
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    comment['created_at'],
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textSecondary,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
              ),

              // Add comment section
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Column(
                  children: [
                    CustomInputField(
                      hintText: 'Add your comment...',
                      controller: _commentController,
                      prefixIcon: Icon(
                        Icons.comment,
                        color: AppColors.primary.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(height: 12),
                    CustomButton(
                      text: 'Post Comment',
                      icon: Icons.send,
                      onPressed:
                          _isSubmitting
                              ? null
                              : () => _addComment(int.parse(image['id'])),
                      width: double.infinity,
                      height: 48,
                      backgroundColor: AppColors.primary,
                      useGradient: true,
                      isLoading: _isSubmitting,
                      borderRadius: 12,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
