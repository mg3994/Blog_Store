import 'package:material_ui/material_ui.dart'
    show runApp, WidgetsFlutterBinding, Widget, WidgetsBinding;

import 'app/app.dart';

void main() {
  // Obtain the single global WidgetsBinding instance
  final binding = WidgetsFlutterBinding.ensureInitialized();
  binding.deferFirstFrame();

  return runApp(BootStrap(onReady: () => binding.allowFirstFrame()));
}
