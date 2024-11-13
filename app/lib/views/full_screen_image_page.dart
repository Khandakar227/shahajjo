import 'dart:io';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class FullScreenImagePage extends StatelessWidget {
  final File imageFile;

  const FullScreenImagePage({Key? key, required this.imageFile}) : super(key: key);

  void _shareImage() {
    Share.shareXFiles([XFile(imageFile.path)], text: 'Evidence shared from Shahajjo');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.file(
              imageFile,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 40,
            left: 16,
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          Positioned(
            bottom: 16,
            left: 16,
            child: FloatingActionButton(
              heroTag: 'delete',
              onPressed: () {
                Navigator.pop(context, 'delete');
              },
              child: Icon(Icons.delete),
            ),
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              heroTag: 'share',
              onPressed: _shareImage,
              child: Icon(Icons.share),
            ),
          ),
        ],
      ),
    );
  }
}