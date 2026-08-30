import 'package:material_ui/material_ui.dart' show ThemeMode;

import '../repositories/app_setting_repository.dart';

final class UpdateThemeMode {
  const UpdateThemeMode(this._repository);

  final AppSettingRepository _repository;

  Future<void> call(ThemeMode themeMode) =>
      _repository.updateThemeMode(themeMode);
}
