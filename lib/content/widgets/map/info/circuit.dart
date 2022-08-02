import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'circuit_sector.dart';

class Circuit {
  final Set<CircuitSector> sectors;

  Circuit({
    required this.sectors,
  });

  Set<Polyline> getConnections() => sectors.map((s) => s.connection).toSet();
}
