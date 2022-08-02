import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:legend_design_core/legend_design_core.dart' as core;
import 'package:legend_design_core/styles/legend_theme.dart';

import 'package:legend_design_core/styles/typography/legend_text.dart';
import 'package:legend_design_widgets/legendButton/legendButton.dart';
import 'package:legend_utils/extensions/extensions.dart';
import 'package:rl_racer/content/widgets/map/overlay/overlay.dart';
import 'package:rl_racer/content/widgets/map/providers/circuit_provider.dart';

import 'package:rl_racer/content/widgets/map/providers/points_provider.dart';
import 'package:rl_racer/repositories/directions/directions.dart';
import 'package:rl_racer/repositories/directions/directions_repo.dart';
import 'package:rl_racer/services/location/location.dart';

import 'info/circuit_point.dart';
import 'info/circuit_sector.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'providers/points_provider.dart';

const String style =
    '[{"elementType":"geometry","stylers":[{"color":"#242f3e"}]},{"elementType":"labels.text.fill","stylers":[{"color":"#746855"}]},{"elementType":"labels.text.stroke","stylers":[{"color":"#242f3e"}]},{"featureType":"administrative","elementType":"geometry","stylers":[{"visibility":"off"}]},{"featureType":"administrative.locality","elementType":"labels.text.fill","stylers":[{"color":"#d59563"}]},{"featureType":"poi","stylers":[{"visibility":"off"}]},{"featureType":"poi","elementType":"labels.text.fill","stylers":[{"color":"#d59563"}]},{"featureType":"poi.park","elementType":"geometry","stylers":[{"color":"#263c3f"}]},{"featureType":"poi.park","elementType":"labels.text.fill","stylers":[{"color":"#6b9a76"}]},{"featureType":"road","elementType":"geometry","stylers":[{"color":"#38414e"}]},{"featureType":"road","elementType":"geometry.stroke","stylers":[{"color":"#212a37"}]},{"featureType":"road","elementType":"labels.icon","stylers":[{"visibility":"off"}]},{"featureType":"road","elementType":"labels.text.fill","stylers":[{"color":"#9ca5b3"}]},{"featureType":"road.highway","elementType":"geometry","stylers":[{"color":"#746855"}]},{"featureType":"road.highway","elementType":"geometry.stroke","stylers":[{"color":"#1f2835"}]},{"featureType":"road.highway","elementType":"labels.text.fill","stylers":[{"color":"#f3d19c"}]},{"featureType":"transit","stylers":[{"visibility":"off"}]},{"featureType":"transit","elementType":"geometry","stylers":[{"color":"#2f3948"}]},{"featureType":"transit.station","elementType":"labels.text.fill","stylers":[{"color":"#d59563"}]},{"featureType":"water","elementType":"geometry","stylers":[{"color":"#17263c"}]},{"featureType":"water","elementType":"labels.text.fill","stylers":[{"color":"#515c6d"}]},{"featureType":"water","elementType":"labels.text.stroke","stylers":[{"color":"#17263c"}]}]';

/// State
final mapControllerProvider =
    StateProvider.autoDispose<GoogleMapController?>((ref) {
  return null;
});
final pointsProvider = StateNotifierProvider<PointsProvider, List<LatLng>>(
  (ref) {
    return PointsProvider();
  },
);
final circuitProvider =
    StateNotifierProvider<CircuitProvider, CircuitInfo>((ref) {
  return CircuitProvider(ref);
});

/// Future
final locationProvider = FutureProvider<CircuitPoint>((ref) async {
  return LocationUtils.utils.getUserLocation();
});

final connectionProvider =
    FutureProvider.family<List<CircuitSector>, List<CircuitSection>>(
  (ref, points) async {
    List<CircuitSector> sectors = [];

    for (CircuitSection section in points) {
      Directions? directions = await DirectionsRepository().getDirections(
        section.start,
        section.end,
      );

      if (directions != null) {
        sectors.add(
          CircuitSector(
            start: section.start,
            end: section.end,
            distance: directions.distance,
            connection: Polyline(
              polylineId: PolylineId("${directions.hashCode}"),
            ),
          ),
        );
      }
    }

    print(sectors);
    return sectors;
  },
);

class Map extends ConsumerWidget {
  const Map({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final position = ref.watch(locationProvider);
    final points = ref.watch(pointsProvider);
    final createPin = ref.watch(pinCreateProvider);

    return LayoutBuilder(builder: (context, _constraints) {
      final BoxConstraints constraints = _constraints;
      return SizedBox(
        height: constraints.maxHeight,
        width: constraints.maxWidth,
        child: Stack(
          children: [
            position.when(
              data: (data) {
                return GoogleMap(
                  padding: const EdgeInsets.all(00),
                  tileOverlays: {},
                  mapType: MapType.normal,
                  initialCameraPosition: data.asCameraPosition(),
                  onLongPress: (LatLng point) {
                    if (ref.read(pinCreateProvider)) {
                      print("Pressed @$point");
                      ref.read(pointsProvider.notifier).addPoint(point);
                    }
                  },
                  mapToolbarEnabled: false,
                  compassEnabled: false,
                  myLocationButtonEnabled: false,
                  myLocationEnabled: true,
                  zoomGesturesEnabled: true,
                  scrollGesturesEnabled: true,
                  tiltGesturesEnabled: true,
                  rotateGesturesEnabled: true,
                  zoomControlsEnabled: false,
                  onMapCreated: (GoogleMapController controller) {
                    ref.read(mapControllerProvider.notifier).state = controller;
                    // Map Styling
                    controller.setMapStyle(style);
                  },
                  onCameraMove: (a) {},

                  markers: {
                    for (LatLng pos in points)
                      Marker(
                        draggable: createPin,
                        markerId: MarkerId(
                          pos.hashCode.toString(),
                        ),
                        position: pos,
                        onDragEnd: (new_pos) {
                          print(new_pos);

                          ref
                              .read(pointsProvider.notifier)
                              .editPoint(pos, new_pos);
                        },
                        icon: BitmapDescriptor.defaultMarkerWithHue(
                          BitmapDescriptor.hueAzure,
                        ),
                      ),
                  },
                  /* polylines: csa.when(
                      data: (data) => data,
                      error: (e, s) => {},
                      loading: () => {},
                    ),*/
                  gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
                    Factory<OneSequenceGestureRecognizer>(
                      () => EagerGestureRecognizer(),
                    ),
                  },
                  //  polygons: ,
                );
              },
              error: (e, s) => error(),
              loading: () => const Center(
                child: SizedBox(
                  width: 64,
                  height: 64,
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
            MapOverlay(
              height: constraints.maxHeight,
              width: constraints.maxWidth,
            ),
          ],
        ),
      );
    });
  }

  Widget error() {
    return Container(
      child: LegendText(text: "Error Loading"),
    );
  }
}

extension ListUt<T> on List<T> {
  List<T> firstBack() {
    if (isNotEmpty) {
      add(first);
      return this;
    }
    return [];
  }
}
