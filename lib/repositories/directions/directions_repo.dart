import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rl_racer/content/widgets/map/info/circuit_point.dart';
import 'package:rl_racer/repositories/directions/directions.dart';

import '.env.dart';

class DirectionsRepository {
  final String baseUrl = 'https://maps.googleapis.com/maps/api/directions/json';

  late final Dio _dio;

  DirectionsRepository({Dio? dio}) {
    _dio = dio ?? Dio();
  }

  Future<Directions?> getDirections(
      CircuitPoint first, CircuitPoint secod) async {
    final Response response = await _dio.get(
      baseUrl,
      queryParameters: {
        "origin": '${first.latitude},${first.longitude}',
        "destination": '${secod.latitude},${secod.longitude}',
        "key": apiKey,
      },
    );

    if (response.statusCode == 200) {
      Map<dynamic, dynamic> map = response.data;
      // check if Data is not available or if there is a error.
      if ((map["status"] != 'OK') || (map["routes"] as List).isEmpty) {
        return null;
      }

      return Directions.fromJson(response.data);
    }
    return null;
  }
}
