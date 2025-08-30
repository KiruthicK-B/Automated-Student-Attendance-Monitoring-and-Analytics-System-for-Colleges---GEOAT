import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MapScreen extends StatefulWidget {
  final String userName;
  final String userEmail;

  const MapScreen({
    super.key,
    required this.userName,
    required this.userEmail,
  });

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? mapController;
  final Set<Marker> _markers = {};
  List<LatLng> _locations = [];

  @override
  void initState() {
    super.initState();
    _fetchLocations();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    if (_locations.isNotEmpty) {
      mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(_locations.last, 16.0),
      );
    }
  }

  Future<void> _fetchLocations() async {
    final collectionName = widget.userName.replaceAll(' ', '');

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection(collectionName)
          .orderBy('date', descending: false)
          .get();

      List<LatLng> fetchedLocations = [];

      for (var doc in snapshot.docs) {
        final data = doc.data();
        final locationStr = data['location'];

        if (locationStr != null && locationStr.contains("Lat:")) {
          final latLng = _parseLatLng(locationStr);
          if (latLng != null) {
            fetchedLocations.add(latLng);
            _markers.add(
              Marker(
                markerId: MarkerId(doc.id),
                position: latLng,
                infoWindow: InfoWindow(
                  title: data['date'] ?? 'Check-in',
                  snippet: locationStr,
                ),
              ),
            );
          }
        }
      }

      if (mounted) {
        setState(() {
          _locations = fetchedLocations;
        });

        // Optional: Zoom to last marker after loading
        if (_locations.isNotEmpty && mapController != null) {
          mapController!.animateCamera(
            CameraUpdate.newLatLngZoom(_locations.last, 16.0),
          );
        }
      }
    } catch (e) {
      print('❌ Error fetching check-in locations: $e');
    }
  }

  LatLng? _parseLatLng(String locationStr) {
    try {
      final parts = locationStr.split(',');
      final latStr = parts[0].split(':')[1].trim();
      final lngStr = parts[1].split(':')[1].trim();

      return LatLng(double.parse(latStr), double.parse(lngStr));
    } catch (e) {
      print("⚠️ Failed to parse LatLng from: $locationStr");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: _locations.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _locations.last,
                zoom: 14.0,
              ),
              markers: _markers,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              zoomControlsEnabled: true,
              mapType: MapType.normal,
            ),
    );
  }
}
