import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';

class MapScreen extends StatefulWidget {
  final String userName;
  final String userEmail;

  const MapScreen({super.key, required this.userName, required this.userEmail});

  @override
  State<MapScreen> createState() => _MapScreenState();
}
class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;

  final LatLng _center = const LatLng(13.0827, 80.2707);

  @override
  void initState() {
    super.initState();

    // Initialize the map with API key directly
    const String apiKey = 'AIzaSyBQ-JTbsBf1D6yayoW3mGvNHo0aJja6ZFE'; // 👉 Replace this
    GoogleMapsFlutterPlatform.instance.initializeWithApiKey(apiKey);
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 12.0,
          ),
          mapType: MapType.normal,
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          zoomControlsEnabled: true,
        ),
      ),
    );
  }
}

extension on GoogleMapsFlutterPlatform {
  void initializeWithApiKey(String apiKey) {}
}
