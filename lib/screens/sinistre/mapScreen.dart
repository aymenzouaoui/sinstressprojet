import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  final LatLng _initialLocation = LatLng(36.8665, 10.1647); // Coordinates for Ariana, Tunis
  double _currentZoom = 14.0; // Initial zoom level

  Marker? _currentMarker; // Single marker
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loading = false; // No need to load current location
  }

  void _onTap(TapPosition tapPosition, LatLng latLng) {
    setState(() {
      _currentMarker = Marker(
        width: 80.0,
        height: 80.0,
        point: latLng,
        builder: (ctx) => Container(
          child: Icon(
            Icons.location_on,
            color: Colors.red,
            size: 40.0,
          ),
        ),
      );
    });
    _getAddressFromLatLng(latLng);
  }

  Future<void> _getAddressFromLatLng(LatLng latLng) async {
    final url = 'https://nominatim.openstreetmap.org/reverse?format=json&lat=${latLng.latitude}&lon=${latLng.longitude}&zoom=18&addressdetails=1';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final address = data['display_name'];
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Address: $address'),
        ),
      );
      Navigator.pop(context, address); // Return the address to the previous screen
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to fetch address'),
        ),
      );
    }
  }

  void _onZoomIn() {
    setState(() {
      _currentZoom += 1;
      if (_currentZoom > 18.0) _currentZoom = 18.0; // Prevent excessive zoom in
    });
    _mapController.move(_mapController.center, _currentZoom);
  }

  void _onZoomOut() {
    setState(() {
      _currentZoom -= 1;
      if (_currentZoom < 2.0) _currentZoom = 2.0; // Prevent excessive zoom out
    });
    _mapController.move(_mapController.center, _currentZoom);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Interactive Map'),
        centerTitle: true,
        backgroundColor: Color(0xFF0866FF),
        leading: Icon(Icons.map),
      ),
      body: Builder(
        builder: (context) {
          return Stack(
            children: [
              if (_loading)
                Center(child: CircularProgressIndicator())
              else
                FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    center: _initialLocation,
                    zoom: _currentZoom,
                    onTap: _onTap,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                      subdomains: ['a', 'b', 'c'],
                    ),
                    if (_currentMarker != null)
                      MarkerLayer(
                        markers: [_currentMarker!],
                      ),
                  ],
                ),
              Positioned(
                top: 10,
                right: 10,
                child: Column(
                  children: [
                    FloatingActionButton(
                      mini: true,
                      backgroundColor: Color(0xFF0866FF),
                      child: Icon(Icons.zoom_in),
                      onPressed: _onZoomIn,
                    ),
                    SizedBox(height: 8),
                    FloatingActionButton(
                      mini: true,
                      backgroundColor: Color(0xFF0866FF),
                      child: Icon(Icons.zoom_out),
                      onPressed: _onZoomOut,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
