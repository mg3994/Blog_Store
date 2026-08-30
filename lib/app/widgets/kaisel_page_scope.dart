import 'package:material_ui/material_ui.dart';

class KaiselPageScope extends InheritedWidget {
  const KaiselPageScope({
    super.key,
    required this.isBottom,
    required super.child,
  });

  final bool isBottom;

  static KaiselPageScope? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<KaiselPageScope>();
  }

  @override
  bool updateShouldNotify(KaiselPageScope oldWidget) {
    return isBottom != oldWidget.isBottom;
  }
}