import 'dart:io';
import 'package:flutter/material.dart';
import 'package:share/share.dart';

class CreateImageScreen extends StatelessWidget {
  const CreateImageScreen({
    super.key,
    required this.rect,
    required this.path,
  });

  final Rect rect;
  final String path;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      appBar: AppBar(
        title: const Text('Created Image'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => _shareImage(),
          ),
        ],
      ),
      body: Image.file(
        colorBlendMode: BlendMode.dst,
        File(path),
        key: ValueKey(UniqueKey()),
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return const Text('No read');
        },
      ),
    );
  }

  void _shareImage() {
    Share.shareFiles([path], text: 'Check out this image!');
  }
}
