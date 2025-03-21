import 'package:get/get.dart';
import 'package:my_app/pages/home.dart';
import 'package:my_app/pages/create.dart';
import 'package:my_app/pages/image_details.dart';
import 'package:my_app/components/navbar.dart';
import 'package:flutter/material.dart';
import 'package:my_app/constant/color.dart'; // Import color constants

class AppRoutes {
  static final routes = [
    GetPage(
      name: '/',
      page: () => Scaffold(
        appBar: AppBar(
          title: const Text(
            'Home',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: AppColors.primary,
          elevation: 2,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: const HomePage(),
        bottomNavigationBar: const NavBar(),
        backgroundColor: AppColors.background,
      ),
    ),
    GetPage(
      name: '/create',
      page: () => Scaffold(
        appBar: AppBar(
          title: const Text(
            'Create',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: AppColors.primary,
          elevation: 2,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: const CreatePage(),
        bottomNavigationBar: const NavBar(),
        backgroundColor: AppColors.background,
      ),
    ),
    GetPage(
      name: '/image_details',
      page: () => Scaffold(
        appBar: AppBar(
          title: const Text(
            'Image Details',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: AppColors.primary,
          elevation: 2,
          iconTheme: const IconThemeData(color: Colors.white),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Get.back(),
          ),
        ),
        body: const ImageDetailsPage(),
        backgroundColor: AppColors.background,
      ),
    ),
  ];
}