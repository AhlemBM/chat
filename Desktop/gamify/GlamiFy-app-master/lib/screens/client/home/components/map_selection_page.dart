import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapSelectionPage extends StatefulWidget {
  const MapSelectionPage({super.key});

  @override
  _MapSelectionPageState createState() => _MapSelectionPageState();
}

class _MapSelectionPageState extends State<MapSelectionPage> {
  late GoogleMapController mapController;

  LatLng _selectedLocation = LatLng(37.7749, -122.4194); // Default location (San Francisco)

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _selectLocation(LatLng location) {
    setState(() {
      _selectedLocation = location; // Store selected location
    });
    Navigator.pop(context, _selectedLocation); // Return selected location
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Location'),
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _selectedLocation,
          zoom: 12,
        ),
        onTap: _selectLocation, // Handle map tap to select location
        markers: {
          Marker(
            markerId: MarkerId('selected-location'),
            position: _selectedLocation,
          ),
        },
      ),
    );
  }
}
