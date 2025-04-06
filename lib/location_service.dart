// import 'package:geolocator/geolocator.dart';

// class LocationVerificationService {
//   // Define your geofencing bounds here
//   final double topLeftLat = 12.0211;
//   final double topLeftLng = 77.5252;
//   final double bottomRightLat = 11.2716;
//   final double bottomRightLng = 77.6083;

//   // Function to check if user's position is inside the geofence
//   Future<bool> isUserWithinGeoFence(Position position) async {
//     final double userLat = position.latitude;
//     final double userLng = position.longitude;

//     bool isLatInRange = (userLat >= bottomRightLat && userLat <= topLeftLat);
//     bool isLngInRange = (userLng >= topLeftLng && userLng <= bottomRightLng);

//     return isLatInRange && isLngInRange;
//   }

//   // Function to get the user's current position
//   Future<Position?> getUserLocation() async {
//     bool serviceEnabled;
//     LocationPermission permission;

//     // Check if location services are enabled
//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       return null;
//     }

//     // Check location permissions
//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.deniedForever) {
//         return null; // Permissions are denied forever.
//       }
//     }

//     // Get the current position
//     Position position = await Geolocator.getCurrentPosition(
//       desiredAccuracy: LocationAccuracy.high,
//     );
//     return position;
//   }
// }
