import 'package:google_maps_flutter/google_maps_flutter.dart';

class CircuitPoint {
  final double latitude;
  final double longitude;

  const CircuitPoint(
    this.latitude,
    this.longitude,
  );
}

extension MapsUtilities on CircuitPoint {
  CameraPosition asCameraPosition() => CameraPosition(
        target: LatLng(latitude, longitude),
        zoom: 16,
      );

  LatLng toLatLng() => LatLng(latitude, longitude);
}

extension TypeConversion on LatLng {
  CircuitPoint fromLatLng() => CircuitPoint(latitude, longitude);
}
