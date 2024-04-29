import 'dart:ffi';
import 'dart:typed_data';

import 'package:flutter/material.dart';

class GenericImage extends StatelessWidget {
  final String? imagePath; // For local asset
  final String? imageUrl; // For online image
  final Uint8List? imageMemory; // For memory image
  final double? width;
  final double? height;
  final BoxFit? fit; // How to fit image within container
  final Function(ImageProvider)?
      onLoad; // Callback for successful image loading

  const GenericImage({
    Key? key,
    this.imagePath,
    this.imageUrl,
    this.width = 60,
    this.height = 60,
    this.fit,
    this.onLoad,
    this.imageMemory,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (imagePath != null) {
      return Image.asset(
        imagePath!,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, trace) => const Center(
          child: Icon(Icons.error),
        ),
      );
    }else if (imageMemory != null) {
      return Image.memory(
        imageMemory!,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, trace) => const Center(
          child: Icon(Icons.error),
        ),
      );
    } else if (imageUrl != null) {
      return Image.network(
        imageUrl!,
        width: width,
        height: height,
        fit: fit,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return const Center(child: CircularProgressIndicator());
        },
        errorBuilder: (context, error, trace) => const Center(
          child: Icon(Icons.error),
        ),
      );
    } else {
      return SizedBox(
        width: width ?? 60,
        height: height ?? 60,
        child: const Center(
          child: Text(
            'No image provided',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }
  }
}
