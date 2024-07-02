import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PhotoUploadScreen extends StatefulWidget {
  final Function(Map<String, XFile>) onPhotosSelected;

  const PhotoUploadScreen({required this.onPhotosSelected, Key? key}) : super(key: key);

  @override
  _PhotoUploadScreenState createState() => _PhotoUploadScreenState();
}

class _PhotoUploadScreenState extends State<PhotoUploadScreen> {
  final ImagePicker _picker = ImagePicker();
  Map<String, XFile> _selectedImages = {
    'avant': XFile(''),
    'arriere': XFile(''),
    'gauche': XFile(''),
    'droit': XFile(''),
  };

  Future<void> _pickImage(String position) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImages[position] = pickedFile;
      });
    }
  }

  void _submitPhotos() {
    widget.onPhotosSelected(_selectedImages);
    Navigator.pop(context, true);
  }

  Widget _buildImageTile(String position, String label) {
    return GestureDetector(
      onTap: () => _pickImage(position),
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.all(4.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: _selectedImages[position]!.path.isEmpty
                ? Center(
                    child: Icon(Icons.add_a_photo, size: 50, color: Colors.grey),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.file(
                      File(_selectedImages[position]!.path),
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
          ),
          if (_selectedImages[position]!.path.isNotEmpty)
            Positioned(
              top: 0,
              right: 0,
              child: IconButton(
                icon: Icon(Icons.close, color: Colors.red),
                onPressed: () {
                  setState(() {
                    _selectedImages[position] = XFile('');
                  });
                },
              ),
            ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.black54,
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajouter des Photos'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF3366FF), Color(0xFF00CCFF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1e3c72), Color(0xFF2a5298)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              GridView.count(
                shrinkWrap: true,
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: [
                  _buildImageTile('avant', 'Avant'),
                  _buildImageTile('arriere', 'Arrière'),
                  _buildImageTile('gauche', 'Gauche'),
                  _buildImageTile('droit', 'Droit'),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitPhotos,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15), backgroundColor: Colors.blue,
                  textStyle: const TextStyle(fontSize: 18),
                ),
                child: const Text('Valider'),
              ),
            ],
          ),
        ),
      ),
     ],),);
  }
}
