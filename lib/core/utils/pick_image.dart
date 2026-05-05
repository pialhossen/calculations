import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

Future<File?> pickImageWithOption(BuildContext context) async {
  final ImagePicker picker = ImagePicker();
  ImageSource? selectedSource;

  // 1. Show the selection UI immediately
  await showModalBottomSheet(
    context: context,
    builder: (context) => SafeArea(
      child: Wrap(
        children: [
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: const Text('Gallery'),
            onTap: () {
              selectedSource = ImageSource.gallery;
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text('Camera'),
            onTap: () {
              selectedSource = ImageSource.camera;
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    ),
  );

  // 2. If the user dismissed the sheet without picking, return null
  if (selectedSource == null) return null;

  // 3. Trigger the actual picker based on the choice
  try {
    final xFile = await picker.pickImage(
      source: selectedSource!,
      imageQuality: 50,
      maxWidth: 1080,
      maxHeight: 1080,  
    );
    return xFile != null ? File(xFile.path) : null;
  } catch (e) {
    debugPrint("Error picking image: $e");
    return null;
  }
}