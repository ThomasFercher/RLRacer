import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import 'package:rl_racer/content/widgets/map/info/circuit_point.dart';

class LocationUtils {
  final Location service;
  static LocationUtils? instance;
  static LocationUtils get utils {
    instance ??= LocationUtils(Location());
    return instance!;
  }

  bool? permissions;

  LocationUtils(this.service);

  Future<bool> checkPermissions() async {
    bool _serviceEnabled;
    _serviceEnabled = await service.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await service.requestService();
      if (_serviceEnabled) return false;
    }
    PermissionStatus _permissionGranted;
    _permissionGranted = await service.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await service.requestPermission();
      if (_permissionGranted != PermissionStatus.denied) return false;
    }

    print(
      "Location Permissions: status:$_permissionGranted; Service enabled:$_serviceEnabled",
    );

    return true;
  }

  Future<CircuitPoint> getUserLocation() async {
    permissions ??= await checkPermissions();

    if (permissions!) {
      LocationData _data;
      _data = await Location.instance.getLocation();
      double? lon = _data.longitude;
      double? lat = _data.latitude;
      if (lon != null && lat != null) {
        return CircuitPoint(lat, lon);
      }
    }
    return const CircuitPoint(0, 0);
  }
}
