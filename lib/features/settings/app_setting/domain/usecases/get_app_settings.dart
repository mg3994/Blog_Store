import '../entities/app_setting.dart';
import '../repositories/app_setting_repository.dart';

final class GetAppSettings {
  const GetAppSettings(this._repository);

  final AppSettingRepository _repository;

  Future<AppSetting> call() => _repository.getSettings();
}
