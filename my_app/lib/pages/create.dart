import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:get/get.dart';
import '../services/api_service.dart';
import '../components/input_field.dart';
import '../components/button.dart';
import '../components/custom_card.dart';
import '../constant/color.dart';

class CreatePage extends StatefulWidget {
  const CreatePage({super.key});

  @override
  _CreatePageState createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  File? _image;
  final TextEditingController _commentController = TextEditingController();
  bool _isUploading = false;

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> _uploadAndCreateImage() async {
    // Existing implementation...
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
     
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.background, Colors.white],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth > 600 ? 100 : 20,
                vertical: 20,
              ),
              child: CustomCard(
                elevation: 4,
                borderRadius: BorderRadius.circular(24),
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Share Your Moment',
                      style: Theme.of(
                        context,
                      ).textTheme.headlineMedium?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),

                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.accent.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.primary.withOpacity(0.3),
                          width: 2,
                        ),
                      ),
                      height: 240,
                      child:
                          _image == null
                              ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.add_photo_alternate_outlined,
                                      size: 64,
                                      color: AppColors.primary.withOpacity(0.7),
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'Tap to select an image',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                              : ClipRRect(
                                borderRadius: BorderRadius.circular(14),
                                child: Image.file(
                                  _image!,
                                  width: double.infinity,
                                  height: 240,
                                  fit: BoxFit.cover,
                                ),
                              ),
                    ),

                    const SizedBox(height: 24),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: CustomButton(
                            text: 'Gallery',
                            icon: Icons.photo_library,
                            onPressed: () => _pickImage(ImageSource.gallery),
                            width: screenWidth > 600 ? 150 : 100,
                            height: 48,
                            backgroundColor: AppColors.secondary,
                            useGradient: true,
                            borderRadius: 12,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: CustomButton(
                            text: 'Camera',
                            icon: Icons.camera_alt,
                            onPressed: () => _pickImage(ImageSource.camera),
                            width: screenWidth > 600 ? 150 : 100,
                            height: 48,
                            backgroundColor: AppColors.secondary,
                            useGradient: true,
                            borderRadius: 12,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    CustomInputField(
                      hintText: 'Add a caption to your image...',
                      controller: _commentController,
                      prefixIcon: Icon(
                        Icons.comment,
                        color: AppColors.primary.withOpacity(0.7),
                      ),
                    ),

                    const SizedBox(height: 24),

                    CustomButton(
                      text: 'Upload Image',
                      icon: Icons.cloud_upload,
                      onPressed: _isUploading ? null : _uploadAndCreateImage,
                      width: double.infinity,
                      height: 54,
                      backgroundColor: AppColors.primary,
                      useGradient: true,
                      isLoading: _isUploading,
                      borderRadius: 12,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
