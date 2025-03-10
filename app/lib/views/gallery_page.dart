import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'full_screen_image_page.dart';

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
    files.sort((a, b) => b.statSync().modified.compareTo(a.statSync().modified));
    setState(() {
      _mediaFiles = files.where((file) => file.path.endsWith('.jpg') || file.path.endsWith('.mp4')).toList();
    });
  }

  void _deleteFile(File file) {
    file.delete();
    setState(() {
      _mediaFiles.remove(file);
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
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FullScreenImagePage(imageFile: File(file.path)),
                ),
              );
              if (result == 'delete') {
                _deleteFile(File(file.path));
                _loadMediaFiles(); // Refresh the gallery after deletion
              }
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