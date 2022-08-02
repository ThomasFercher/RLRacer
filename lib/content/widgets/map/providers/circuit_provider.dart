import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rl_racer/content/widgets/map/info/circuit_sector.dart';
import 'package:rl_racer/content/widgets/map/map.dart';

class CircuitProvider extends StateNotifier<CircuitInfo> {
  final Ref ref;

  CircuitProvider(this.ref)
      : super(CircuitInfo(
          [],
        ));

  void addSectors() {
    print(ref.read(pointsProvider));
  }
}

class CircuitInfo {
  final List<CircuitSector> sectors;

  CircuitInfo(this.sectors);
}
