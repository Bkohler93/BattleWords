part of 'settings_cubit.dart';

enum SettingsStatus { loading, loaded }

extension SettingsStautsX on SettingsStatus {
  bool get isLoading => this == SettingsStatus.loading;
  bool get isLoaded => this == SettingsStatus.loaded;
}

class SettingsState extends Equatable {
  const SettingsState({
    this.isFirstLaunch = true,
    this.status = SettingsStatus.loading,
  });

  final bool isFirstLaunch;
  final SettingsStatus status;

  @override
  List<Object> get props => [isFirstLaunch, status];
}
