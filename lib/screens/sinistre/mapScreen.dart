import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart' as loc;
import 'package:geocoding/geocoding.dart' as geo;

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  loc.Location _location = loc.Location();
  LatLng? _currentLocation;
  LatLng? _selectedLocation;
  bool _loading = true;
  TextEditingController _searchController = TextEditingController();
  double _currentZoom = 14.0; // Initial zoom level

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      final locationData = await _location.getLocation();
      setState(() {
        _currentLocation = LatLng(locationData.latitude!, locationData.longitude!);
        _loading = false;
      });
      _mapController.move(_currentLocation!, _currentZoom);
    } catch (e) {
      print("Could not get current location: $e");
      setState(() {
        _loading = false;
      });
    }
  }

  void _onTap(LatLng latLng) {
    setState(() {
      _selectedLocation = latLng;
    });
  }

  Future<void> _searchLocation() async {
    if (_searchController.text.isEmpty) {
      return;
    }
    try {
      List<geo.Location> locations = await geo.locationFromAddress(_searchController.text);
      if (locations.isNotEmpty) {
        final location = locations.first;
        final latLng = LatLng(location.latitude, location.longitude);
        _mapController.move(latLng, _currentZoom);
        setState(() {
          _selectedLocation = latLng;
        });
      }
    } catch (e) {
      print("Could not find location: $e");
    }
  }

  void _onZoomIn() {
    setState(() {
      _currentZoom += 1;
    });
    _mapController.move(_mapController.center, _currentZoom);
  }

  void _onZoomOut() {
    setState(() {
      _currentZoom -= 1;
    });
    _mapController.move(_mapController.center, _currentZoom);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        appBar: AppBar(
          title: Text('OpenStreetMap Map'),
        ),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('OpenStreetMap Map'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: _searchLocation,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search location',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: _searchLocation,
                ),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    center: _currentLocation,
                    zoom: _currentZoom,
                    onTap: (tapPosition, point) => _onTap(point),
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                      subdomains: ['a', 'b', 'c'],
                    ),
                    MarkerLayer(
                      markers: [
                        if (_selectedLocation != null)
                          Marker(
                            width: 80.0,
                            height: 80.0,
                            point: _selectedLocation!,
                            builder: (ctx) => Container(
                              child: Icon(
                                Icons.location_on,
                                color: Colors.red,
                                size: 40.0,
                              ),
                            ),
                          ),
                        if (_currentLocation != null)
                          Marker(
                            width: 80.0,
                            height: 80.0,
                            point: _currentLocation!,
                            builder: (ctx) => Container(
                              child: Icon(
                                Icons.my_location,
                                color: Colors.blue,
                                size: 40.0,
                              ),
                            ),
                          ),
                      ],
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
          ),
        ],
      ),
    );
  }
}
