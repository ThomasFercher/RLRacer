import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rl_racer/repositories/directions/directions.dart';

class PointsProvider extends StateNotifier<List<LatLng>> {
  PointsProvider() : super([]);

  void addPoint(LatLng point) {
    super.state = [...state, point];
  }

  void editPoint(LatLng old, LatLng _new) {
    List<LatLng> list = state;
    int i = list.indexWhere((element) => old == element);
    list[i] = _new;
    state = [...list];
  }

  void removePoint(LatLng point) {}
}

class CircuiStatetProvider extends StateNotifier<Set<Polyline>> {
  CircuiStatetProvider() : super({});

  void loadNew(Set<Polyline> a) {
    state = a;
  }
}
