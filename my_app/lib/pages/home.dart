import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_app/components/card.dart';
import 'package:my_app/services/api_service.dart';
import 'package:my_app/constant/color.dart'; // Import color constants

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<dynamic>> _imagesFuture;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  Future<void> _loadImages() async {
    setState(() {
      _isLoading = true;
      _imagesFuture = ApiService.fetchImages();
    });

    // Update loading state after fetch completes
    _imagesFuture
        .then((_) => setState(() => _isLoading = false))
        .catchError((_) => setState(() => _isLoading = false));
  }

  String _getCardTitle(dynamic image) {
    if (image['comments'] != null && image['comments'].isNotEmpty) {
      return image['comments'][0]['comment'];
    } else {
      // Use image ID or creation date as fallback
      return 'Image ${image['id']} (${image['created_at'].toString().substring(0, 10)})';
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    // Calculate number of grid columns based on screen width
    final crossAxisCount = screenWidth > 600 ? 3 : 2;

    return Scaffold(
      backgroundColor: AppColors.background,

      body: RefreshIndicator(
        color: AppColors.secondary,
        backgroundColor: Colors.white,
        onRefresh: _loadImages,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: FutureBuilder<List<dynamic>>(
            future: _imagesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.secondary,
                    ),
                  ),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 60,
                        color: AppColors.secondary,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Error loading images\n${snapshot.error}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: AppColors.primary),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadImages,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Try Again'),
                      ),
                    ],
                  ),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(
                  child: Text(
                    'No images found. Try adding some!',
                    style: TextStyle(color: AppColors.primary, fontSize: 16),
                  ),
                );
              } else {
                final images = snapshot.data!;
                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: images.length,
                  itemBuilder: (context, index) {
                    final image = images[index];
                    return Card(
                      elevation: 4,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: const BorderSide(
                          color: AppColors.accent,
                          width: 1,
                        ),
                      ),
                      child: ComicCard(
                        title: _getCardTitle(image),
                        imageUrl: image['imageURL'] ,
                        width: double.infinity,
                        height: 180,
                        onTap: () {
                          Get.toNamed('/image_details', arguments: image);
                        },
                      ),
                    );
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
