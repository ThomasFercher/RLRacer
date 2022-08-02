import 'dart:async';

import 'package:flutter/widgets.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:legend_design_core/layout/scaffold/routebody/legend_route_body.dart';
import 'package:legend_design_core/legend_design_core.dart';
import 'package:legend_design_core/styles/legend_theme.dart';
import 'package:legend_design_core/styles/typography/legend_text.dart';
import 'package:rl_racer/content/widgets/map/map.dart';

class Screen1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    LegendTheme theme = context.watch<LegendTheme>();

    double size = 96;

    return LegendRouteBody(
      singlePage: true,
      disableContentDecoration: true,
      builder: (c, s) {
        return Container(
          height: s.height,
          child: Map(),
        );
      },
    );
  }
}
