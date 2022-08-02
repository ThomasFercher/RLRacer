import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:legend_design_core/legend_app.dart';
import 'package:legend_design_core/styles/typography/legend_text.dart';
import 'config/routes.dart';
import 'config/theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ProviderScope(
      child: LegendApp(
        routesDelegate: const RoutesTheme(),
        themeDelegate: const AppTheme(),
        logo: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            LegendText(
              text: "RL Racer",
              textStyle: GoogleFonts.lobsterTwo(
                color: Colors.white,
                fontSize: 32,
              ),
            ),
          ],
        ),
        title: "Legend Template",
        buildSplashscreen: (context, theme) {
          return Container(
            color: theme.colors.primary,
          );
        },
      ),
    ),
  );
}
