import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:legend_design_core/legend_design_core.dart';
import 'package:legend_design_core/styles/legend_theme.dart';
import 'package:legend_design_widgets/legendButton/legendButton.dart';
import 'package:legend_utils/extensions/extensions.dart';
import 'package:rl_racer/content/widgets/map/info/circuit_point.dart';
import 'package:rl_racer/content/widgets/map/map.dart';
import 'package:rl_racer/content/widgets/map/overlay/overlay.dart';

class ActionsOverlay extends HookConsumerWidget {
  const ActionsOverlay({
    Key? key,
    required this.theme,
    required this.context,
    required this.width,
    required this.height,
    required this.maxHeight,
  }) : super(key: key);

  final LegendTheme theme;
  final BuildContext context;
  final double width;
  final double height;
  final double maxHeight;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final GoogleMapController? controller = ref.watch(mapControllerProvider);
    final position = ref.watch(locationProvider);
    final _create = ref.watch(createProvider);

    return Positioned(
      bottom: 4,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          ActionsButton(
            icon: Icons.screen_rotation_outlined,
            onPressed: () async {
              LatLng? current = await ref
                  .read(mapControllerProvider)
                  ?.getLatLng(
                    ScreenCoordinate(
                      x: ((width / 2) * MediaQuery.of(context).devicePixelRatio)
                          .toInt(),
                      y: ((maxHeight / 2) *
                              MediaQuery.of(context).devicePixelRatio)
                          .toInt(),
                    ),
                  );
              if (current != null) {
                controller?.animateCamera(
                  CameraUpdate.newCameraPosition(
                    current.fromLatLng().asCameraPosition(),
                  ),
                );
              }
            },
          ),
          ActionsButton(
            icon: _create ? Icons.save_rounded : Icons.add_location_alt,
            height: 48,
            width: 48,
            onPressed: () {
              ref.read(createProvider.notifier).state =
                  !ref.read(createProvider.notifier).state;
            },
          ),
          ActionsButton(
            icon: Icons.my_location_sharp,
            onPressed: () async {
              if (position.value != null) {
                await controller?.animateCamera(
                  CameraUpdate.newCameraPosition(
                    position.value!.asCameraPosition(),
                  ),
                );
              }
            },
          ),
        ].traillingPaddingRow(
          4,
        ),
      ),
      left: theme.sizing.spacing1,
      right: theme.sizing.spacing1,
    );
  }
}

class ActionsButton extends StatelessWidget {
  final IconData icon;
  final void Function() onPressed;

  final double height;
  final double width;

  const ActionsButton({
    Key? key,
    required this.icon,
    required this.onPressed,
    this.height = 32,
    this.width = 32,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LegendTheme theme = context.watch<LegendTheme>();

    return LegendButton(
      style: LegendButtonStyle.confirm(
        color: theme.colors.primary,
        activeColor: theme.colors.selection,
        height: height,
        width: width,
      ),
      text: Icon(
        icon,
        color: theme.colors.onPrimary.lighten(),
        size: theme.sizing.iconSize1,
      ),
      onPressed: onPressed,
    );
  }
}
