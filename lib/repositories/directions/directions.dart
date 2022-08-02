import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Directions {
  final String duration;
  final String distance;
  final List<PointLatLng> connections;
  final LatLngBounds bounds;

  const Directions({
    required this.duration,
    required this.distance,
    required this.connections,
    required this.bounds,
  });

  factory Directions.fromJson(Map<String, dynamic> json) {
    print(json);

    final Map<String, dynamic> data =
        Map<String, dynamic>.from(json["routes"][0]);

    final north = data["bounds"]["northeast"];
    final south = data["bounds"]["southwest"];
    final bounds = LatLngBounds(
      southwest: LatLng(south["lat"], south["lng"]),
      northeast: LatLng(north["lat"], north["lng"]),
    );

    String distance = '';
    String duration = '';

    if ((data['legs'] as List).isNotEmpty) {
      final leg = data['legs'][0];
      duration = leg['duration']['text'];
      distance = leg['distance']['text'];
    }

    List<PointLatLng> connections = PolylinePoints().decodePolyline(
      data['overview_polyline']['points'],
    );

    return Directions(
      duration: duration,
      distance: distance,
      connections: connections,
      bounds: bounds,
    );
  }
}
