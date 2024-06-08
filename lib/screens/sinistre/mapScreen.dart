
/*import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapScreen extends StatefulWidget {
  final LatLng initialPosition;

  const MapScreen({super.key, required this.initialPosition});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late MapController _mapController;
  late LatLng _selectedPosition;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _selectedPosition = widget.initialPosition;
  }

  void _onTap(LatLng position) {
    setState(() {
      _selectedPosition = position;
      _mapController.move(_selectedPosition, 13.0); // Move the map to the new position
    });
  }

  void _onConfirm() {
    Navigator.of(context).pop(_selectedPosition);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Location'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _onConfirm,
          ),
        ],
      ),
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          initialCenter: _selectedPosition,
          initialZoom: 13.0,
          onTap: (_, latLng) => _onTap(latLng),
        ),
        children: [
          TileLayer(
            urlTemplate:
                "https://api.mapbox.com/styles/v1/mapbox/streets-v11/tiles/{z}/{x}/{y}?access_token=sk.eyJ1IjoiYXltZW56b3Vhb3VpMTEiLCJhIjoiY2x4M3c2MnB3MDkxdjJxc2N5YzMyNHY4bSJ9.PBU1lhKe5028Jl9s3Jw2iA",
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: _selectedPosition,
                child: const Icon(
                  Icons.location_on,
                  color: Colors.red,
                  size: 40,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
*/