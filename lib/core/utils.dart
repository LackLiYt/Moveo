
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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