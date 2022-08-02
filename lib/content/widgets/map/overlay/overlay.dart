import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:legend_design_core/legend_design_core.dart' as core;
import 'package:legend_design_core/styles/legend_theme.dart';
import 'package:legend_design_widgets/legendButton/legendButton.dart';
import 'package:legend_utils/legend_utils.dart';
import 'package:rl_racer/content/widgets/map/map.dart';
import 'package:rl_racer/content/widgets/map/overlay/actions.dart';
import 'package:rl_racer/content/widgets/map/overlay/create.dart';

/// Value
final createProvider = StateProvider<bool>((ref) {
  return false;
});
final pinCreateProvider = StateProvider<bool>((ref) {
  return false;
});

final createStateProvider = Provider((ref) => ref.watch(createProvider));

class MapOverlay extends HookConsumerWidget {
  final double height;
  final double width;

  const MapOverlay({
    required this.height,
    required this.width,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    LegendTheme theme = context.watch<LegendTheme>();
    final _controller = useAnimationController(
      duration: const Duration(
        milliseconds: 280,
      ),
      upperBound: 1.0,
      lowerBound: 0.0,
      initialValue: 0.0,
    );

    bool _create = ref.watch(createStateProvider);
    useValueChanged<bool, Function(bool, bool)>(_create, (_, __) {
      print(_create);
      if (!_controller.isAnimating) {
        if (_create) {
          _controller.forward();
        } else {
          _controller.reverse();
        }
      }
    });

    return SizedBox(
      height: height,
      width: width,
      child: AnimatedBuilder(
        builder: (context, snapshot) {
          double createWidth = 48;
          double right = _controller.value * (createWidth) - createWidth;
          return Stack(
            children: [
              ActionsOverlay(
                theme: theme,
                context: context,
                width: width,
                height: 64,
                maxHeight: height,
              ),
              CreateOverlay(
                right: right,
                width: createWidth,
                maxHeight: height,
              ),
            ],
          );
        },
        animation: _controller,
      ),
    );
  }
}
