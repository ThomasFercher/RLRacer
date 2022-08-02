import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'circuit_point.dart';

class CircuitSection {
  final CircuitPoint start;
  final CircuitPoint end;

  CircuitSection({
    required this.start,
    required this.end,
  });
}

class CircuitSector extends CircuitSection {
  final String distance;
  final Polyline connection;

  CircuitSector({
    required super.start,
    required super.end,
    required this.distance,
    required this.connection,
  });
}
