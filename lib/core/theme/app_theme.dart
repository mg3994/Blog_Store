import 'package:material_ui/material_ui.dart'
    show ThemeData, ColorScheme, Colors, Color;

abstract final class AppTheme {
  static ThemeData light({Color seed = Colors.indigo}) =>
      ThemeData.light(useMaterial3: true)
          .copyWith(colorScheme: ColorScheme.fromSeed(seedColor: seed));

  static ThemeData dark({Color seed = Colors.indigo}) =>
      ThemeData.dark(useMaterial3: true)
          .copyWith(colorScheme: ColorScheme.fromSeed(seedColor: seed));
}
