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

  SettingsState copyWith({bool? isFirstLaunch, SettingsStatus? status}) {
    return SettingsState(
      isFirstLaunch: isFirstLaunch ?? this.isFirstLaunch,
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [isFirstLaunch, status];
}
