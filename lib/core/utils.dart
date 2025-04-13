import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moveo/features/auth/controller/auth_controller.dart';
import 'package:moveo/features/auth/view/login_page.dart';

void showSnackBar(BuildContext context, String content) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(content),
    ),
  );
}

String getNameFromEmail(String email) {
  return email.split('@')[0];
}

Future<List<File>> pickMultiImages() async {
  List<File> images = [];
  final ImagePicker picker = ImagePicker();
  final ImageFiles = await picker.pickMultiImage();
  if(ImageFiles.isNotEmpty) {
    for(final image in ImageFiles) {
      images.add(File(image.path));
    }
  }
  return images;
}

Future<File?> pickSingleImage() async {
  final ImagePicker picker = ImagePicker();
  final XFile? imageFile = await picker.pickImage(source: ImageSource.gallery);

  if (imageFile != null) {
    return File(imageFile.path);
  }
  return null; 
}

Future<void> logout(BuildContext context, WidgetRef ref) async {
  final authController = ref.read(authControllerProvider.notifier);
  try {
    await authController.logout();
    Navigator.of(context).pushAndRemoveUntil(
      LoginPage.route(),
      (route) => false,
    );
  } catch (e) {
    showSnackBar(context, 'Error logging out: ${e.toString()}');
  }
}