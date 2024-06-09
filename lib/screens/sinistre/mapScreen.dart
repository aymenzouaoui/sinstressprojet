import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  final LatLng _initialLocation = LatLng(37.7749, -122.4194); // Example: San Francisco
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

  void _getAddressFromLatLng(LatLng latLng) async {
    // Implement the logic to retrieve address from latLng
    // You can use a geocoding API to get the address
    // For example, you can use the Google Geocoding API
    // Make sure to import necessary packages and add the API key
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
      ),
      body: Stack(
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
                  child: Icon(Icons.zoom_in),
                  onPressed: _onZoomIn,
                ),
                SizedBox(height: 8),
                FloatingActionButton(
                  mini: true,
                  child: Icon(Icons.zoom_out),
                  onPressed: _onZoomOut,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
