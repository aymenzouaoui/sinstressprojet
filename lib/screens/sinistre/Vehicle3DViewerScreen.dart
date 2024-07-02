
// Vehicle3DViewerScreen.dart

import 'package:flutter/material.dart';
import 'package:flutter_cube/flutter_cube.dart';

class Vehicle3DViewerScreen extends StatefulWidget {
  @override
  _Vehicle3DViewerScreenState createState() => _Vehicle3DViewerScreenState();
}

class _Vehicle3DViewerScreenState extends State<Vehicle3DViewerScreen> {
  Object? _vehicle;

  @override
  void initState() {
    super.initState();
    loadVehicle();
  }

  void loadVehicle() async {
    try {
      setState(() {
        _vehicle = null; // Clear previous state
      });
      _vehicle = Object(fileName: 'assets/vehicle.obj');
      setState(() {
        // State is updated once the vehicle is loaded
      });
    } catch (e) {
      print("Error loading 3D model: $e");
    }
  }

  void _onPartSelected(String partName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Selected part: $partName')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('3D Vehicle Viewer'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: loadVehicle,
          ),
        ],
      ),
      body: Center(
        child: _vehicle == null
            ? CircularProgressIndicator()
            : GestureDetector(
                onTapDown: (details) {
                  _onPartSelected('Part name'); // Placeholder for actual part detection logic
                },
                child: Cube(
                  onObjectCreated: (object) {
                    print("Object created: $object");
                  },
                  onSceneCreated: (Scene scene) {
                    scene.world.add(_vehicle!);
                    scene.camera.zoom = 10;
                    print("Scene created with object: $_vehicle");
                  },
                  interactive: true,
                ),
              ),
      ),
    );
  }
}
