import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:legend_design_core/legend_design_core.dart';
import 'package:legend_design_core/styles/legend_theme.dart';
import 'package:legend_design_core/widgets/size_info.dart';
import 'package:legend_design_widgets/legendButton/legendButton.dart';
import 'package:legend_utils/legend_utils.dart';
import 'package:rl_racer/content/widgets/map/overlay/overlay.dart';

class CreateOverlay extends HookConsumerWidget {
  final double right;
  final double width;
  final double maxHeight;

  const CreateOverlay({
    required this.right,
    required this.width,
    required this.maxHeight,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    LegendTheme theme = context.watch<LegendTheme>();
    bool create = ref.watch(pinCreateProvider);

    double center = (maxHeight / 2) - 42;

    return Positioned(
      right: right,
      top: center,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.horizontal(
            left: Radius.circular(theme.sizing.radius1),
          ),
          color: theme.colors.background4,
        ),
        //    padding: const EdgeInsets.all(4),
        width: width,
        child: Column(
          children: [
            LegendButton(
              style: LegendButtonStyle.confirm(
                color: create ? theme.colors.secondary : theme.colors.primary,
                activeColor: theme.colors.onSecondary,
                height: 24,
                width: 24,
              ),
              text: Icon(
                Icons.pin_drop_rounded,
                color:
                    create ? theme.colors.onSecondary : theme.colors.onPrimary,
                size: theme.sizing.iconSize1,
              ),
              onPressed: () {
                ref.read(pinCreateProvider.notifier).state = !create;
              },
            ),
          ],
        ),
      ),
    );
  }
}
