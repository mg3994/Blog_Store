import 'package:flutter/rendering.dart' show RendererBinding;
import 'package:material_ui/material_ui.dart'
    show runApp ;

import 'app/bootstarp.dart';

void main() {
  // Obtain the single global WidgetsBinding instance
  // final binding = WidgetsFlutterBinding.ensureInitialized();
  // binding.deferFirstFrame();

  final binding = RendererBinding.instance;

  binding.deferFirstFrame();

  return runApp(BootStrap(onReady: () => binding.allowFirstFrame()));
}
