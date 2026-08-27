import 'package:material_ui/material_ui.dart'
    show ThemeData, ColorScheme, Colors;

abstract final class AppTheme {
  static ThemeData? get light => ThemeData.light(useMaterial3: true)
      .copyWith(colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo));
  static ThemeData? get dark => ThemeData.dark(useMaterial3: true)
      .copyWith(colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo));
}
