import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class GalleryPage extends StatefulWidget {
  final String title;

  const GalleryPage({Key? key, required this.title}) : super(key: key);

  @override
  _GalleryPageState createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  List<FileSystemEntity> _mediaFiles = [];

  @override
  void initState() {
    super.initState();
    _loadMediaFiles();
  }

  Future<void> _loadMediaFiles() async {
    final Directory appDir = await getApplicationDocumentsDirectory();
    final List<FileSystemEntity> files = appDir.listSync();
    setState(() {
      _mediaFiles = files.where((file) => file.path.endsWith('.jpg') || file.path.endsWith('.mp4')).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: _mediaFiles.isEmpty
          ? Center(child: Text('No media files found.'))
          : GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 4.0,
          mainAxisSpacing: 4.0,
        ),
        itemCount: _mediaFiles.length,
        itemBuilder: (context, index) {
          final file = _mediaFiles[index];
          return GestureDetector(
            onTap: () {
              // Handle media file tap
            },
            child: file.path.endsWith('.mp4')
                ? Icon(Icons.videocam)
                : Image.file(File(file.path), fit: BoxFit.cover),
          );
        },
      ),
    );
  }
}