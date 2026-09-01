import '../repositories/app_setting_repository.dart';

final class ResetAppSettings {
  const ResetAppSettings(this._repository);

  final AppSettingRepository _repository;

  Future<void> call() => _repository.resetToDefaultSettings();
}
